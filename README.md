# Slopnought

An AI coding skill that makes generated code maintainable. Not just "feature complete" — **future developer friendly.**

LLMs are great at solving today's problem. They're terrible at leaving code you can safely change tomorrow. Slopnought fixes that by injecting maintainability constraints directly into AI agent prompts at the start of a coding session.

---

## The Problem

We have all seen this before: an AI coding agent writes code that works, but when you try to modify it a few weeks later, nothing makes sense. Business logic is duplicated across files, architecture has drifted by accident, shortcuts have papered over race conditions, and nobody documented *why* anything was built the way it was.

Slopnought is a prompt-level skill that forces your coding agent to prioritize maintainability, readability, and structural integrity **while it writes code**, not as an afterthought.

---

## Architecture

Slopnought utilizes a clean, three-layer integration architecture designed to work across any agent harness:

```
┌────────────────────────────────────────────────────────┐
│               Harness-Agnostic Skills                  │
│  Main instructions (SKILL.md) & Ref Mode instructions   │
└───────────────────────────┬────────────────────────────┘
                            ▼
┌────────────────────────────────────────────────────────┐
│             Per-Agent Tool Mappings                    │
│ Translates generic skill actions to agent-specific tools│
└───────────────────────────┬────────────────────────────┘
                            ▼
┌────────────────────────────────────────────────────────┐
│               Bootstrap Injectors                      │
│ Hooks, plugins, & context files loaded at session start│
└────────────────────────────────────────────────────────┘
```

1. **Harness-Agnostic Skills**: Core rules and procedures for writing clean, structured code (`skills/slopnought/SKILL.md`).
2. **Per-Agent Tool Mappings**: Specific instructions teaching the agent how to execute maintainability behaviors using its native tools (located in `skills/slopnought/references/*-tools.md`).
3. **Bootstrap Injectors**: Environment-specific configuration files and hooks that inject the instructions into the agent's context (e.g., hooks, `.pi/`, `antigravity-plugin/`, or `gemini-extension.json`).

---

## Key Features & Modes

### 1. Code Generation Mode
Automatically active whenever an agent produces code. It enforces:
* **Strict Boundaries**: Clear separation between UI, business logic, data access, and infrastructure.
* **Size Limits**: Hard ceiling on file sizes (under 200–400 lines) and functions (under 20–40 lines).
* **Defensive Errors**: Error messages that explain exactly what happened and how to fix it.
* **Documented Intent**: Inline comments explaining *why* a choice was made, rather than *what* the code is doing.

### 2. Codebase Refactoring Mode (`/slopnought-audit`)
When invoked, the agent performs a comprehensive tech debt audit of the codebase, evaluating:
* Hidden coupling and architectural drift.
* Duplicate code patterns and copy-paste structures.
* Brittle shortcuts (magic numbers, swallowed exceptions, unconfigured environments).
* Test coverage gaps.
* Security risks.
It outputs a prioritized remediation plan and can apply fixes upon approval.

### 3. Anti-Patterns Catalog
A compiled reference of 7 common LLM-generated code failure modes:
1. Duplicated logic.
2. Context collapse (ignoring surrounding patterns).
3. Brittle shortcuts.
4. Leaky abstractions.
5. Ghost dependencies.
6. Silent/generic errors.
7. Commented-out dead code.

---

## Repository Structure

```
├── skills/slopnought/
│   ├── SKILL.md                          # Main skill instructions & rules
│   ├── references/
│   │   ├── anti-patterns.md              # Common LLM code failure modes
│   │   ├── code-generation-mode.md       # Detailed guide for writing new code
│   │   ├── refactoring-mode.md           # Instructions for auditing codebases
│   │   ├── architecture-records.md       # Guidelines for writing ADRs
│   │   └── *-tools.md                    # Environment-specific tool mappings
│   └── assets/
│       └── adr-template.md               # Markdown template for Architecture Decision Records
├── hooks/                                # Startup hooks for auto-injecting prompts
│   ├── session-start.py                  # Python bootstrap injector
│   ├── run-hook.cmd                      # Windows runner script
│   └── hooks.json                        # Hook registrations
└── package.json                          # Plugin metadata and dependencies
```

---

## Supported Environments

Slopnought contains tailored tool mappings for:
* **Google Antigravity** (using `antigravity-tools.md`)
* **Claude Code** (using `claude-code-tools.md`)
* **GitHub Copilot** (using `copilot-tools.md`)
* **Cursor** (using `cursor-tools.md`)
* **Gemini** (using `gemini-tools.md`)
* **Codex** (using `codex-tools.md`)
* **OpenCode** (using `opencode-tools.md`)
* **Pi** (using `pi-tools.md`)
* **Kimi** (using `kimi-tools.md`)
* **Factory Droid** (using `factory-droid-tools.md`)

---

## Installation & Setup

### 1. Claude Code
Install permanently as a global skill:
```bash
git clone https://github.com/BhumitChaudhry/Slopnought.git
cp -r Slopnought/skills/slopnought ~/.claude/skills/slopnought
```

### 2. Google Antigravity (`agy`)
Use the automated installation script to staging and install:
```bash
./install-agy.sh
```
This builds the staging structure and invokes `agy plugin install` to load Slopnought as a first-class plugin.

### 3. Hook-based Integration (Codex, Cursor, etc.)
Register the startup hook in your project or agent configuration pointing to `hooks/hooks.json`. During startup, the scripts in `hooks/` will dynamically combine `SKILL.md` with the corresponding `<agent>-tools.md` mapping and wrap them in `<EXTREMELY_IMPORTANT>` instructions.

### 4. Universal / On-the-fly
If your coding agent supports skill imports via prompt, instruct it to load the project:
```text
Load the Slopnought maintainability skill from https://github.com/BhumitChaudhry/Slopnought
```
*Note: Once imported, the agent will automatically detect its execution platform (e.g. Antigravity or Codex CLI), read the matching tool mapping from the `references/` directory, and apply correct tool translations automatically.*

---

## The Core Principles

Every code change must satisfy these five rules:
1. **Maintainability is a requirement, not a nice-to-have.** A fast, working solution that cannot be safely modified later is a liability.
2. **Optimize for the next reader, not for fewest keystrokes now.** Write code as if the next developer has zero context.
3. **Every non-obvious decision needs a visible reason.** Document the *why*, either through inline comments, docstrings, or Architecture Decision Records (ADRs).
4. **Consistency beats local optimality.** Adhere to existing patterns in the codebase rather than quietly introducing competing paradigms.
5. **The 2:00 AM Rule:** If you wouldn't want to debug it at 2:00 AM with no memory of writing it, don't ship it.

---

## License

MIT

