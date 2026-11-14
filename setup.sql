-- Seoul Kitchen Traction: run once in the Supabase SQL editor.
create table if not exists public.docs (
  col text not null,
  id text not null,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now(),
  primary key (col, id)
);
alter table public.docs enable row level security;
-- Only signed-in team members can read or change anything.
create policy "team can read"   on public.docs for select to authenticated using (true);
create policy "team can insert" on public.docs for insert to authenticated with check (true);
create policy "team can update" on public.docs for update to authenticated using (true) with check (true);
create policy "team can delete" on public.docs for delete to authenticated using (true);
alter publication supabase_realtime add table public.docs;

create or replace function public.jsonb_deep_merge(a jsonb, b jsonb) returns jsonb
language sql immutable as $$
  select case
    when jsonb_typeof(a) = 'object' and jsonb_typeof(b) = 'object' then (
      select coalesce(jsonb_object_agg(k,
        case when a ? k and b ? k then public.jsonb_deep_merge(a -> k, b -> k)
             when b ? k then b -> k else a -> k end), '{}'::jsonb)
      from (select jsonb_object_keys(a) as k union select jsonb_object_keys(b)) s)
    else b end
$$;
create or replace function public.merge_doc(p_col text, p_id text, p_patch jsonb) returns void
language sql security invoker as $$
  update public.docs set data = public.jsonb_deep_merge(data, p_patch), updated_at = now()
  where col = p_col and id = p_id
$$;
revoke execute on function public.merge_doc(text, text, jsonb) from anon;
