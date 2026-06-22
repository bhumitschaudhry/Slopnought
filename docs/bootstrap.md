# Bootstrap Injection

The bootstrap is the assembled text injected into every model's context at session start. This document explains how it works in each agent.

## What the bootstrap contains

Every bootstrap follows the same structure:

```
<EXTREMELY_IMPORTANT>
You have Slopnought installed.

**IMPORTANT: The slopnought skill content is included below.
It is ALREADY LOADED - you are currently following it.
Do NOT use the skill tool to load "slopnought" again - that would be redundant.**

[body of skills/slopnought/SKILL.md, frontmatter stripped]

[agent-specific tool mapping]
</EXTREMELY_IMPORTANT>
```

The `<EXTREMELY_IMPORTANT>` wrapper ensures the model treats the content as high-priority instructions. The "already loaded" preamble prevents the model from trying to re-load the skill via its native tool, which would be redundant.

## Shape A: Shell-hook agents

**Agents:** Claude Code, Codex CLI, Codex App, Cursor, Copilot CLI, Factory Droid

### Flow

```
Session start → Harness runs shell command → Script reads SKILL.md
→ Strips frontmatter → Wraps in <EXTREMELY_IMPORTANT> → Appends tool mapping
→ Prints JSON → Harness ingests into model context
```

### Hook configs

Each agent has its own hook config format:

**Claude Code** (`hooks/hooks.json`):
```json
{
  "SessionStart": [{
    "matcher": "startup|clear|compact",
    "hooks": [{
      "type": "command",
      "command": "${CLAUDE_PLUGIN_ROOT}/hooks/run-hook.cmd session-start"
    }]
  }]
}
```

**Codex CLI** (`hooks/hooks-codex.json`):
```json
{
  "SessionStart": [{
    "matcher": "startup|resume|clear",
    "hooks": [{
      "type": "command",
      "command": "${PLUGIN_ROOT}/hooks/run-hook.cmd session-start-codex"
    }]
  }]
}
```

**Cursor** (`hooks/hooks-cursor.json`):
```json
{
  "version": 1,
  "sessionStart": {
    "command": "./hooks/run-hook.cmd session-start"
  }
}
```

### JSON output shapes

Different agents expect different JSON shapes from the hook script:

| Agent | Output shape |
|---|---|
| Claude Code | `{"hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": "..."}}` |
| Codex CLI | `{"additionalContext": "..."}` |
| Cursor | `{"additional_context": "..."}` (snake_case) |
| Copilot CLI | `{"additionalContext": "..."}` (flat) |

### Agent detection

The `session-start` script detects which agent is calling it:

- **Copilot CLI:** `COPILOT_CLI` is set AND `CLAUDE_PLUGIN_ROOT` is unset
- **Claude Code:** `CLAUDE_PLUGIN_ROOT` is set
- **Factory Droid:** Uses Claude Code's detection

### Windows support

`hooks/run-hook.cmd` is a polyglot wrapper that:
1. Checks for `bash` (Git Bash / WSL)
2. Falls back to Python if bash is unavailable
3. Routes to the correct session-start variant

---

## Shape B: In-process plugin agents

**Agents:** OpenCode, Pi

### OpenCode flow

```
Session start → Harness loads slopnought.js
→ config() hook registers skills directory
→ On each agent step, transform() hook fires
→ Checks dedup guard (EXTREMELY_IMPORTANT in first user message)
→ If not present, injects bootstrap as user-role message
→ Caches bootstrap at module level
```

**Key details:**
- Injects as **user-role** message, not system (avoids token bloat)
- Dedup guard: checks if `EXTREMELY_IMPORTANT` is in the first user message
- Bootstrap cached at module level to avoid disk I/O per agent step

### Pi flow

```
Session start → session_start() sets injectBootstrap = true
→ resources_discover() registers skills directory
→ On each turn, context() fires
→ Checks dedup guard (custom marker string)
→ If inject flag set, inserts bootstrap after compaction summaries
→ agent_end() clears inject flag
→ session_compact() re-sets inject flag
```

**Key details:**
- `context` event fires **per turn**, not per agent step
- Lifecycle flags manage injection across session events
- Bootstrap inserts after any leading compaction-summary messages
- No native Skill tool — tool mapping says to read `SKILL.md` with `read`
- No native subagent tool — work is done in-session

---

## Shape C: Instructions file agents

**Agents:** Gemini CLI, Antigravity

### Gemini CLI flow

```
Session start → Harness reads gemini-extension.json
→ Finds contextFileName: "GEMINI.md"
→ Loads GEMINI.md
→ Expands @-includes:
    @./skills/slopnought/SKILL.md
    @./skills/slopnought/references/gemini-tools.md
→ Injects expanded content into model context
```

**Key details:**
- No hooks, no code injection — just a file the harness always loads
- `@`-include directives are expanded by Gemini
- SKILL.md already contains its own `<EXTREMELY_IMPORTANT>` wrapper
- No "already loaded" preamble needed (the content IS the active instruction set)

### Antigravity flow

```
User runs: agy plugin install <url>
→ Installer creates staging directory
→ Copies skills/ and manifest
→ Generates ANTIGRAVITY.md from SKILL.md + tool mapping
→ Wraps in <EXTREMELY_IMPORTANT>
→ Runs agy plugin install against staging dir
→ Harness reads manifest, finds contextFileName: "ANTIGRAVITY.md"
→ Loads ANTIGRAVITY.md every session
```

**Key details:**
- Hybrid: plugin install command, but bootstrap rides a generated context file
- `install-agy.sh` can regenerate `ANTIGRAVITY.md` from current skill content
- Manifest's `contextFileName` ensures the file is preserved and loaded

---

## The dedup problem

Some agents fire lifecycle callbacks multiple times. The bootstrap must not be injected twice.

| Agent | Dedup mechanism |
|---|---|
| OpenCode | Checks if first user message contains `EXTREMELY_IMPORTANT` |
| Pi | Custom marker string + lifecycle flags (`session_start` → inject, `agent_end` → clear) |
| Gemini CLI | N/A — `@`-include is the active instruction set, not a skill to re-load |
| Shell-hook agents | N/A — hook fires once per session start/clear/compact |
