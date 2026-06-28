# Tool Mapping — Factory Droid

When slopnought skill references tools, use these Factory Droid equivalents:

| Action | Factory Droid Tool |
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

- Factory Droid consumes the Claude Code plugin format (`.claude-plugin/`)
- No separate plugin directory needed — uses `droid plugin install` against the existing `.claude-plugin/` manifest
- Bootstrap injection reuses Claude Code's shell-hook mechanism
- Tool mapping is identical to Claude Code's
