# Maintaining the Site

## Rename a gallery
Rename the folder (or change the `title` in its optional `_index.md`).
The menu updates automatically.

## Reorder things
Change the number prefixes (`01-`, `02-`, …) on folders or files.

## Edit your About page
Open `content/about.md`, click the pencil ✏️, write your bio, commit.

## Change the look (colours & fonts) — this is YOURS
Open `assets/css/tokens.css`. Everything visual is in there with comments:
background colour, text colour, accent colour, fonts, spacing. Change a value,
commit, and the whole site restyles. Easiest of all: tell your AI helper what
mood you want and let it edit this file for you.

This is the file for making the site feel authentically *you*. The structure
won't fight you — restyle as boldly as you like.

## If something looks wrong
1. Check the **Actions** tab on GitHub — a red ✗ means the last build failed.
2. Click it to see the error (often a typo in `_index.md`).
3. If you're stuck, ask your AI helper or Dad. Your art is safe — nothing you
   upload is ever lost by a failed build.
