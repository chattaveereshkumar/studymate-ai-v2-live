# StudyMate AI V2 — complete starter project

A mobile-first HTML/CSS/JavaScript study workspace starter with:
- Login/create-account demo mode
- Dashboard, subjects, exams, tasks/timetable, focus timer, progress, profile
- General learning assistant demo responses (not live AI)
- Browser-local persistence and JSON export
- Supabase SQL schema with Row Level Security for a future real multi-user deployment
- Responsive layout for phones and desktops

## Important limitations

**This package is a working front-end starter, not a production-secure multi-user app yet.**
Demo accounts and data are stored in the current browser's local storage. They are not secure, do not sync between devices, and should not be used for real passwords or private information. The assistant uses fixed example responses; it does not call an AI model.

For a production release, connect Supabase Auth/database from `js/config.js` and implement database reads/writes in the app. For live AI, add a server-side endpoint that calls your chosen model provider; never expose a secret API key in browser JavaScript.

## Run on a phone

1. Upload this folder to a new GitHub repository (do not overwrite your older StudyMate V1 repo).
2. In GitHub, open **Settings → Pages**.
3. Under **Build and deployment**, select **Deploy from a branch**, choose `main` and `/ (root)`, then Save.
4. Wait for deployment; GitHub will show the live URL on the Pages screen.

## Supabase setup (when ready)

1. Create/use a Supabase project.
2. Open SQL Editor and run `supabase/schema.sql`.
3. Add your Supabase project URL and publishable/anon browser key to `js/config.js` only after the app code has been updated to use Supabase Auth and database APIs.
4. Keep RLS enabled. Never use a `service_role` key in client code.

## File structure

- `index.html` — app shell and forms
- `css/style.css` — responsive styling
- `js/app.js` — browser interactions and demo data
- `js/config.js` — safe client configuration placeholder
- `supabase/schema.sql` — database tables and per-user row security
- `manifest.webmanifest` — installable-app metadata
