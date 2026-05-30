# Nightmare Concept — Holly Warren's Portfolio

A folder-driven Hugo portfolio site. Make folders, drop in images, and the site
builds its own galleries and navigation. Big images are resized automatically.

## For Holly
Start here: [`docs/holly/01-getting-started.md`](docs/holly/01-getting-started.md).

## For developers
- Local preview: `bash scripts/dev.sh` (needs Hugo **extended**).
- The build runs `scripts/build-galleries.sh` over a copy of `content/` to turn
  every folder into a Hugo section, then `hugo --minify`.
- Deploy: GitHub Actions (`.github/workflows/deploy.yml`) on push to `main`.
- All look-and-feel lives in `assets/css/tokens.css`.

See [`docs/HANDOFF.md`](docs/HANDOFF.md) for ownership, domain, and design-pass steps.
