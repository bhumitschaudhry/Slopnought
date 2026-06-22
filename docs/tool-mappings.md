# Tool Mappings

Slopnought skills describe **actions**, not tool names. Each agent has a translation table that maps actions to its native tools.

## Why tool mappings exist

A skill might say "read a file" or "dispatch a subagent." But:
- Claude Code calls the read tool `Read`
- OpenCode calls it `read`
- Pi calls it `read` (but has no subagent tool)
- Gemini calls subagent dispatch `subagent`

The tool mapping makes the skill work everywhere without modification.

## Per-agent mappings

### Claude Code

| Action | Tool |
|---|---|
| Read a file | `Read` |
| Edit a file | `Edit` |
| Run a shell command | `Bash` |
| Search files by content | `Grep` |
| Search files by name | `Glob` |
| Create/update todos | `TodoWrite` |
| Dispatch a subagent | `Task` |
| Fetch a URL | `WebFetch` |
| Ask user a question | Question (embedded) |
| Invoke a skill | `Skill` |

**File:** `skills/slopnought/references/claude-code-tools.md`

---

### Codex CLI

| Action | Tool |
|---|---|
| Read a file | `Read` |
| Edit a file | `Edit` |
| Run a shell command | `Bash` |
| Search files by content | `Grep` |
| Search files by name | `Glob` |
| Create/update todos | `TodoWrite` |
| Dispatch a subagent | `Task` |
| Fetch a URL | `WebFetch` |
| Ask user a question | `Question` (embedded) |
| Invoke a skill | Native skill system |

**File:** `skills/slopnought/references/codex-tools.md`

---

### Cursor

| Action | Tool |
|---|---|
| Read a file | Native read |
| Edit a file | Native edit |
| Run a shell command | Native shell |
| Search files | Native search |
| Create/update todos | Native todo |
| Dispatch a subagent | Native agent |
| Fetch a URL | Native fetch |
| Ask user a question | Native question |
| Invoke a skill | Native skill |

**File:** `skills/slopnought/references/cursor-tools.md`

---

### GitHub Copilot CLI

| Action | Tool |
|---|---|
| Read a file | `Read` |
| Edit a file | `Edit` |
| Run a shell command | `Bash` |
| Search files by content | `Grep` |
| Search files by name | `Glob` |
| Create/update todos | `TodoWrite` |
| Dispatch a subagent | `Task` |
| Fetch a URL | `WebFetch` |
| Ask user a question | Question (embedded) |
| Invoke a skill | `Skill` |

**File:** `skills/slopnought/references/copilot-tools.md`

---

### Gemini CLI

| Action | Tool |
|---|---|
| Read a file | `Read` |
| Edit a file | `Edit` |
| Run a shell command | `Bash` |
| Search files by content | `Grep` |
| Search files by name | `Glob` |
| Create/update todos | Checklist tool |
| Dispatch a subagent | Subagent |
| Fetch a URL | `FetchURL` |
| Ask user a question | `AskUser` |
| Invoke a skill | `activate_skill` |

**File:** `skills/slopnought/references/gemini-tools.md`

---

### OpenCode

| Action | Tool |
|---|---|
| Read a file | `read` |
| Edit a file | `apply_patch` |
| Run a shell command | `bash` |
| Search files by content | `grep` |
| Search files by name | `glob` |
| Create/update todos | `todowrite` |
| Dispatch a subagent | `task` |
| Fetch a URL | `webfetch` |
| Ask user a question | `question` |
| Invoke a skill | `skill` |

**File:** `skills/slopnought/references/opencode-tools.md`

---

### Pi

| Action | Tool |
|---|---|
| Read a file | `read` |
| Edit a file | `edit` |
| Run a shell command | `bash` |
| Search files by content | `grep` |
| Search files by name | `find` |
| Create/update todos | Plan file / TODO.md |
| Dispatch a subagent | (none — work in-session) |
| Fetch a URL | `fetch` |
| Ask user a question | Text |
| Invoke a skill | Read `SKILL.md` directly |

**File:** `skills/slopnought/references/pi-tools.md`

**Note:** Pi has no native Skill or subagent tool. The mapping tells the model to load skills by reading their `SKILL.md` with the `read` tool, and to do all work in-session.

---

### Antigravity

| Action | Tool |
|---|---|
| Read a file | `Read` |
| Edit a file | `Edit` |
| Run a shell command | `Bash` |
| Search files by content | `Grep` |
| Search files by name | `Glob` |
| Create/update todos | `TodoWrite` |
| Dispatch a subagent | `Task` |
| Fetch a URL | `WebFetch` |
| Ask user a question | Question (embedded) |
| Invoke a skill | Native skill system |

**File:** `skills/slopnought/references/antigravity-tools.md`

---

### Kimi Code

| Action | Tool |
|---|---|
| Read a file | `Read` |
| Edit a file | `Edit` |
| Run a shell command | `Bash` |
| Search files by content | `Grep` |
| Search files by name | `Glob` |
| Create/update todos | `TodoList` |
| Dispatch a subagent | `Agent` |
| Fetch a URL | `FetchURL` |
| Ask user a question | `AskUserQuestion` |
| Invoke a skill | `Skill` |

**File:** `skills/slopnought/references/kimi-tools.md`

---

### Factory Droid

Identical to Claude Code (Factory Droid consumes the Claude Code plugin format).

**File:** `skills/slopnought/references/factory-droid-tools.md`

---

## Critical rule

Tool mappings must be sourced from the agent itself, not guessed. The authoritative source is asking the running model: "List the exact machine names of every tool you can call, one per line."

## Where mappings live

- **Shell-hook agents (Shape A):** `skills/slopnought/references/<agent>-tools.md`, appended to bootstrap by the session-start script
- **In-process agents (Shape B):** Inlined in the plugin module (OpenCode's `toolMapping` constant) AND in `references/<agent>-tools.md`
- **Instructions-file agents (Shape C):** `@`-included from the context file (e.g., `GEMINI.md` has `@./skills/slopnought/references/gemini-tools.md`)
