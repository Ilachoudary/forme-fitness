# Forme — Personal Fitness Coach

A functional mobile-first fitness and fat-loss tracking prototype built with plain HTML/CSS/JavaScript.

## Run
Open `index.html` directly in a browser, or serve the folder:

```bash
python3 -m http.server 8080
```

Then visit http://localhost:8080.

## Persistence
The app persists meal completion, substitutions, portions, water, steps, workout sets/reps/weights, check-ins, reminders, and target edits in browser `localStorage`.

## Backend-ready architecture
The current version intentionally uses a local persistence layer for zero-setup use. `supabase.sql` provides a starting relational schema and RLS policies for migrating persistence to Supabase.


## Install on a phone (PWA)
Serve this folder over HTTPS (GitHub Pages, Netlify, Vercel, Cloudflare Pages, etc.). Then:
- iPhone/iPad: open the URL in Safari → Share → Add to Home Screen.
- Android: open the URL in Chrome → Install app / Add to Home screen.

The app works offline after its first successful load and stores fitness logs on the device using localStorage. Browser notifications work while the app/browser can run. Fully reliable closed-app scheduled reminders require Web Push with a backend or native packaging (Capacitor/Expo).
