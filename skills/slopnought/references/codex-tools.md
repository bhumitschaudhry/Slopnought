# Tool Mapping — Codex CLI

When slopnought skill references tools, use these Codex CLI equivalents:

| Action | Codex CLI Tool |
|---|---|
| Read a file | `read_file` |
| Edit a file | `write_file` / `replace_content` |
| Run a shell command | `execute_command` |
| Search files by content | `grep` |
| Search files by name | `find_files` / `list_dir` |
| Create/update todos | `write_file` |
| Dispatch a subagent | `subagent` |
| Fetch a URL | `fetch_url` / `web_search` |
| Ask user a question | `ask_user` |
| Invoke a skill | Native skill system / `read_file` |

## Notes

- Codex uses a simpler JSON output shape (`additionalContext` at top level)
- Hook config uses `startup|resume|clear` matchers
- Uses `${PLUGIN_ROOT}` env var in hook commands

