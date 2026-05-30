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
