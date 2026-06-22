# Tool Mapping — Copilot CLI

When slopnought skill references tools, use these GitHub Copilot CLI equivalents:

| Action | Copilot CLI Tool |
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

## Notes

- Copilot CLI reuses Claude Code's session-start script
- Outputs flat `additionalContext` (no nesting)
- Detected via `COPILOT_CLI` env var being set while `CLAUDE_PLUGIN_ROOT` is unset
