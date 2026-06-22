# Tool Mapping — Gemini CLI

When slopnought skill references tools, use these Gemini CLI equivalents:

| Action | Gemini CLI Tool |
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

## Notes

- Gemini uses `@`-include directives in `GEMINI.md` to load content
- No hooks or code injection — context file is loaded automatically
- The `contextFileName` field in manifest points to `GEMINI.md`
- Skill content wraps itself in `<EXTREMELY-IMPORTANT>` tags
