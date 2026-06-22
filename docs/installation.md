# Installation

Slopnought supports 11 coding agents. Each agent has its own native install mechanism — Slopnought never edits your personal or global config files.

## Claude Code

**Type:** Plugin (native marketplace)

```bash
/plugin install slopnought@claude-plugins-official
```

Or via the Slopnought marketplace:

```bash
/plugin marketplace add BhumitChaudhry/slopnought-marketplace
/plugin install slopnought@slopnought-marketplace
```

**How it works:** Claude Code loads `.claude-plugin/plugin.json`, which auto-discovers the `skills/` directory. The `hooks/hooks.json` registers a session-start shell command that reads `SKILL.md`, wraps it in `<EXTREMELY_IMPORTANT>` tags, and injects it into the model's context.

**Files used:**
- `.claude-plugin/plugin.json` — manifest
- `hooks/hooks.json` — hook config
- `hooks/session-start` — bootstrap script
- `hooks/run-hook.cmd` — Windows wrapper

---

## Codex CLI

**Type:** Plugin (marketplace)

```bash
/plugins
# Search "slopnought" → Install Plugin
```

**How it works:** Codex loads `.codex-plugin/plugin.json` and runs the session-start hook. The hook config uses `startup|resume|clear` matchers and outputs flat `additionalContext` JSON.

**Files used:**
- `.codex-plugin/plugin.json` — manifest
- `hooks/hooks-codex.json` — hook config
- `hooks/session-start-codex` — bootstrap script

---

## Codex App

**Type:** Plugin (GUI marketplace)

Click Plugins → Coding → Slopnought → `+`

The Codex App shares the `.codex-plugin/` directory with Codex CLI. Installation through the app triggers the same plugin → hooks → bootstrap pipeline.

---

## Cursor

**Type:** Plugin (marketplace)

```bash
/add-plugin slopnought
```

Or search in the plugin marketplace.

**How it works:** Cursor loads `.cursor-plugin/plugin.json`. The hook config uses `"version": 1`, lowercase `sessionStart`, and outputs `additional_context` (snake_case).

**Files used:**
- `.cursor-plugin/plugin.json` — manifest
- `hooks/hooks-cursor.json` — hook config
- `hooks/session-start` — bootstrap script (shared with Claude Code)

---

## GitHub Copilot CLI

**Type:** Plugin (marketplace)

```bash
copilot plugin marketplace add BhumitChaudhry/slopnought-marketplace
copilot plugin install slopnought@slopnought-marketplace
```

**How it works:** Copilot CLI reuses Claude Code's session-start script. Detection is done by checking that `COPILOT_CLI` is set while `CLAUDE_PLUGIN_ROOT` is unset. The output is flat `additionalContext` (no nesting).

**Files used:**
- Reuses `.claude-plugin/plugin.json`
- Reuses `hooks/session-start`
- `skills/slopnought/references/copilot-tools.md` — tool mapping

---

## Gemini CLI

**Type:** Extension (not a plugin)

```bash
gemini extensions install https://github.com/BhumitChaudhry/Slopnought
```

Update:

```bash
gemini extensions update slopnought
```

**How it works:** Gemini loads `GEMINI.md` at every session start via the `contextFileName` field in `gemini-extension.json`. That file contains two `@`-includes:

```
@./skills/slopnought/SKILL.md
@./skills/slopnought/references/gemini-tools.md
```

Gemini expands these directives and injects the full content into the model's context. No hooks, no code injection — just a file the harness always loads.

**Files used:**
- `gemini-extension.json` — manifest
- `GEMINI.md` — context file with `@`-includes

---

## OpenCode

**Type:** Plugin (git-backed package spec)

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

**Type:** Package (native package manager)

```bash
pi install git:github.com/BhumitChaudhry/Slopnought
```

**How it works:** The extension registers skills via `resources_discover` → `{skillPaths}` and injects the bootstrap via the `context` event per turn. Lifecycle flags manage injection: `session_start` → inject, `session_compact` → re-inject, `agent_end` → clear. Pi has no native Skill tool — the tool mapping tells the model to load skills by reading their `SKILL.md` with the `read` tool.

**Files used:**
- `.pi/extensions/slopnought.ts` — extension module
- `package.json` — Pi manifest (`pi.extensions`, `pi.skills`)

---

## Antigravity

**Type:** Plugin (via `agy` CLI)

```bash
agy plugin install https://github.com/BhumitChaudhry/Slopnought
```

Or use the bundled installer:

```bash
bash install-agy.sh
```

**How it works:** Antigravity uses a hybrid approach — the `agy plugin install` command installs the plugin, but the bootstrap rides a context file (`ANTIGRAVITY.md`). The manifest declares `contextFileName: "ANTIGRAVITY.md"`, so the harness loads it every session automatically. The `install-agy.sh` script can regenerate the context file from the current skill content.

**Files used:**
- `antigravity-plugin/plugin.json` — manifest
- `ANTIGRAVITY.md` — context file (bootstrap wrapped in `<EXTREMELY_IMPORTANT>`)
- `install-agy.sh` — installer script

---

## Kimi Code

**Type:** Plugin (marketplace + GitHub URL install)

```bash
/plugins install https://github.com/BhumitChaudhry/Slopnought
```

Or via marketplace: `/plugins` → Search "Slopnought" → Install.

**How it works:** Kimi Code's plugin manifest has a `sessionStart.skill` field that tells the harness which skill to auto-load at session start. No hooks, no code injection — Kimi loads the skill natively. The tool mapping lives in `plugin.json`'s `skillInstructions` field.

**Files used:**
- `.kimi-plugin/plugin.json` — manifest with `sessionStart.skill` and `skillInstructions`

---

## Factory Droid

**Type:** Plugin (via `droid` CLI)

```bash
droid plugin marketplace add https://github.com/BhumitChaudhry/Slopnought
droid plugin install slopnought@slopnought
```

**How it works:** Factory Droid doesn't need its own directory or manifest — it uses `droid plugin install` to consume the existing Claude Code plugin via its own CLI. The bootstrap injection reuses Claude Code's shell-hook mechanism.

**Files used:**
- Reuses `.claude-plugin/plugin.json`
- Reuses `hooks/hooks.json`
- `skills/slopnought/references/factory-droid-tools.md` — tool mapping

---

## Any other coding agent

If your coding agent isn't listed above, you can still install Slopnought using a natural language instruction:

```
install this skill: https://github.com/BhumitChaudhry/Slopnought
```

Most modern coding agents can interpret this instruction and:
1. Clone or download the repository
2. Discover the skill files in `skills/slopnought/`
3. Load `SKILL.md` into the model's context

If the agent has a plugin or extension system, it may use its native install mechanism. If not, the agent can read the skill files directly from the cloned repository.

### Manual installation

If the agent can't auto-install from a URL, you can manually set up Slopnought:

1. Clone the repository:
   ```bash
   git clone https://github.com/BhumitChaudhry/Slopnought.git
   ```

2. Point the agent's context or instructions to the skill:
   - Add `Slopnought/skills/slopnought/SKILL.md` to the agent's context files, AGENTS.md, or system prompt
   - Or copy the content of `SKILL.md` into the agent's instruction file

3. The agent can then load reference files (`references/anti-patterns.md`, `references/code-generation-mode.md`, etc.) as needed during the session.

### What the agent needs

At minimum, the agent needs access to:
- `skills/slopnought/SKILL.md` — the main skill file
- `skills/slopnought/references/` — reference docs loaded on demand

The agent's native read/edit tools will handle loading these files when the skill instructs the model to read them.

---

## Uninstalling

Remove Slopnought using the same mechanism you installed it with:

| Agent | Uninstall |
|---|---|
| Claude Code | `/plugin uninstall slopnought` |
| Codex CLI | `/plugins` → search → Uninstall |
| Cursor | Remove via plugin manager |
| Copilot CLI | `copilot plugin uninstall slopnought` |
| Gemini CLI | `gemini extensions uninstall slopnought` |
| OpenCode | Remove entry from `opencode.json` `plugin` array |
| Pi | `pi uninstall slopnought` |
| Antigravity | `agy plugin uninstall slopnought` |
| Kimi Code | `/plugins uninstall slopnought` |
| Factory Droid | `droid plugin uninstall slopnought` |
