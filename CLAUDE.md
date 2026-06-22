# Slopnought — Contributor Guidelines

## Project structure

```
skills/slopnought/          # Core skill (harness-agnostic)
  SKILL.md                   # Main skill file
  references/                # Reference docs and tool mappings
  assets/                    # Templates (ADR template, etc.)
hooks/                       # Bootstrap injection scripts (Shape A)
.claude-plugin/              # Claude Code manifest
.codex-plugin/               # Codex CLI manifest
.cursor-plugin/              # Cursor manifest
.kimi-plugin/                # Kimi Code manifest
.opencode/                   # OpenCode plugin module
.pi/                         # Pi extension module
gemini-extension.json        # Gemini CLI manifest
GEMINI.md                    # Gemini context file
```

## Three-layer architecture

1. **Skills** (harness-agnostic) — `skills/slopnought/` describes actions, not tool names
2. **Tool mapping** (per-agent) — `references/<agent>-tools.md` translates actions to native tools
3. **Bootstrap injector** (per-agent) — hooks, plugins, or context files inject skill content at session start

## Key rule: never edit user config

Everything ships through the harness's own install mechanism. Never edit the user's personal or global config files.

## Contributing

- Skill content in `skills/slopnought/SKILL.md` should remain agent-agnostic
- Reference files describe patterns, not tool-specific implementations
- Tool mappings are agent-specific and live in `references/`
- Bootstrap scripts handle agent-specific JSON output formats
