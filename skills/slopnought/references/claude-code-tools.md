# Tool Mapping — Claude Code

When slopnought skill references tools, use these Claude Code equivalents:

| Action | Claude Code Tool |
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

- Claude Code auto-discovers `skills/` next to `plugin.json`
- The `Skill` tool loads skill content by name
- `Task` dispatches independent subagent work
- Use `Read` + `Glob`/`Grep` for codebase exploration
