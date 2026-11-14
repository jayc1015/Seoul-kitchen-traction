# Seoul Kitchen Traction

The leadership team's scorecard, rocks, to-dos, issues, headlines, weekly meeting, vision and accountability chart, as a single-page website.

- `index.html` is the whole site. It is served by GitHub Pages.
- Data lives in a Supabase database. Nothing loads until a team member signs in.
- `setup.sql` creates the database table and its access rules. Run it once in the Supabase SQL editor.
- `seed.sql` holds the imported starting data. Run it once after `setup.sql`. It is listed in `.gitignore` so the numbers stay out of the repository.

## Connecting the database

In `index.html`, replace `YOUR_SUPABASE_URL` and `YOUR_SUPABASE_ANON_KEY` with the values from Supabase under Project Settings, API. The anon key is meant to be public; the access rules in `setup.sql` are what protect the data.

## Team access

In Supabase, turn off public sign-ups (Authentication, Sign In / Providers) and invite each team member by email (Authentication, Users). Add the site address under Authentication, URL Configuration.
