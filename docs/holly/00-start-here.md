# Your Art Website — A Guide From Dad 🎨

Hi love,

I've built you a website for your concept art. The whole point is that **it's yours** — you run it, you own it, and you never have to touch any code. You make folders and drop your pictures in; the website does the rest.

I've written this so you can follow it start to finish. Where something is fiddly and technical, I've marked it **(leave this to me)** — that's my job, just give me a shout. Everything marked **(your bit)** is yours, and it's all clicking buttons.

And don't worry about breaking anything — your art is always safe, whatever happens. Worst case, you ping me. Let's go.

---

## Part 1 — Getting it set up (we do this once, together)

**Step 1 — (your bit) Pick the name.** This is entirely your call. I've been using `nightmareconcept.art` as a placeholder, but it's just my suggestion — pick whatever feels like *you*. Tell me when you've decided. We can change it later if you go off it.

**Step 2 — (your bit) Make a GitHub account.** Go to **github.com** and sign up — it's free. GitHub is just where your website lives. Choose a username you like (it can appear in your web address). Then send me that username.

**Step 3 — (your bit) Create the empty website "repo".** On GitHub, click the **+** (top right) → **New repository**. Name it `nightmareconcept` (or whatever you fancy), leave everything else as-is, and click **Create repository**. A "repo" is just the folder that holds your whole site. It'll look empty for now — that's fine, I'm about to fill it.

**Step 4 — (your bit) Let me in as a helper.** This is the bit you asked about — how you give me access. In your new repo:
- Click **Settings** (top menu) → **Collaborators** (left side) → **Add people**.
- Type my GitHub username and invite me.
- I'll get an email and accept. Now I can help you with the building bits whenever you need.

*(Quick heads-up: being a "collaborator" lets me add and fix the website's code, but only YOU — the owner — can change the big Settings, like switching the site on or connecting the web address. So a few of the next steps are yours to click, but I'll be right there talking you through them, or we'll do them together on a screen-share.)*

**Step 5 — (leave this to me) I put the website in.** Once I'm added, I'll upload the whole site into your repo. Takes me a few minutes. After this, your repo is full of the website's files.

**Step 6 — (your bit, I'll guide you) Switch the site on.** You don't need to "set up a Pages project" or anything like that — there's no separate thing to create. The site is already wired to publish itself; you just turn it on:
- Go to **Settings → Pages** (left side).
- Under **Build and deployment → Source**, choose **GitHub Actions**.
- That's it — save and you're done.

Within a minute or two it builds itself and goes live on a temporary web address (something like `your-username.github.io/nightmareconcept`). We'll check it together.

**Step 7 — (leave this to me, later) Your real web address.** Once you've locked in the name and we've bought it, I'll point your proper address (like `nightmareconcept.art`) at the site. About ten minutes of my time — say the word.

✅ Once Part 1 is done, your site is live and the rest is all you.

---

## Part 2 — Adding your art (this is the main thing you'll do)

**The big idea:** everything lives in a folder called **`content`**. Each folder you make in there becomes a **gallery**, and the folder's name becomes a button in your menu. Simple as that.

### Add a picture to a gallery you've already got
1. On your repo, open the **`content`** folder, then a gallery folder (e.g. `creatures`).
2. Click **Add file → Upload files**.
3. Drag your image in.
4. Click **Commit changes** (that just means "save").
5. Wait a minute, refresh your site — it's there. ✨

### Make a brand-new gallery
1. In `content`, click **Add file → Create new file**.
2. In the name box type the folder name, a slash, then a placeholder, e.g. `characters/placeholder.txt` (GitHub needs one file to make a folder). Commit.
3. Open the new `characters` folder and **upload your images** into it.
4. A new **Characters** button shows up in your menu, all by itself.

### Galleries inside galleries
Make a folder *inside* a gallery folder (e.g. `environments/ruins`) and "Ruins" becomes its own little gallery inside Environments. Handy for sub-themes.

### Put things in the order you want
Stick a number and a dash at the front of a folder or file name:
- Galleries: `01-creatures`, `02-environments`, `03-characters`
- Pictures: `01-the-hollow.jpg`, `02-swamp-king.jpg`

The number sets the order and stays **hidden** from visitors — they just see "Creatures", "The Hollow", and so on.

### Captions come free
The **file name** becomes the caption, tidied up: `swamp-king.jpg` shows as **"Swamp King"**. So name your files nicely and your captions sort themselves out.

---

## Part 3 — Your words

**(your bit) Write your About page.** In `content`, open **`about.md`**, click the pencil ✏️, and write a few lines — who you are, what you love drawing, how people can reach you. Commit, and it updates.

---

## Part 4 — Making it look like *you*

I've left the site deliberately plain on purpose — a blank gallery wall — so it doesn't push any style on you. **The look is 100% your decision.**

- All the colours, fonts and feel live in one single file: **`assets/css/tokens.css`**. Change a value there and the whole site restyles.
- Easiest way: **ask your AI helper** (Part 5) — e.g. *"change the background to deep charcoal and the accent to a cold blue"* — and it does the editing for you.
- When you want a proper look-and-feel, **let's sit down and do a design session**: you bring the mood, references and direction, and I'll make it real with you. Your art and your style stay entirely yours — I'm just the hands.

---

## Part 5 — Your AI helper

You've got an AI assistant for the **words and admin** of the site — never your art, and never deciding how it looks. You're the artist; it's the helper. *(Leave this to me to get it running on the computer at home the first time.)*

**Good things to ask it:**
- "Write a short bio for my About page — I'm a concept artist at Escape Studios."
- "Write alt-text for a piece called 'Frostfen'." *(alt-text helps blind visitors and helps people find your work.)*
- "How do I add a new gallery?"
- "Suggest tidy folder names for my environment pieces."
- "Change the background colour to deep charcoal."

**Don't ask it to** make or change your artwork, or decide your overall style. Give it *your* direction; it just types it up.

---

## If something looks wrong

Honestly, don't stress — **your art is never lost.** If the site doesn't update or looks off:
1. Look at the **Actions** tab on your repo. A red ✗ just means the last save had a hiccup (usually a small typo).
2. Ask your AI helper, or
3. **Message me.** Fixing the machinery is my job, not yours.

---

## Quick "who does what"

| Task | Who |
|---|---|
| Picking the name & the look | You |
| Adding & organising your art | You |
| Writing About / captions | You (helper can draft) |
| Switching the site on, connecting the web address | You (I'll guide you) |
| Putting the site in, fixing breakages, AI helper setup | Me — just ping me |

---

That's the lot. Start small — make one gallery, drop in one picture, watch it pop up on the site. Once you've done it once, everything else is just more of the same.

It's your space. Make it properly yours. 🖤

Love, Dad
