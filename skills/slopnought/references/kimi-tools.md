# Tool Mapping — Kimi Code

When slopnought skill references tools, use these Kimi Code equivalents:

| Action | Kimi Code Tool |
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

## Notes

- Kimi uses `sessionStart.skill` field in manifest for auto-loading
- Tool mapping lives in `plugin.json` as `skillInstructions` field
- No hooks or code injection — native skill loading
- Per-harness tool mapping for `AskUserQuestion`, `TodoList`, `Agent`, `Skill`
