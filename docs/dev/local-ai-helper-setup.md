# Local AI Helper Setup — OpenCode + Ollama (on the Simrig)

How to give Holly a terminal AI assistant that edits the site by chatting to the
**local** model on the Simrig (free, private). This is a Richard-level setup doc.

## The shape of it
- **Holly's laptop** runs **OpenCode** (a terminal AI coding agent) with the repo
  cloned locally.
- OpenCode talks over the home LAN to **Ollama on the Simrig** (Windows, RTX 5070 Ti
  16 GB), which runs the model.
- OpenCode edits files in the repo → Holly reviews → commit + push → GitHub rebuilds
  the live site. git + the build gate mean she can't break the live site.

**Recommended model:** `qwen2.5-coder:14b` — already pulled on the Simrig, fits 16 GB
with a big context window, and is good at code edits + tool use. (Try
`qwen3.6:35b-a3b` or `gpt-oss:20b` for tougher asks; they'll be tighter on VRAM.)

---

## Part A — On the Simrig (Windows) — one-time

**1. Confirm Ollama + model**
```
ollama list
```
You should see `qwen2.5-coder:14b`.

**2. Fix the context window (the #1 gotcha).**
Ollama defaults EVERY model to a 4k context window. OpenCode's agentic tools
(file edit, run command) silently do nothing below ~16k. Make a big-context variant.
Create `qwen-coder-32k.Modelfile`:
```
FROM qwen2.5-coder:14b
PARAMETER num_ctx 32768
```
Then:
```
ollama create qwen2.5-coder:14b-32k -f qwen-coder-32k.Modelfile
```
(32k is a safe floor on 16 GB. To go higher toward OpenCode's recommended 64k, also
set the env var `OLLAMA_KV_CACHE_TYPE=q8_0` to shrink the KV cache, and watch VRAM.)

**3. Expose Ollama on the LAN.**
- Set a system env var so the service listens on all interfaces (admin cmd):
  ```
  setx OLLAMA_HOST "0.0.0.0:11434" /M
  ```
- Restart the service so it takes effect:
  ```
  sc stop Ollama
  sc start Ollama
  ```
- Allow it through Windows Firewall (admin PowerShell):
  ```
  New-NetFirewallRule -DisplayName "Ollama LAN" -Direction Inbound -Protocol TCP -LocalPort 11434 -Action Allow -Profile Private
  ```

**4. Get the Simrig's LAN address.**
```
ipconfig
```
Note the IPv4 address (e.g. `192.168.1.50`). Give it a DHCP reservation on your
router so it doesn't change. Call this `<SIMRIG-IP>` below.

**5. GPU sharing with simracing — important.**
The existing **SIMRIG PAUSE** Homey flow unloads Ollama models to free VRAM for sims.
That's fine: Holly's first request just reloads the model (~10–30 s cold start). But
if you're *actively racing*, the GPU is busy and her requests will be slow/contended.
Practical rule: she uses the helper when the rig isn't mid-race. (RESUME or a first
request warms it back up.)

---

## Part B — On Holly's laptop — one-time

**1. Install OpenCode**
```
curl -fsSL https://opencode.ai/install | bash
```
(See https://opencode.ai/docs for Windows/other install options.)

**2. Install git + GitHub CLI, and sign in as Holly** so she can push:
```
gh auth login
gh repo clone NightWalkerDaemon/NightmareConcept
cd NightmareConcept
```

**3. Point OpenCode at the Simrig's Ollama.**
Create `~/.config/opencode/opencode.json` (on Windows:
`%USERPROFILE%\.config\opencode\opencode.json`):
```json
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Simrig (Ollama)",
      "options": { "baseURL": "http://<SIMRIG-IP>:11434/v1" },
      "models": {
        "qwen2.5-coder:14b-32k": { "name": "Qwen2.5 Coder 14B (Simrig)" }
      }
    }
  }
}
```
Replace `<SIMRIG-IP>`. (Ollama serves an OpenAI-compatible API at `/v1`. The exact
opencode.json schema can evolve — check https://opencode.ai/docs if a key is renamed.)

**4. Sanity-check connectivity** from the laptop:
```
curl http://<SIMRIG-IP>:11434/api/tags
```
Should return JSON listing the models.

**5. The repo already includes `AGENTS.md`** at its root — OpenCode reads it
automatically, so the model already knows the site's conventions and the
"never touch Holly's art / never impose a style" rules.

---

## Part C — Holly's everyday flow
1. Make sure the Simrig is on and you're not mid-race.
2. In the repo folder: run `opencode`, pick the **Simrig** model.
3. Ask in plain English, e.g.:
   - "In tokens.css, make the background deep charcoal and the accent a cold blue."
   - "Write alt-text for the piece file `frostfen.jpg`."
   - "Draft a short About bio — I'm a concept artist at Escape Studios."
4. Review the diff it shows, accept it.
5. Commit and push (or ask OpenCode to). ~1 minute later it's live on
   https://nightmareconcept.art.
6. If the **Actions** tab shows a red ✗, the live site is safe (unchanged) — ask
   Claude/Dad to sort it.

## Why this is safe
- Everything is in git → any change is reversible.
- The GitHub build is a gate: a bad edit fails the build and the live site keeps the
  last good version. She can't break the public site.
- `AGENTS.md` constrains the model away from her art and the build machinery.
- Keep asks small and specific; local models are great at that and weaker at big
  multi-step changes (those are the Claude/Dad tier).
