# Tool Mapping — Antigravity

When slopnought skill references tools, use these Antigravity equivalents:

| Action | Antigravity Tool |
|---|---|
| Read a file | `view_file` |
| Edit a file | `replace_file_content` / `multi_replace_file_content` / `write_to_file` |
| Run a shell command | `run_command` |
| Search files by content | `grep_search` |
| Search files by name | `list_dir` |
| Create/update todos | `write_to_file` / `replace_file_content` |
| Dispatch a subagent | `invoke_subagent` |
| Fetch a URL | `read_url_content` / `read_browser_page` |
| Ask user a question | `ask_question` |
| Invoke a skill | Native skill system / `view_file` |

## Notes

- Antigravity uses a context file (`ANTIGRAVITY.md`) loaded automatically via `contextFileName` in the manifest
- The `install-agy.sh` command handles bootstrap generation
- Bootstrap rides a generated context file, not hooks or code injection
- The manifest's `contextFileName` field ensures the installer preserves the file AND the harness loads it automatically

