# Adding Your Art

Everything lives under the **`content`** folder. Each folder there is a gallery,
and its name becomes a menu item.

## Add a piece to an existing gallery
1. Go to the gallery's folder under `content/` on GitHub (e.g. `content/01-creatures`).
2. Click **Add file → Upload files**.
3. Drag your image in. Click **Commit changes**.
4. Wait ~1 minute, refresh your site — it's there.

## Make a brand-new gallery
1. In `content/`, choose **Add file → Create new file**.
2. Type the folder and a placeholder name, e.g. `characters/placeholder.txt`
   (GitHub needs a file to create a folder). Commit.
3. Upload your images into that new `characters` folder.
4. A new **Characters** menu item appears automatically.

## Control the order of galleries
Put a number and a dash in front of the folder name:
- `01-creatures`, `02-environments`, `03-characters`
The number decides the menu order and is hidden from visitors (they just see
"Creatures", "Environments", "Characters").

## Control the order of images
Same trick on the image files: `01-the-hollow.jpg`, `02-swamp-king.jpg`.
The number is hidden; the caption shows "The Hollow", "Swamp King".

## Captions
The **file name** becomes the caption, tidied up:
`swamp-king.jpg` → "Swamp King". Dashes become spaces; words are capitalised.

## Galleries inside galleries
Put a folder inside a gallery folder to make a **sub-gallery**
(e.g. `environments/ruins`). It shows up as its own tile inside the parent.

## Optional: a description or custom title for a gallery
Only if you want to. Add a file called `_index.md` inside the gallery folder:

```
---
title: "My Custom Title"
---

A sentence or two describing this gallery.
```

You never *have* to do this — folders work fine on their own.
