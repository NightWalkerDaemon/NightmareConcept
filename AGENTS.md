# AGENTS.md — rules for AI coding agents working on this repo

This is **Holly Warren's concept-art portfolio** — a Hugo site, live at
https://nightmareconcept.art. An AI coding agent (e.g. OpenCode running on a local
model) may help Holly edit it. Follow these rules.

## Golden rules
1. **NEVER generate, create, edit, or alter Holly's artwork.** The images are hers.
2. **NEVER decide the visual style yourself.** Only implement the specific direction
   Holly gives you (e.g. "make the background charcoal, links cold blue"). Don't
   impose taste or "improve" the design unprompted.
3. **All look-and-feel lives in `assets/css/tokens.css`** (CSS variables). Make
   styling changes there.
4. **Don't touch `layouts/`, `scripts/`, `.github/`, or `hugo.toml`** unless Holly
   explicitly asks. If a task needs those, or a build breaks, stop and tell her to
   ask Richard / Claude.

## How the site works (so your edits are correct)
- Content lives under `content/`. Each folder = a gallery; the folder name = a menu item.
- A leading number like `01-` sets order and is hidden from visitors (`01-creatures` → "Creatures").
- Image filenames become captions, tidied: `swamp-king.jpg` → "Swamp King".
- A folder inside a gallery folder is a sub-gallery.
- An optional `_index.md` in a folder can set a custom `title:` and a description.
- Pushing to `main` rebuilds the live site automatically (~1 min). A failed build
  leaves the live site untouched — it won't break, it just won't update.

## Adding a web font (common styling request)
If Holly asks to use a custom font, it needs THREE things, or it silently won't load:
1. The font file under `static/fonts/...` (served as-is at `/fonts/...`).
2. An `@font-face` rule (put it in `assets/css/tokens.css` or `assets/css/main.css`)
   pointing at that `/fonts/...` path.
3. The relevant `--font-*` variable in `tokens.css` set to that font's family name.

## Working style
- Keep changes small and focused. Show the diff and explain it in plain English.
- Everything is in git — one logical change per commit, so it's easy to undo.
- Writing tasks (About bio, alt-text, captions): draft in Holly's voice; let her edit.

See `assistant/site-assistant-prompt.md` for the fuller briefing and `docs/holly/`
for the human-facing guides.
