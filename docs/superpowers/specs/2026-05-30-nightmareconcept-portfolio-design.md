# nightmareconcept.art — Design Spec

**Date:** 2026-05-30
**Owner (final):** Holly Warren — concept artist, studying at Escape Studios
**Builder:** Richard (with Claude), handing the finished, owned repo to Holly
**Status:** Approved design — ready for implementation planning

---

## 1. Purpose

A portfolio website for Holly's concept art. Image-forward, fast, and — most
importantly — **owned and maintained by Holly herself** with no coding required.
The working domain idea is `nightmareconcept.art` (not yet confirmed by Holly;
the site is built domain-agnostic and the custom domain is wired up at the end).

### Success criteria
- Holly can add, organise, and reorder her artwork using only folders and image
  files via GitHub's web UI — no code, no config required.
- The site looks **authentically hers** — her aesthetic, never AI-generated art
  or an AI-imposed look.
- Big image exports (10–40MB) load fast for visitors (automatic resizing).
- Holly owns the repo on her own GitHub account.
- Holly has clear, plain-English documentation to set up, use, and maintain it.
- Holly has an AI helper for day-to-day admin/writing tasks.

---

## 2. Core principle — folders *are* the site

Holly's entire workflow is: **make folders, drop images in.** The build reads the
folder tree and auto-generates navigation, gallery pages, and thumbnails.

```
content/
  work/
    creatures/              -> nav: "Creatures"   (a gallery)
      the-hollow.jpg
      swamp-king.jpg
    environments/           -> nav: "Environments"
      ruins/                -> sub-gallery: "Ruins"
        ...
    characters/             -> nav: "Characters"
  about.md                  -> "About" page
```

### Conventions (all optional — folders work with zero setup)
- **Folder name → nav label**, prettified: `swamp-king` → "Swamp King".
- **Ordering:** optional `01-`, `02-` numeric prefixes on folders/files control
  order; the number is hidden in the displayed label.
- **Captions:** image filename → caption, prettified. (Optional.)
- **Nesting:** a nested folder becomes a sub-gallery within its parent.
- **Overrides:** drop a tiny optional `_index.md` in any folder *only if* she
  wants to override the title, add a description, or choose a cover image.
  Never required.

---

## 3. Pages & structure

- **Home** — landing showing featured work (newest pieces, or a hand-picked set).
- **Galleries** — auto-generated from the folders above: responsive grid +
  click-to-enlarge lightbox.
- **About** — simple markdown page (bio / Escape Studios / contact).

---

## 4. Framework — Hugo

Chosen because:
- **Folder structure → navigation is native to Hugo.** Top-level folders become
  sections (nav); nested folders become sub-galleries. This is exactly Holly's
  mental model, with no glue code.
- **Built-in image processing** — auto-generates web-sized + thumbnail versions
  of every image at build time, with lazy loading. Solves the big-art-file
  problem out of the box; Holly never resizes anything.
- Fast builds, single tool, standard GitHub Pages deploy.
- Cost: the theme uses Go templates — set up **once** by the builder. Holly never
  sees or touches them.

Rejected: Eleventy (more custom folder/image code to maintain), Astro (markdown/
schema model fights pure folder-driven content), plain HTML/Jekyll (no real image
processing; awkward folder-driven galleries).

---

## 5. Look & feel — "the skin stays Holly's"

**Rule: the AI never touches her art and never imposes an aesthetic.** No
AI-generated imagery, no AI-chosen visual identity. The look is hers.

Mechanism:
- **Structure** (templates, gallery logic) is stable and built by us.
- **Skin** (palette, typography, background, spacing, mood) lives in **one
  documented CSS-variables / theme-tokens file.** Changing the entire feel of the
  site = editing that one file, not the templates.
- The skeleton ships **deliberately neutral** — a blank gallery wall — so it does
  not pre-bias Holly's choices.
- A later **design pass led by Holly**: she brings direction (references, mood,
  sketches, "I want it to feel like X"); the AI/we *implement her direction* into
  the theme-tokens file. She drives; the agent is the hands.

---

## 6. Hosting, deploy & domain

- Repo lives on **Holly's own GitHub account** (she creates one if needed).
  Richard is added as collaborator to build it.
- **GitHub Action** builds Hugo and deploys to GitHub Pages on every push. Holly
  edits via GitHub's web UI → the site rebuilds itself in ~1 minute.
- Built **domain-agnostic**. When Holly confirms the name (`nightmareconcept.art`
  or otherwise), final step adds a `CNAME` file + points DNS at GitHub Pages
  (~10 minutes).

---

## 7. AI helper for Holly — tiered

The helper does **site admin + writing only** — never art, never design choices.

**Tasks it helps with:**
- Draft captions, descriptions, and her About bio *in her voice* (she edits).
- Write image **alt-text** (accessibility).
- Answer "how do I add a gallery / reorder pieces?" from her own guide.
- Brainstorm how to organise/name galleries.
- Translate her design direction into the theme-tokens file.

**Tiering:**
- **Day-to-day text & admin → local ollama** on Richard's sim rig (free, private,
  always-on; a small model such as Qwen2.5/Qwen3 7–14B or Llama 3.3 8B is ample).
  A friendly UI (e.g. Open WebUI) makes it approachable.
- **Builds, design implementation, and "the site broke" troubleshooting →
  Claude (with Richard), or Richard.** Small local models are noticeably weaker
  at multi-step git/build debugging. The site is designed so Holly rarely hits
  this tier.

**Shared asset:** a single **project-aware "site assistant" system prompt** that
knows the repo conventions and Holly's guide, usable by both ollama and Claude so
answers are consistent and repo-correct. Stored in the repo.

---

## 8. Documentation for Holly (a first-class deliverable)

Written in plain, non-technical English, stored in the repo:
- **Getting started / setup** — creating her GitHub account, where the site lives,
  how editing → publishing works.
- **How to add your art** — the folder/image workflow, ordering with number
  prefixes, captions, optional `_index.md` overrides.
- **How to maintain it** — reorganising galleries, editing the About page,
  what to do if something looks wrong (and when to call in the bigger AI / Richard).
- **Using your AI helper** — what to ask it, what not to (no art, no imposed
  design), how to run the local model.

---

## 9. Handoff sequence

1. Holly creates a GitHub account (if she doesn't have one).
2. Repo created on her account; Richard added as collaborator.
3. Build theme + structure + a couple of sample galleries so she sees how it works.
4. Write Holly's documentation set (section 8) into the repo.
5. Set up the AI helper (section 7).
6. Design pass led by Holly (section 5).
7. Wire up the custom domain once the name is locked in (section 6).

---

## 10. Explicitly out of scope (for now)

- Final visual design — deferred to Holly's design pass (section 5).
- Confirming/registering the domain name — Holly's decision.
- E-commerce, blog/CMS beyond the gallery, contact forms, analytics — not needed
  for v1; can be added later if Holly wants.
