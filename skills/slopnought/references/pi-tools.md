# Tool Mapping — Pi

When slopnought skill references tools, use these Pi equivalents:

| Action | Pi Tool |
|---|---|
| Read a file | `read` |
| Edit a file | `edit` |
| Run a shell command | `bash` |
| Search files by content | `grep` |
| Search files by name | `find` |
| Create/update todos | Plan file / TODO.md |
| Dispatch a subagent | (none — work in-session) |
| Fetch a URL | `fetch` |
| Ask user a question | Text |
| Invoke a skill | Read `SKILL.md` directly |

## Notes

- Pi uses in-process plugin with `context` event per turn
- Skills registered via `resources_discover` → `{skillPaths}`
- Lifecycle flags manage injection: `session_start` → inject, `session_compact` → re-inject, `agent_end` → clear
- No native Skill tool — fallback is reading `SKILL.md` with `read`
- No native subagent tool — work is done in-session
- Bootstrap inserts after leading compaction-summary messages
