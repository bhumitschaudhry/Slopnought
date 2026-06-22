# Tool Mapping — OpenCode

When slopnought skill references tools, use these OpenCode equivalents:

| Action | OpenCode Tool |
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

## Notes

- OpenCode uses in-process plugin with lifecycle hooks
- Bootstrap injected via `experimental.chat.messages.transform`
- Dedup guard checks for `EXTREMELY_IMPORTANT` in first user message
- Bootstrap cached at module level to avoid disk I/O per step
- Skills registered via `config` hook → `config.skills.paths`
