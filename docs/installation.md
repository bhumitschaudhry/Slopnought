# Installation

Slopnought supports 11 coding agents. Each agent has its own install mechanism — Slopnought never edits your personal or global config files.

## Prerequisites

- **Git** — required for all install methods
- **Bash** — required for shell-hook bootstrap scripts (Git Bash on Windows)
- **Python 3.6+** — required as a fallback for JSON encoding in bootstrap hooks

---

## Quick reference

| Agent | Install method |
|---|---|
| Claude Code | Clone + copy skills directory |
| Codex CLI | Clone + plugin config |
| Codex App | Clone + plugin config |
| Cursor | Clone + copy skills directory |
| Copilot CLI | Reuses Claude Code's setup |
| Gemini CLI | Clone + context file (auto-loaded) |
| OpenCode | Git URL plugin spec |
| Pi | Git URL package spec |
| Antigravity | Clone + `agy plugin install` |
| Kimi Code | Clone + plugin config |
| Factory Droid | Reuses Claude Code's setup |

---

## Claude Code

**Method: Clone and copy skills**

```bash
git clone https://github.com/BhumitChaudhry/Slopnought.git
cp -r Slopnought/skills/slopnought ~/.claude/skills/slopnought
cp -r Slopnought/skills/slopnought-audit ~/.claude/skills/slopnought-audit
```

This copies the skill files into Claude Code's skills directory. The skill loads automatically on the next session.

**Alternative: Hook-based bootstrap** (for full bootstrap injection)

Point your project's Claude Code config to `hooks/hooks.json`. The hook reads `SKILL.md`, wraps it in `<EXTREMELY_IMPORTANT>` tags, and injects it into the model context at session start.

**Files used:**
- `skills/slopnought/SKILL.md` — main skill file
- `skills/slopnought-audit/SKILL.md` — audit skill file
- `.claude-plugin/plugin.json` — manifest (for hook-based install)
- `hooks/hooks.json` — hook config
- `hooks/session-start` — bootstrap script
- `hooks/run-hook.cmd` — Windows wrapper

---

## Codex CLI

**Method: Clone and configure plugin**

```bash
git clone https://github.com/BhumitChaudhry/Slopnought.git
```

Then point your Codex CLI config to `Slopnought/.codex-plugin/plugin.json`. The plugin registers a session-start hook that injects the skill content at session start.

**Files used:**
- `.codex-plugin/plugin.json` — manifest
- `hooks/hooks-codex.json` — hook config
- `hooks/session-start-codex` — bootstrap script

---

## Codex App

Click **Plugins → Coding → Slopnought → `+`**

The Codex App shares the `.codex-plugin/` directory with Codex CLI. Installation through the app triggers the same plugin → hooks → bootstrap pipeline.

---

## Cursor

**Method: Clone and copy skills**

```bash
git clone https://github.com/BhumitChaudhry/Slopnought.git
cp -r Slopnought/skills/slopnought ~/.cursor/skills/slopnought
cp -r Slopnought/skills/slopnought-audit ~/.cursor/skills/slopnought-audit
```

**Alternative: Hook-based bootstrap**

Point your Cursor config to `hooks/hooks-cursor.json`. The hook runs the session-start script which injects the skill content.

**Files used:**
- `.cursor-plugin/plugin.json` — manifest
- `hooks/hooks-cursor.json` — hook config
- `hooks/session-start` — bootstrap script (shared with Claude Code)

---

## GitHub Copilot CLI

Copilot CLI reuses Claude Code's session-start script. Detection is done by checking that `COPILOT_CLI` is set while `CLAUDE_PLUGIN_ROOT` is unset. The output is flat `additionalContext` (no nesting).

**Setup:** Point Copilot CLI at the same skills directory as Claude Code:

```bash
git clone https://github.com/BhumitChaudhry/Slopnought.git
cp -r Slopnought/skills/slopnought ~/.claude/skills/slopnought
cp -r Slopnought/skills/slopnought-audit ~/.claude/skills/slopnought-audit
```

**Files used:**
- Reuses `.claude-plugin/plugin.json`
- Reuses `hooks/session-start`

---

## Gemini CLI

**Method: Clone and use context file**

```bash
git clone https://github.com/BhumitChaudhry/Slopnought.git
```

Gemini loads `GEMINI.md` at every session start via the `contextFileName` field in `gemini-extension.json`. That file contains an `@`-include:

```
@./skills/slopnought/SKILL.md
```

Gemini expands this directive and injects the full content into the model's context. No hooks, no code injection — just a file the harness always loads.

Point your Gemini CLI config to the cloned repository's `gemini-extension.json`.

**Files used:**
- `gemini-extension.json` — manifest
- `GEMINI.md` — context file with `@`-includes

---

## OpenCode

**Method: Git URL plugin spec**

Add to your `opencode.json`:

```json
{
  "plugin": [
    "slopnought@git+https://github.com/BhumitChaudhry/Slopnought.git"
  ]
}
```

To pin a version:

```json
{
  "plugin": [
    "slopnought@git+https://github.com/BhumitChaudhry/Slopnought.git#v1.0.0"
  ]
}
```

**How it works:** The plugin module exports `SlopnoughtPlugin` with lifecycle hooks. On `config`, it registers the `skills/` directory. On `experimental.chat.messages.transform`, it injects the bootstrap as a user-role message. A dedup guard checks if `EXTREMELY_IMPORTANT` is already in the first user message. Bootstrap content is cached at module level.

**Files used:**
- `.opencode/plugins/slopnought.js` — plugin module
- `.opencode/INSTALL.md` — install docs

---

## Pi

**Method: Git URL package spec**

```bash
pi install git:github.com/BhumitChaudhry/Slopnought
```

**How it works:** The extension registers skills via `resources_discover` → `{skillPaths}` and injects the bootstrap via the `context` event per turn. Lifecycle flags manage injection: `session_start` → inject, `session_compact` → re-inject, `agent_end` → clear.

**Files used:**
- `.pi/extensions/slopnought.ts` — extension module
- `package.json` — Pi manifest (`pi.extensions`, `pi.skills`)

---

## Antigravity

**Method: Clone and install via `agy`**

```bash
git clone https://github.com/BhumitChaudhry/Slopnought.git
cd Slopnought
bash install-agy.sh
```

The script builds a staging directory with the manifest, skills, and a generated `ANTIGRAVITY.md` context file, then runs `agy plugin install` against it.

**Prerequisites:** The `agy` CLI must be installed and in your PATH.

**How it works:** Antigravity uses a hybrid approach — the `agy plugin install` command installs the plugin, but the bootstrap rides a context file (`ANTIGRAVITY.md`). The manifest declares `contextFileName: "ANTIGRAVITY.md"`, so the harness loads it every session automatically. The `install-agy.sh` script can regenerate the context file from the current skill content.

**Files used:**
- `antigravity-plugin/plugin.json` — manifest
- `ANTIGRAVITY.md` — context file (bootstrap wrapped in `<EXTREMELY_IMPORTANT>`)
- `install-agy.sh` — installer script
- `install-agy.ps1` — PowerShell installer

---

## Kimi Code

**Method: Clone and configure plugin**

```bash
git clone https://github.com/BhumitChaudhry/Slopnought.git
```

Point your Kimi Code config to `Slopnought/.kimi-plugin/plugin.json`. The plugin manifest has a `sessionStart.skill` field that tells the harness which skill to auto-load at session start.

**Files used:**
- `.kimi-plugin/plugin.json` — manifest with `sessionStart.skill`

---

## Factory Droid

Factory Droid reuses Claude Code's plugin format. Point the `droid` CLI at the `.claude-plugin/` directory:

```bash
git clone https://github.com/BhumitChaudhry/Slopnought.git
droid plugin install Slopnought/.claude-plugin/plugin.json
```

**Files used:**
- Reuses `.claude-plugin/plugin.json`
- Reuses `hooks/hooks.json`

---

## Any other coding agent

If your coding agent isn't listed above:

1. Clone the repository:
   ```bash
   git clone https://github.com/BhumitChaudhry/Slopnought.git
   ```

2. Point the agent's context or instructions to the skill:
   - Add `Slopnought/skills/slopnought/SKILL.md` to the agent's context files, AGENTS.md, or system prompt
   - Or copy the content of `SKILL.md` into the agent's instruction file

3. The agent can then load reference files (`references/anti-patterns.md`, `references/code-generation-mode.md`, etc.) as needed during the session.

---

## Uninstalling

Remove Slopnought using the same mechanism you installed it with:

| Agent | Uninstall |
|---|---|
| Claude Code | Remove `~/.claude/skills/slopnought` and `~/.claude/skills/slopnought-audit` |
| Codex CLI | Remove the plugin config pointing to `.codex-plugin/` |
| Cursor | Remove `~/.cursor/skills/slopnought` and `~/.cursor/skills/slopnought-audit` |
| Copilot CLI | Same as Claude Code |
| Gemini CLI | Remove the config pointing to `gemini-extension.json` |
| OpenCode | Remove the `slopnought` entry from `opencode.json` `plugin` array |
| Pi | `pi uninstall slopnought` |
| Antigravity | `agy plugin uninstall slopnought` |
| Kimi Code | Remove the plugin config pointing to `.kimi-plugin/` |
| Factory Droid | `droid plugin uninstall slopnought` |
