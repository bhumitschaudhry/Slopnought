# Tool Mapping — Cursor

When slopnought skill references tools, use these Cursor equivalents:

| Action | Cursor Tool |
|---|---|
| Read a file | Native read |
| Edit a file | Native edit |
| Run a shell command | Native shell |
| Search files by content | Native search |
| Search files by name | Native search |
| Create/update todos | Native todo |
| Dispatch a subagent | Native agent |
| Fetch a URL | Native fetch |
| Ask user a question | Native question |
| Invoke a skill | Native skill |

## Notes

- Cursor uses `additional_context` (snake_case) in hook output
- Hook config uses `"version": 1`, lowercase `sessionStart`
- No `matcher`/`type`/`async` fields in hook config
- Uses relative path `./hooks/run-hook.cmd` for hook command
