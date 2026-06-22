# Tool Mapping — Codex CLI

When slopnought skill references tools, use these Codex CLI equivalents:

| Action | Codex CLI Tool |
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

## Notes

- Codex uses a simpler JSON output shape (`additionalContext` at top level)
- Hook config uses `startup|resume|clear` matchers
- Uses `${PLUGIN_ROOT}` env var in hook commands
