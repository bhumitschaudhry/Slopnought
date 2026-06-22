# Slopnought

A code maintainability skill that makes AI-generated code understandable, extensible, testable, secure, and maintainable. Works across 11 coding agents via a three-layer architecture.

## What it does

Slopnought turns maintainability into a first-class requirement. Instead of code that merely passes the task, you get code a stranger could pick up, understand in minutes, change safely, and trust the tests to catch their mistakes.

**Two modes:**

- **Code generation mode** — always active when writing new code. Enforces architectural boundaries, consistent patterns, meaningful naming, error handling, security baselines, documentation of intent, and tests.
- **Codebase refactoring mode** — invoked via `/slopnought-audit`. Scans an existing codebase for architectural weaknesses, code smells, duplication, missing tests, undocumented business logic, and security issues, then produces a prioritized remediation plan.

## Installation

### Claude Code

```bash
/plugin install slopnought@claude-plugins-official
```

Or via marketplace:

```bash
/plugin marketplace add BhumitChaudhry/slopnought-marketplace
/plugin install slopnought@slopnought-marketplace
```

### Codex CLI

```bash
/plugins
# Search "slopnought" → Install Plugin
```

### Codex App

Click Plugins → Coding → Slopnought → `+`

(The Codex App shares the `.codex-plugin/` directory with Codex CLI.)

### Cursor

```bash
/add-plugin slopnought
```

Or search in the plugin marketplace.

### GitHub Copilot CLI

```bash
copilot plugin marketplace add BhumitChaudhry/slopnought-marketplace
copilot plugin install slopnought@slopnought-marketplace
```

### Gemini CLI

```bash
gemini extensions install https://github.com/BhumitChaudhry/Slopnought
```

### OpenCode

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

### Pi

```bash
pi install git:github.com/BhumitChaudhry/Slopnought
```

### Antigravity

```bash
agy plugin install https://github.com/BhumitChaudhry/Slopnought
```

Or use the bundled installer script:

```bash
bash install-agy.sh
```

### Kimi Code

```bash
/plugins install https://github.com/BhumitChaudhry/Slopnought
```

Or via marketplace: `/plugins` → Search "Slopnought" → Install.

### Factory Droid

```bash
droid plugin marketplace add https://github.com/BhumitChaudhry/Slopnought
droid plugin install slopnought@slopnought
```

(Factory Droid consumes the Claude Code plugin format — no separate files needed.)

### Any other coding agent

```
install this skill: https://github.com/BhumitChaudhry/Slopnought
```

Most modern coding agents can interpret this instruction and install the skill automatically. If not, clone the repo and point the agent's context to `skills/slopnought/SKILL.md`. See [Installation docs](./docs/installation.md#any-other-coding-agent) for details.

## How it works

Slopnought uses a three-layer architecture that keeps skills harness-agnostic while allowing per-agent adaptation:

```
Layer 1: Skills (harness-agnostic)
  skills/slopnought/SKILL.md
  skills/slopnought/references/
  skills/slopnought/assets/

Layer 2: Tool Mapping (per-agent)
  references/<agent>-tools.md
  Translates "read a file" → Read / read / cat

Layer 3: Bootstrap Injector (per-agent)
  hooks/ (Shape A: shell-hook)         → Claude, Codex, Cursor, Copilot, Factory Droid
  .opencode/plugins/ (Shape B: in-proc) → OpenCode, Pi
  GEMINI.md (Shape C: context file)    → Gemini, Antigravity
```

At session start, the bootstrap injector reads the skill content, wraps it in `<EXTREMELY_IMPORTANT>` tags, appends the agent-specific tool mapping, and injects it into the model's context. This teaches the model that Slopnought exists and how to use it.

## Supported agents

| Agent | Install mechanism | Bootstrap shape | Files |
|---|---|---|---|
| **Claude Code** | `/plugin install` | Shell-hook (A) | `.claude-plugin/`, `hooks/hooks.json` |
| **Codex CLI** | `/plugins` → search | Shell-hook (A) | `.codex-plugin/`, `hooks/hooks-codex.json` |
| **Codex App** | GUI marketplace | Shell-hook (A) | Shares `.codex-plugin/` with Codex CLI |
| **Cursor** | `/add-plugin` | Shell-hook (A) | `.cursor-plugin/`, `hooks/hooks-cursor.json` |
| **Copilot CLI** | `copilot plugin install` | Shell-hook (A) | Reuses Claude Code's hook script |
| **Gemini CLI** | `gemini extensions install` | Context file (C) | `gemini-extension.json`, `GEMINI.md` |
| **OpenCode** | `opencode.json` plugin | In-process (B) | `.opencode/plugins/slopnought.js` |
| **Pi** | `pi install` | In-process (B) | `.pi/extensions/slopnought.ts` |
| **Antigravity** | `agy plugin install` | Context file (C) | `antigravity-plugin/`, `ANTIGRAVITY.md` |
| **Kimi Code** | `/plugins install` | Native skill load | `.kimi-plugin/plugin.json` |
| **Factory Droid** | `droid plugin install` | Shell-hook (A) | Reuses `.claude-plugin/` |
| **Any other agent** | `install this skill: [url]` | Manual / auto | `skills/slopnought/SKILL.md` |

## The core question

Before writing or changing a single line, and again before calling the work done:

> If a competent developer who has never seen this project opened this file with no other context, would they understand what it does, why it exists, how it connects to the rest of the system, how to verify it works, and what they'd risk by changing it?

## Key concepts

- **Anti-patterns** — a catalog of how LLM-generated code fails over time (duplicated logic, context collapse, brittle shortcuts, hidden dependencies, missing rationale, weak validation, architecture drift)
- **Architecture Decision Records** — durable records of decisions with lasting structural impact
- **Code generation mode** — discipline for writing new code that stays maintainable
- **Refactoring mode** — systematic audit and improvement of existing codebases

## File structure

```
skills/slopnought/
  SKILL.md                        # Main skill file
  references/
    anti-patterns.md              # LLM code failure modes
    code-generation-mode.md       # How to write maintainable new code
    refactoring-mode.md           # How to audit and improve existing code
    architecture-records.md       # When and how to write ADRs
    claude-code-tools.md          # Tool mapping for Claude Code
    codex-tools.md                # Tool mapping for Codex CLI
    cursor-tools.md               # Tool mapping for Cursor
    copilot-tools.md              # Tool mapping for Copilot CLI
    gemini-tools.md               # Tool mapping for Gemini CLI
    opencode-tools.md             # Tool mapping for OpenCode
    pi-tools.md                   # Tool mapping for Pi
    antigravity-tools.md          # Tool mapping for Antigravity
    kimi-tools.md                 # Tool mapping for Kimi Code
    factory-droid-tools.md        # Tool mapping for Factory Droid
  assets/
    adr-template.md               # ADR template
hooks/
  hooks.json                      # Claude Code hook config
  hooks-codex.json                # Codex hook config
  hooks-cursor.json               # Cursor hook config
  session-start                   # Main bootstrap script (bash)
  session-start-codex             # Codex variant
  session-start.py                # Python fallback (Claude/Copilot)
  session-start-codex.py          # Python fallback (Codex)
  run-hook.cmd                    # Windows polyglot wrapper
.claude-plugin/plugin.json        # Claude Code manifest
.codex-plugin/plugin.json         # Codex CLI/App manifest
.cursor-plugin/plugin.json        # Cursor manifest
.kimi-plugin/plugin.json          # Kimi Code manifest
.antigravity-plugin/plugin.json   # Antigravity manifest
install-agy.sh                    # Antigravity installer script
ANTIGRAVITY.md                    # Antigravity context file (generated bootstrap)
.opencode/
  plugins/slopnought.js           # OpenCode plugin module
  INSTALL.md                      # OpenCode install docs
.pi/extensions/slopnought.ts      # Pi extension module
gemini-extension.json             # Gemini CLI manifest
GEMINI.md                         # Gemini context file
ANTIGRAVITY.md                    # Antigravity context file
AGENTS.md                         # Agent instructions
CLAUDE.md                         # Contributor guidelines
package.json                      # Package manifest
```

## Critical rule: never edit user config

Everything ships through the harness's own install mechanism. Slopnought never reaches into a user's personal or global config files. If it can't be installed cleanly via the agent's native mechanism, it doesn't get installed at all.

## License

MIT
