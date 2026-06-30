# Architecture

Slopnought works everywhere via a **two-layer architecture** that keeps skills harness-agnostic while allowing per-agent injection.

## The two layers

```
┌────────────────────────────────────────────────────────────────────┐
│ Layer 1: Skills (harness-agnostic)                                 │
│ ┌──────────────────────────────────────────────────────────────┐   │
│ │ skills/slopnought/SKILL.md                                    │   │
│ │ skills/slopnought/references/anti-patterns.md                 │   │
│ │ skills/slopnought/references/code-generation-mode.md          │   │
│ │ skills/slopnought/references/refactoring-mode.md              │   │
│ │ skills/slopnought/references/architecture-records.md          │   │
│ │ skills/slopnought/assets/adr-template.md                      │   │
│ └──────────────────────────────────────────────────────────────┘   │
│                                                                     │
│ Skills describe ACTIONS not tools:                                  │
│ "read a file", "edit a file", "dispatch a subagent"                │
│ The agent already knows its own tools.                              │
├────────────────────────────────────────────────────────────────────┤
│ Layer 2: Bootstrap Injector (per-agent)                            │
│ ┌──────────────────────────────────────────────────────────────┐   │
│ │ Injected at session start, EVERY session, NO opt-in           │   │
│ │ Wraps SKILL.md in <EXTREMELY_IMPORTANT> tags                  │   │
│ │ Says "already loaded, don't reload"                           │   │
│ └──────────────────────────────────────────────────────────────┘   │
└────────────────────────────────────────────────────────────────────┘
```

**The bootstrap is the entire integration.** Without it, skill files are inert — present on disk, never invoked. It teaches the model that skills exist, that they must be checked before acting, and how to use the harness's native tool system to load them.

## Why two layers?

**Layer 1 (Skills)** stays harness-agnostic so the same skill content works everywhere. `SKILL.md` describes what to do ("read `references/code-generation-mode.md`"), not which tool to use. The agent already knows its own tools — no mapping needed.

**Layer 2 (Bootstrap Injector)** is the only agent-specific code. It reads the skill, wraps it, and hands it to the model at session start. Different agents need different injection mechanisms (hooks, plugins, context files), but the result is the same: the model knows Slopnought exists and how to use it.

## The three integration shapes

Every agent fits one of three structural shapes, distinguished by *how the bootstrap reaches the model*:

### Shape A — Shell-hook

```
 Harness                    Plugin hooks/           Bootstrap script
┌──────────┐  runs shell   ┌──────────────┐  reads  ┌──────────────────┐
│ Session   │──────────────→│ run-hook.cmd  │────────→│ session-start    │
│ start     │               │ session-start │         │ (reads SKILL.md) │
└──────────┘               └──────────────┘         └────────┬─────────┘
      ▲                                                      │
      │           prints JSON with bootstrap                 │
      └──────────────────────────────────────────────────────┘
```

**Agents:** Claude Code, Codex CLI, Codex App, Cursor, Copilot CLI, Factory Droid

**Pros:** No in-process code; works with any harness that can run a shell command.
**Cons:** Fragile JSON shape (wrong field → silent failure or double injection); hook config schema varies per agent; Windows support requires polyglot wrapper.

### Shape B — In-process Plugin

```
 Harness                Plugin module               Bootstrap
┌──────────┐  loads    ┌──────────────────────┐  builds    ┌──────────────┐
│ Session   │──────────│ slopnought.js/.ts    │──────────→│ <MSG array>  │
│ start     │          │                      │            │ user message │
└──────────┘          │ lifecycle callbacks:  │            │ with wrapped │
                      │ - config()            │            │ SKILL.md     │
                      │ - transform()         │            └──────────────┘
                      │ - resources_discover  │
                      │ - context()           │
                      └──────────────────────┘
```

**Agents:** OpenCode, Pi

**Pros:** Full control over injection logic; can cache, dedupe, re-inject after compaction; no fragile JSON formats.
**Cons:** Requires harness to support JS/TS plugin modules with lifecycle callbacks.

### Shape C — Instructions File

```
 Harness                Manifest               Context file
┌──────────┐  reads    ┌──────────────────┐  @-includes  ┌──────────────────┐
│ Session   │─────────→│ gemini-extension  │────────────→│ GEMINI.md         │
│ start     │          │ .json             │             │                   │
└──────────┘          │ contextFileName   │             │ @SKILL.md         │
                      │ → "GEMINI.md"     │             └──────────────────┘
                      └──────────────────┘
```

**Agents:** Gemini CLI, Antigravity

**Pros:** Simplest mechanism — no hooks, no code, just a file the harness always loads.
**Cons:** Only works if the harness has a `contextFileName`-style manifest field; no ability to dedupe or conditionally inject.

## Agent support matrix

| Agent | Shape | Manifest | Bootstrap |
|---|---|---|---|
| Claude Code | A (shell-hook) | `.claude-plugin/plugin.json` | `hooks/session-start` |
| Codex CLI | A (shell-hook) | `.codex-plugin/plugin.json` | `hooks/session-start-codex` |
| Codex App | A (shell-hook) | Shares `.codex-plugin/` | Same as Codex CLI |
| Cursor | A (shell-hook) | `.cursor-plugin/plugin.json` | `hooks/session-start` |
| Copilot CLI | A (shell-hook) | Reuses `.claude-plugin/` | `hooks/session-start` |
| Gemini CLI | C (instructions) | `gemini-extension.json` | `GEMINI.md` |
| OpenCode | B (in-process) | `package.json` | `.opencode/plugins/slopnought.js` |
| Pi | B (in-process) | `package.json` | `.pi/extensions/slopnought.ts` |
| Antigravity | C (instructions) | `antigravity-plugin/plugin.json` | `ANTIGRAVITY.md` |
| Kimi Code | Native skill load | `.kimi-plugin/plugin.json` | `sessionStart.skill` field |
| Factory Droid | A (shell-hook) | Reuses `.claude-plugin/` | Reuses Claude Code hook |

## Critical rule: never edit user config

Everything ships through the harness's own install mechanism. Slopnought never reaches into a user's personal or global config files (`~/.gemini/config/AGENTS.md`, `settings.json`, `trustedFolders.json`, etc.). If it can't be installed cleanly via the agent's native mechanism, it doesn't get installed at all.

**Legitimate mechanisms:**
- Plugin install via native marketplace
- Extension install via CLI command
- Package manager install
- Git URL plugin spec
- A `contextFileName` manifest field pointing at a file the extension ships

**Illegitimate:**
- Editing `~/.config/opencode/opencode.json` outside the install command
- Appending to `~/.gemini/config/AGENTS.md`
- Writing to `~/.cursor/rules/`
- Hand-copying skill files into the harness's directory
