# nightmareconcept.art Portfolio — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a folder-driven Hugo portfolio site for Holly Warren's concept art that auto-generates navigation and galleries from her folder structure, processes large images automatically, keeps all visual styling in one editable theme file, deploys to GitHub Pages, and ships with plain-English docs + an AI site-assistant prompt — ready to hand to Holly's own GitHub account.

**Architecture:** A Hugo (extended) static site where each content folder becomes a navigation section and a gallery. A small build-time "gallery generator" script ensures every folder Holly creates is a proper Hugo section (humanised title, ordering from numeric prefixes) without requiring her to add any files. Templates render responsive, lazy-loaded galleries using Hugo's built-in image processing. All look-and-feel lives in one documented CSS-variables file (`assets/css/tokens.css`). GitHub Actions runs the generator + Hugo and deploys to Pages.

**Tech Stack:** Hugo (extended, for WebP), Go templates, vanilla CSS + a tiny vanilla-JS lightbox, Bash (gallery generator), GitHub Actions (official Pages deploy), ImageMagick (placeholder sample images only).

**Note on verification style:** This is a static-site build, so "tests" are build/render verifications — run a command, confirm the expected output or rendered result. Each task ends by confirming the site still builds and the new behaviour appears.

---

## File Structure

**Created by this plan:**
- `hugo.toml` — site config (title, image quality, markdown settings)
- `assets/css/tokens.css` — **Holly's skin**: every colour/font/spacing variable, documented
- `assets/css/main.css` — structural layout (grid, header, lightbox) — ours, stable
- `assets/js/lightbox.js` — minimal click-to-enlarge lightbox
- `layouts/_default/baseof.html` — base HTML shell
- `layouts/partials/head.html` — `<head>`, CSS pipeline
- `layouts/partials/nav.html` — auto-navigation from top-level sections
- `layouts/partials/footer.html` — footer
- `layouts/partials/humanize-name.html` — strip `NN-` prefix + extension, title-case
- `layouts/index.html` — home page (one cover tile per gallery)
- `layouts/_default/list.html` — gallery page (image grid + sub-galleries)
- `layouts/_default/single.html` — simple page (About)
- `scripts/build-galleries.sh` — gallery generator (folders → sections)
- `scripts/dev.sh` — local preview wrapper (generate into a build copy, run `hugo server`)
- `scripts/make-placeholders.sh` — generate neutral placeholder images for the demo
- `content/_index.md` — home intro text
- `content/about.md` — About page
- `content/01-creatures/`, `content/02-environments/` (+ a sub-gallery) — sample galleries
- `.github/workflows/deploy.yml` — build + deploy to GitHub Pages
- `docs/holly/01-getting-started.md` … `04-using-your-ai-helper.md` — Holly's guides
- `assistant/site-assistant-prompt.md` — shared project-aware AI system prompt
- `docs/HANDOFF.md` — handoff checklist (repo ownership, domain, design pass)
- `README.md` — repo overview pointing Holly at her guides
- `.gitignore` — already exists; extend for build dirs

---

### Task 1: Hugo project skeleton

**Files:**
- Create: `hugo.toml`
- Modify: `.gitignore`

- [ ] **Step 1: Ensure Hugo (extended) is installed**

Run: `hugo version`
Expected: a version string containing `extended` (e.g. `hugo v0.140.0 ... extended`).
If missing or not extended: `brew install hugo` then re-run `hugo version` and confirm `extended` appears. Extended is required for WebP image output.

- [ ] **Step 2: Write the site config**

Create `hugo.toml`:

```toml
baseURL = "/"
languageCode = "en-gb"
title = "Nightmare Concept"

# Holly's bio/desc surfaces in the page <head> and home intro
[params]
description = "Concept art by Holly Warren"

# Default image processing quality for galleries
[imaging]
quality = 82
resampleFilter = "Lanczos"

# Allow raw HTML in Holly's markdown (About page, gallery descriptions)
[markup.goldmark.renderer]
unsafe = true
```

- [ ] **Step 3: Extend `.gitignore` for build artifacts**

Append to `.gitignore`:

```
# Hugo build output
/public/
/resources/_gen/
.hugo_build.lock

# Gallery-generator working copy (see scripts/dev.sh)
/.gallerybuild/
```

- [ ] **Step 4: Verify the site builds (empty is fine)**

Run: `hugo`
Expected: completes without error and reports a build (0 or more pages), creating `public/`.

- [ ] **Step 5: Commit**

```bash
git add hugo.toml .gitignore
git commit -m "feat: add Hugo site config and build ignores"
```

---

### Task 2: Base layout, theme tokens, and structural CSS

This task establishes the HTML shell and the **single theme file Holly owns**. The skeleton is intentionally neutral — a blank gallery wall.

**Files:**
- Create: `layouts/_default/baseof.html`
- Create: `layouts/partials/head.html`
- Create: `layouts/partials/footer.html`
- Create: `assets/css/tokens.css`
- Create: `assets/css/main.css`

- [ ] **Step 1: Base template**

Create `layouts/_default/baseof.html`:

```html
<!DOCTYPE html>
<html lang="{{ .Site.LanguageCode | default "en" }}">
<head>
  {{ partial "head.html" . }}
</head>
<body>
  {{ partial "nav.html" . }}
  <main class="site-main">
    {{ block "main" . }}{{ end }}
  </main>
  {{ partial "footer.html" . }}
  {{ $js := resources.Get "js/lightbox.js" | resources.Minify | resources.Fingerprint }}
  <script src="{{ $js.RelPermalink }}" defer></script>
</body>
</html>
```

- [ ] **Step 2: Head partial with CSS pipeline (tokens first, then structure)**

Create `layouts/partials/head.html`:

```html
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{{ if .IsHome }}{{ .Site.Title }}{{ else }}{{ .Title }} · {{ .Site.Title }}{{ end }}</title>
{{ with .Site.Params.description }}<meta name="description" content="{{ . }}">{{ end }}
{{ $tokens := resources.Get "css/tokens.css" }}
{{ $main := resources.Get "css/main.css" }}
{{ $css := slice $tokens $main | resources.Concat "css/site.css" | resources.Minify | resources.Fingerprint }}
<link rel="stylesheet" href="{{ $css.RelPermalink }}">
```

- [ ] **Step 3: Footer partial**

Create `layouts/partials/footer.html`:

```html
<footer class="site-footer">
  <p>© {{ now.Year }} {{ .Site.Title }}</p>
</footer>
```

- [ ] **Step 4: Theme tokens — Holly's skin (heavily commented)**

Create `assets/css/tokens.css`:

```css
/* =========================================================================
   THEME TOKENS — this file controls the entire LOOK & FEEL of the site.
   This is YOURS to change, Holly. You can edit every value here without
   touching any other file. Change a value, save, and the whole site updates.

   Tip: ask your AI helper "change the background to deep charcoal and the
   accent to blood red" and it will edit the values below.
   ========================================================================= */
:root {
  /* ---- Colours ---- */
  --color-bg:        #0e0e10;   /* page background */
  --color-surface:   #17171b;   /* cards / tiles background */
  --color-text:      #e8e8ea;   /* main text */
  --color-muted:     #9a9aa2;   /* secondary text, captions */
  --color-accent:    #c7402f;   /* links, highlights */
  --color-border:    #2a2a30;   /* hairlines, dividers */

  /* ---- Typography ---- */
  --font-body:    Georgia, "Times New Roman", serif;
  --font-heading: Georgia, "Times New Roman", serif;
  --font-size:    18px;
  --line-height:  1.6;
  --tracking-heading: 0.02em; /* letter-spacing for headings */

  /* ---- Layout ---- */
  --max-width:    1200px;  /* content width */
  --gap:          16px;    /* gallery grid gap */
  --tile-min:     260px;   /* min gallery tile width before wrapping */
  --radius:       2px;     /* corner rounding */
  --page-pad:     24px;    /* outer page padding */
}
```

- [ ] **Step 5: Structural CSS (layout only — reads the tokens)**

Create `assets/css/main.css`:

```css
*, *::before, *::after { box-sizing: border-box; }

body {
  margin: 0;
  background: var(--color-bg);
  color: var(--color-text);
  font-family: var(--font-body);
  font-size: var(--font-size);
  line-height: var(--line-height);
}

a { color: var(--color-accent); text-decoration: none; }
a:hover { text-decoration: underline; }

h1, h2, h3 { font-family: var(--font-heading); letter-spacing: var(--tracking-heading); font-weight: 600; }

.site-main { max-width: var(--max-width); margin: 0 auto; padding: var(--page-pad); }

/* Header / nav */
.site-header {
  display: flex; align-items: baseline; gap: 24px; flex-wrap: wrap;
  max-width: var(--max-width); margin: 0 auto;
  padding: var(--page-pad) var(--page-pad) 0;
}
.site-header .brand { font-family: var(--font-heading); font-size: 1.4rem; color: var(--color-text); }
.site-header nav ul { list-style: none; display: flex; gap: 18px; margin: 0; padding: 0; flex-wrap: wrap; }
.site-header nav a { color: var(--color-muted); }
.site-header nav a.active { color: var(--color-text); }

/* Gallery grid */
.grid {
  display: grid; gap: var(--gap);
  grid-template-columns: repeat(auto-fill, minmax(var(--tile-min), 1fr));
}
.tile, .subgallery {
  position: relative; display: block; background: var(--color-surface);
  border: 1px solid var(--color-border); border-radius: var(--radius); overflow: hidden;
}
.tile img, .subgallery img { display: block; width: 100%; height: auto; }
.tile-label, .subgallery span {
  display: block; padding: 8px 10px; color: var(--color-muted); font-size: 0.85rem;
}

.gallery-head h1 { margin-bottom: 0.25em; }
.gallery-desc { color: var(--color-muted); margin-bottom: 1.5em; }
.subgalleries { margin-top: 2rem; }

/* Simple page (About) */
.page { max-width: 70ch; }

/* Footer */
.site-footer { max-width: var(--max-width); margin: 3rem auto 1rem; padding: 0 var(--page-pad); color: var(--color-muted); border-top: 1px solid var(--color-border); }
.site-footer p { padding-top: 1rem; }

/* Lightbox */
.lb-overlay {
  position: fixed; inset: 0; background: rgba(0,0,0,0.92);
  display: none; align-items: center; justify-content: center; z-index: 1000; cursor: zoom-out;
}
.lb-overlay.open { display: flex; }
.lb-overlay img { max-width: 92vw; max-height: 86vh; }
.lb-caption { position: fixed; bottom: 16px; width: 100%; text-align: center; color: var(--color-muted); }
```

- [ ] **Step 6: Verify CSS pipeline builds**

Run: `hugo`
Expected: builds without template errors. (Nav partial referenced in baseof is created in Task 3; until then `hugo` may warn `partial "nav.html" not found` — create a temporary empty file to avoid blocking: `echo "" > layouts/partials/nav.html`. Task 3 replaces it.)

- [ ] **Step 7: Commit**

```bash
git add layouts assets
git commit -m "feat: base layout, theme tokens, and structural CSS"
```

---

### Task 3: Auto-navigation + name humaniser

**Files:**
- Create/replace: `layouts/partials/nav.html`
- Create: `layouts/partials/humanize-name.html`

- [ ] **Step 1: Name humaniser partial**

Create `layouts/partials/humanize-name.html` (input context `.` is a string — a filename or folder name):

```go-html-template
{{- $n := path.Base . -}}
{{- $n = replaceRE `\.[^.]+$` "" $n -}}
{{- $n = replaceRE `^[0-9]+[-_]?` "" $n -}}
{{- $n = replaceRE `[-_]+` " " $n -}}
{{- strings.Title (strings.TrimSpace $n) -}}
```

- [ ] **Step 2: Navigation partial (top-level sections, ordered by weight)**

Replace `layouts/partials/nav.html`:

```go-html-template
<header class="site-header">
  <a class="brand" href="{{ "/" | relURL }}">{{ .Site.Title }}</a>
  <nav>
    <ul>
      {{ range .Site.Home.Sections.ByWeight }}
        <li><a href="{{ .RelPermalink }}"{{ if or ($.IsDescendant .) (eq $ .) }} class="active"{{ end }}>{{ .Title }}</a></li>
      {{ end }}
      {{ with .Site.GetPage "/about" }}
        <li><a href="{{ .RelPermalink }}"{{ if eq $ . }} class="active"{{ end }}>{{ .Title }}</a></li>
      {{ end }}
    </ul>
  </nav>
</header>
```

- [ ] **Step 3: Verify (deferred to Task 6)**

The nav lists top-level sections; sections are produced by the generator (Task 4) + sample content (Task 5), and About is created in Task 6. Run `hugo` now to confirm no template syntax errors.
Run: `hugo`
Expected: builds with no `nav.html` errors (nav will be empty until content exists).

- [ ] **Step 4: Commit**

```bash
git add layouts/partials/nav.html layouts/partials/humanize-name.html
git commit -m "feat: auto-navigation from sections + name humaniser"
```

---

### Task 4: Gallery generator (folders → Hugo sections)

This is the unit that makes "just make folders, drop images, any depth" work with zero files from Holly. It runs at build time against a *copy* of `content/`, so Holly's repo is never modified. It skips any folder that already has an `_index.md`/`index.md`, preserving her optional overrides.

**Files:**
- Create: `scripts/build-galleries.sh`
- Create: `scripts/dev.sh`

- [ ] **Step 1: Write the generator**

Create `scripts/build-galleries.sh`:

```bash
#!/usr/bin/env bash
# Ensure every gallery folder under the given content dir is a Hugo section.
# For each subdirectory WITHOUT an index file, write a temporary _index.md
# with a humanised title and an ordering weight derived from a leading "NN-".
# Folders that already have _index.md / index.md (Holly's overrides) are left alone.
set -euo pipefail

ROOT="${1:-content}"

find "$ROOT" -mindepth 1 -type d | while read -r dir; do
  if [ -f "$dir/_index.md" ] || [ -f "$dir/index.md" ]; then
    continue
  fi

  base="$(basename "$dir")"

  weight=999
  if [[ "$base" =~ ^0*([0-9]+)[-_] ]]; then
    weight="${BASH_REMATCH[1]}"
  fi

  title="$(printf '%s' "$base" \
    | sed -E 's/^[0-9]+[-_]?//; s/[-_]+/ /g' \
    | awk '{for(i=1;i<=NF;i++){$i=toupper(substr($i,1,1)) tolower(substr($i,2))}}1')"

  cat > "$dir/_index.md" <<EOF
---
title: "$title"
weight: $weight
---
EOF
done
```

- [ ] **Step 2: Make it executable and unit-check it on a temp tree**

```bash
chmod +x scripts/build-galleries.sh
mkdir -p /tmp/gentest/content/03-dark-woods/clearing
touch /tmp/gentest/content/03-dark-woods/a.jpg
bash scripts/build-galleries.sh /tmp/gentest/content
cat /tmp/gentest/content/03-dark-woods/_index.md
cat /tmp/gentest/content/03-dark-woods/clearing/_index.md
rm -rf /tmp/gentest
```

Expected: `03-dark-woods/_index.md` has `title: "Dark Woods"` and `weight: 3`; `clearing/_index.md` has `title: "Clearing"` and `weight: 999`.

- [ ] **Step 3: Local preview wrapper (generate into a build copy, then serve)**

Create `scripts/dev.sh`:

```bash
#!/usr/bin/env bash
# Local preview: copy content to a throwaway dir, generate gallery sections
# there (so source stays pristine), and run the Hugo dev server against it.
set -euo pipefail

BUILD=".gallerybuild"
rm -rf "$BUILD"
mkdir -p "$BUILD"
cp -R content "$BUILD/content"
bash scripts/build-galleries.sh "$BUILD/content"
exec hugo server --contentDir "$BUILD/content" --disableFastRender "$@"
```

```bash
chmod +x scripts/dev.sh
```

- [ ] **Step 4: Commit**

```bash
git add scripts/build-galleries.sh scripts/dev.sh
git commit -m "feat: gallery generator + local preview wrapper"
```

---

### Task 5: Gallery rendering with image processing + lightbox

**Files:**
- Create: `layouts/_default/list.html`
- Create: `layouts/_default/single.html`
- Create: `assets/js/lightbox.js`

- [ ] **Step 1: Gallery list template (image grid + sub-galleries)**

Create `layouts/_default/list.html`:

```go-html-template
{{ define "main" }}
<section class="gallery">
  <header class="gallery-head">
    <h1>{{ .Title }}</h1>
    {{ with .Content }}<div class="gallery-desc">{{ . }}</div>{{ end }}
  </header>

  {{ $images := .Resources.ByType "image" }}
  {{ with $images }}
  <div class="grid">
    {{ range . }}
      {{ $thumb := .Resize "600x webp q82" }}
      {{ $full := .Resize "1800x webp q82" }}
      {{ $caption := partial "humanize-name.html" .Name }}
      <figure class="tile">
        <a href="{{ $full.RelPermalink }}" data-lightbox data-caption="{{ $caption }}">
          <img src="{{ $thumb.RelPermalink }}" width="{{ $thumb.Width }}" height="{{ $thumb.Height }}" loading="lazy" alt="{{ $caption }}">
        </a>
      </figure>
    {{ end }}
  </div>
  {{ end }}

  {{ with .Sections.ByWeight }}
  <div class="subgalleries">
    <div class="grid">
      {{ range . }}
        {{ $cover := index (.Resources.ByType "image") 0 }}
        <a class="subgallery" href="{{ .RelPermalink }}">
          {{ with $cover }}{{ $c := .Resize "600x webp q82" }}<img src="{{ $c.RelPermalink }}" loading="lazy" alt="{{ $.Title }}">{{ end }}
          <span>{{ .Title }}</span>
        </a>
      {{ end }}
    </div>
  </div>
  {{ end }}
</section>
{{ end }}
```

- [ ] **Step 2: Single-page template (About)**

Create `layouts/_default/single.html`:

```go-html-template
{{ define "main" }}
<article class="page">
  <h1>{{ .Title }}</h1>
  {{ .Content }}
</article>
{{ end }}
```

- [ ] **Step 3: Minimal lightbox**

Create `assets/js/lightbox.js`:

```js
(function () {
  var overlay = document.createElement("div");
  overlay.className = "lb-overlay";
  var img = document.createElement("img");
  var cap = document.createElement("div");
  cap.className = "lb-caption";
  overlay.appendChild(img);
  overlay.appendChild(cap);
  document.body.appendChild(overlay);

  function close() { overlay.classList.remove("open"); img.src = ""; }
  overlay.addEventListener("click", close);
  document.addEventListener("keydown", function (e) { if (e.key === "Escape") close(); });

  document.querySelectorAll("a[data-lightbox]").forEach(function (a) {
    a.addEventListener("click", function (e) {
      e.preventDefault();
      img.src = a.getAttribute("href");
      cap.textContent = a.getAttribute("data-caption") || "";
      overlay.classList.add("open");
    });
  });
})();
```

- [ ] **Step 4: Verify (with sample content in Task 7). Syntax check now.**

Run: `hugo`
Expected: no template errors (galleries render once content exists).

- [ ] **Step 5: Commit**

```bash
git add layouts/_default/list.html layouts/_default/single.html assets/js/lightbox.js
git commit -m "feat: gallery rendering with image processing and lightbox"
```

---

### Task 6: Home page and About page

**Files:**
- Create: `layouts/index.html`
- Create: `content/_index.md`
- Create: `content/about.md`

- [ ] **Step 1: Home template (one cover tile per top-level gallery)**

Create `layouts/index.html`:

```go-html-template
{{ define "main" }}
<section class="home">
  <header class="gallery-head">
    <h1>{{ .Site.Title }}</h1>
    {{ with .Content }}<div class="gallery-desc">{{ . }}</div>{{ end }}
  </header>
  <div class="grid">
    {{ range .Site.Home.Sections.ByWeight }}
      {{ $cover := index (.Resources.ByType "image") 0 }}
      <a class="tile" href="{{ .RelPermalink }}">
        {{ with $cover }}{{ $c := .Resize "800x webp q82" }}<img src="{{ $c.RelPermalink }}" loading="lazy" alt="{{ $.Title }}">{{ end }}
        <span class="tile-label">{{ .Title }}</span>
      </a>
    {{ end }}
  </div>
</section>
{{ end }}
```

- [ ] **Step 2: Home intro content**

Create `content/_index.md`:

```markdown
---
title: "Nightmare Concept"
---

Concept art and visual development by Holly Warren.
```

- [ ] **Step 3: About page**

Create `content/about.md`:

```markdown
---
title: "About"
---

I'm Holly Warren, a concept artist studying at Escape Studios.

_Replace this with your own words — your background, what you love drawing,
and how people can reach you._
```

- [ ] **Step 4: Commit**

```bash
git add layouts/index.html content/_index.md content/about.md
git commit -m "feat: home page and About page"
```

---

### Task 7: Sample galleries with placeholder images

Placeholder images are neutral grey cards labelled "PLACEHOLDER" — **never AI-generated art**. They exist only so the build is demonstrable and are meant to be deleted when Holly adds her work.

**Files:**
- Create: `scripts/make-placeholders.sh`
- Create: `content/01-creatures/*.jpg`, `content/02-environments/*.jpg`, `content/02-environments/ruins/*.jpg`

- [ ] **Step 1: Ensure ImageMagick is available**

Run: `magick -version || convert -version`
Expected: a version string. If missing: `brew install imagemagick`.

- [ ] **Step 2: Placeholder generator**

Create `scripts/make-placeholders.sh`:

```bash
#!/usr/bin/env bash
# Generate neutral grey placeholder JPEGs (NOT artwork) so the demo builds.
set -euo pipefail
MAGICK="magick"; command -v magick >/dev/null 2>&1 || MAGICK="convert"

make() { # path label
  "$MAGICK" -size 1600x1100 canvas:'#202028' \
    -gravity center -pointsize 64 -fill '#6a6a72' \
    -annotate 0 "$2" "$1"
}

mkdir -p content/01-creatures content/02-environments content/02-environments/ruins
make content/01-creatures/01-the-hollow.jpg "PLACEHOLDER\nThe Hollow"
make content/01-creatures/02-swamp-king.jpg "PLACEHOLDER\nSwamp King"
make content/02-environments/01-frostfen.jpg "PLACEHOLDER\nFrostfen"
make content/02-environments/ruins/01-broken-spire.jpg "PLACEHOLDER\nBroken Spire"
```

- [ ] **Step 3: Generate the placeholders**

```bash
chmod +x scripts/make-placeholders.sh
bash scripts/make-placeholders.sh
ls -R content/01-creatures content/02-environments
```

Expected: four `.jpg` files created across `01-creatures`, `02-environments`, and `02-environments/ruins`.

- [ ] **Step 4: Full local preview — the real verification**

Run: `bash scripts/dev.sh` then open the printed local URL (default `http://localhost:1313/`).
Expected, confirm visually:
- Nav shows **Creatures**, **Environments**, **About** (in that order).
- Home shows two cover tiles (Creatures, Environments).
- Creatures page shows two images in a grid; clicking one opens the lightbox with a caption ("The Hollow").
- Environments page shows one image **and** a "Ruins" sub-gallery tile; Ruins opens to its image.
- View source / network: gallery images are served as resized `.webp`, not the original `.jpg`.
Stop the server with Ctrl-C.

- [ ] **Step 5: Confirm a production build succeeds the same way CI will**

```bash
rm -rf .gallerybuild && mkdir -p .gallerybuild
cp -R content .gallerybuild/content
bash scripts/build-galleries.sh .gallerybuild/content
hugo --minify --contentDir .gallerybuild/content
```

Expected: `public/` is generated with the galleries and processed WebP images under `public/`.

- [ ] **Step 6: Commit**

```bash
git add scripts/make-placeholders.sh content/01-creatures content/02-environments
git commit -m "feat: sample galleries with placeholder images for the demo"
```

---

### Task 8: GitHub Actions deploy to GitHub Pages

**Files:**
- Create: `.github/workflows/deploy.yml`

- [ ] **Step 1: Workflow (runs the generator, then Hugo, then deploys)**

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy site
on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: pages
  cancel-in-progress: true

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install Hugo (extended)
        uses: peaceiris/actions-hugo@v3
        with:
          hugo-version: '0.140.0'
          extended: true
      - name: Generate gallery sections
        run: |
          mkdir -p .gallerybuild
          cp -R content .gallerybuild/content
          bash scripts/build-galleries.sh .gallerybuild/content
      - name: Build with Hugo
        run: hugo --minify --contentDir .gallerybuild/content
      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: public

  deploy:
    needs: build
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

- [ ] **Step 2: Validate the workflow YAML locally**

Run: `python3 -c "import yaml,sys; yaml.safe_load(open('.github/workflows/deploy.yml')); print('yaml ok')"`
Expected: `yaml ok`.

- [ ] **Step 3: Note for activation (no action needed until repo is on Holly's account)**

This deploys once the repo is pushed to GitHub **and** Pages is set to "GitHub Actions" as the source (Settings → Pages → Build and deployment → Source: GitHub Actions). Recorded in `docs/HANDOFF.md` (Task 11).
**baseURL note:** the site uses root-relative URLs. It is correct at a domain root (Holly's custom domain) and for `hugo server`. If previewing on a temporary `user.github.io/<repo>/` project URL before the custom domain is set, run the build with `hugo --minify --baseURL "https://<user>.github.io/<repo>/" --contentDir .gallerybuild/content`. This is captured in HANDOFF.md.

- [ ] **Step 4: Commit**

```bash
git add .github/workflows/deploy.yml
git commit -m "ci: build and deploy to GitHub Pages via Actions"
```

---

### Task 9: Holly's documentation set

Plain, friendly, non-technical English. Four short guides + a README.

**Files:**
- Create: `docs/holly/01-getting-started.md`
- Create: `docs/holly/02-adding-your-art.md`
- Create: `docs/holly/03-maintaining-the-site.md`
- Create: `docs/holly/04-using-your-ai-helper.md`
- Create: `README.md`

- [ ] **Step 1: Getting started**

Create `docs/holly/01-getting-started.md`:

```markdown
# Getting Started — Your Website

Hi Holly! This is your portfolio website. You own it, and you don't need to
write any code to run it. Here's the big picture.

## How it works in one sentence
You make **folders** and drop **images** into them — and the website builds
itself, turning your folders into galleries and your gallery names into the menu.

## Where your site lives
- The site's files live in a **repository ("repo") on your GitHub account**.
- Every time you change something on GitHub, the site rebuilds and updates on
  the web automatically (about a minute later).

## What you'll do day to day
- Add a new piece of art → see **Adding Your Art**.
- Tidy up or rename galleries → see **Maintaining the Site**.
- Need words written (captions, your bio) → see **Using Your AI Helper**.

## What you should NOT need to touch
The `layouts/`, `scripts/`, and `.github/` folders are the machinery. Leave them
be. The one design file you *may* want to play with later is
`assets/css/tokens.css` — that controls colours and fonts (see Maintaining).

If something looks broken, don't worry — message Dad or your AI helper.
```

- [ ] **Step 2: Adding your art**

Create `docs/holly/02-adding-your-art.md`:

```markdown
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

\`\`\`
---
title: "My Custom Title"
---

A sentence or two describing this gallery.
\`\`\`

You never *have* to do this — folders work fine on their own.
```

- [ ] **Step 3: Maintaining the site**

Create `docs/holly/03-maintaining-the-site.md`:

```markdown
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
```

- [ ] **Step 4: Using your AI helper**

Create `docs/holly/04-using-your-ai-helper.md`:

```markdown
# Using Your AI Helper

You have an AI assistant to help with the *words and admin* of the site — never
your art, and never deciding how it looks. You're the artist; it's the helper.

## Great things to ask it
- "Write alt-text for a piece called 'Frostfen'." (alt-text helps blind visitors
  and search engines.)
- "Draft a short bio for my About page — I'm a concept artist at Escape Studios."
- "How do I add a new gallery?" (it knows this site.)
- "Suggest tidy folder names for my environment pieces."
- "In tokens.css, change the background to deep charcoal and the accent to a
  cold blue." (it edits the one design file.)

## Please DON'T ask it to
- Generate or alter your artwork. The art is 100% yours.
- Decide the overall look for you. Give it *your* direction; it just types it up.

## Two helpers, two jobs
- **Local helper (on the sim rig):** your everyday helper for the above — free
  and private.
- **Claude (with Dad):** for building changes or fixing the site if a build
  breaks. You'll rarely need this.

See `assistant/site-assistant-prompt.md` — that's the briefing both helpers use
so they understand your site.
```

- [ ] **Step 5: README**

Create `README.md`:

```markdown
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
```

- [ ] **Step 6: Commit**

```bash
git add docs/holly README.md
git commit -m "docs: add Holly's guides and project README"
```

---

### Task 10: AI site-assistant system prompt

**Files:**
- Create: `assistant/site-assistant-prompt.md`

- [ ] **Step 1: Write the shared, project-aware system prompt**

Create `assistant/site-assistant-prompt.md`:

```markdown
# Site Assistant — System Prompt

You are Holly Warren's website assistant. Holly is a concept artist. You help
her run her portfolio website. Use this briefing as your system prompt (works
for a local Ollama model or for Claude).

## Your role
Help with the WORDS and ADMIN of the site. You never generate or modify artwork,
and you never decide the site's visual identity — that is Holly's. When she gives
you visual direction, you implement it faithfully; you do not impose taste.

## What you help with
- Writing/editing image alt-text, captions, gallery descriptions, and her About bio,
  in Holly's voice. Keep it concise and natural; offer drafts she can edit.
- Answering "how do I…" questions about running the site (rules below).
- Suggesting tidy, consistent folder/file names.
- Editing `assets/css/tokens.css` when she describes a colour/font/spacing change.

## What you must NOT do
- Do not create, generate, describe-as-final, or alter her artwork.
- Do not choose the overall aesthetic for her. Ask for her direction.
- Do not touch `layouts/`, `scripts/`, or `.github/` unless explicitly asked by a
  developer; for build/code problems, advise her to use Claude (with Richard).

## How the site works (so your answers are correct)
- The site is built with Hugo. Content lives under `content/`.
- Each folder under `content/` is a gallery; its name becomes a menu item.
- A leading number like `01-` sets order and is hidden from visitors.
  `01-creatures` shows as "Creatures".
- Image file names become captions, tidied: `swamp-king.jpg` → "Swamp King".
- A folder inside a gallery folder is a sub-gallery.
- An optional `_index.md` in a folder can set a custom `title:` and a description.
- Holly edits everything through GitHub's website; the site rebuilds in ~1 minute.
- All colours/fonts/spacing live in `assets/css/tokens.css` (CSS variables).

## Style
Friendly, plain English, no jargon. Short answers. When she asks for text, give
her a ready-to-paste draft and invite her to make it her own.
```

- [ ] **Step 2: Verify it reflects the build (consistency check)**

Confirm the conventions in this prompt match `docs/holly/02-adding-your-art.md` and the generator behaviour (number prefixes, filename captions, `_index.md` overrides, sub-galleries). They do — no changes needed.

- [ ] **Step 3: Commit**

```bash
git add assistant/site-assistant-prompt.md
git commit -m "docs: add project-aware AI site-assistant prompt"
```

---

### Task 11: Handoff checklist

**Files:**
- Create: `docs/HANDOFF.md`

- [ ] **Step 1: Write the handoff doc**

Create `docs/HANDOFF.md`:

```markdown
# Handoff Checklist

Steps to move this from Richard's build to Holly's owned, live site.

## 1. Holly's GitHub account
- [ ] Holly creates a GitHub account (if she doesn't have one) at github.com.

## 2. Repository on Holly's account
- [ ] Create a new repo on Holly's account (e.g. `nightmareconcept`).
- [ ] Push this project to it (`git remote add origin …` / `git push -u origin main`).
- [ ] Add Richard as a collaborator (Settings → Collaborators) to keep helping.

## 3. Turn on GitHub Pages via Actions
- [ ] Repo Settings → Pages → Build and deployment → Source: **GitHub Actions**.
- [ ] Push to `main` (or run the workflow) and confirm a green build in **Actions**.
- [ ] Temporary URL will be `https://<holly-username>.github.io/<repo>/`.
      If previewing there before the custom domain, build with
      `--baseURL "https://<holly-username>.github.io/<repo>/"`.

## 4. Custom domain (once Holly confirms the name, e.g. nightmareconcept.art)
- [ ] Buy the domain (if not already) from a registrar.
- [ ] In repo Settings → Pages → Custom domain, enter the domain. This creates a
      `CNAME` file in the repo.
- [ ] At the registrar's DNS, add GitHub Pages records:
      - Apex (`nightmareconcept.art`): A records to
        `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`
        (and AAAA records if you want IPv6).
      - `www`: CNAME to `<holly-username>.github.io`.
- [ ] Tick **Enforce HTTPS** once the certificate is issued.
- [ ] Set `baseURL` in `hugo.toml` to `https://nightmareconcept.art/`.

## 5. Holly makes it hers
- [ ] Replace placeholder images with her real work; delete the placeholders and
      `scripts/make-placeholders.sh` if she likes.
- [ ] Write her real About page (`content/about.md`).
- [ ] **Design pass:** Holly directs the look; the AI/Richard implement her vision
      in `assets/css/tokens.css`. This is where the site becomes authentically hers.

## 6. AI helper
- [ ] Set up the local model on the sim rig (Ollama + a friendly UI such as Open
      WebUI), loaded with `assistant/site-assistant-prompt.md` as its system prompt.
```

- [ ] **Step 2: Commit**

```bash
git add docs/HANDOFF.md
git commit -m "docs: add handoff checklist for ownership, domain, design pass"
```

---

## Self-Review

**Spec coverage:**
- Folder-driven site, folders define nav → Tasks 3, 4, 5, 6. ✓
- Drop images, any nesting, zero config → Task 4 generator + Task 5 rendering. ✓
- Image processing for big files → Task 5 (`.Resize "… webp q82"`), Task 1 imaging config. ✓
- Look-and-feel in one theme file, neutral skeleton → Task 2 `tokens.css`. ✓
- AI never imposes art/aesthetic; she directs → Tasks 9, 10, 11 docs + prompt. ✓
- Hugo framework → all tasks. ✓
- GitHub Pages deploy, Holly owns repo → Tasks 8, 11. ✓
- Tiered AI helper + shared prompt → Tasks 9 (guide 04), 10. ✓
- First-class documentation (setup/use/maintain) → Task 9. ✓
- Domain-agnostic now, wire domain later → Tasks 1, 8, 11. ✓
- Out-of-scope (final design, domain registration, blog/shop) → respected (Task 11 defers design pass). ✓

**Placeholder scan:** No "TBD/TODO/implement later". The only "placeholder" references are the intentional demo placeholder *images* (clearly labelled, meant to be replaced). ✓

**Type/name consistency:** `scripts/build-galleries.sh` (arg = content dir) used identically in `scripts/dev.sh`, Task 7 Step 5, and `.github/workflows/deploy.yml`. Build copy dir `.gallerybuild/` consistent in `.gitignore`, `dev.sh`, workflow, and Task 7. `humanize-name.html` partial defined in Task 3, used in Task 5. `tokens.css` + `main.css` concatenated in `head.html` (Task 2), variables consumed in `main.css`. Generator front-matter (`title`, `weight`) consumed by `nav.html`/`list.html`/`index.html` via `.Title` and `.ByWeight`. ✓
```
