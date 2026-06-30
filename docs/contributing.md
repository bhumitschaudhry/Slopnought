# Contributing

How to add Slopnought to a new coding agent, or modify the existing integration.

## Adding to a new agent

To add Slopnought to a coding agent not currently supported, you need three things:

### 1. Manifest

Create a manifest file the agent recognizes. The manifest declares:
- Plugin/extension name, version, author
- Path to skills directory (if the agent discovers skills from a manifest field)
- Path to hooks (if using shell-hook injection)
- Context file name (if using instructions-file injection)
- Session start behavior (if the agent has native skill loading)

Common manifest formats:

| Agent type | Manifest file | Key fields |
|---|---|---|
| Shell-hook | `.agentname-plugin/plugin.json` | `skills`, `hooks` |
| In-process | `package.json` | `main`, `pi.extensions`, `pi.skills` |
| Instructions-file | `agentname-extension.json` | `contextFileName` |
| Native skill | `.agentname-plugin/plugin.json` | `sessionStart.skill` |

### 2. Bootstrap injection

Choose one of three shapes based on what the agent supports:

**Shape A — Shell-hook** (if the agent can run a shell command at session start):

1. Create `hooks/hooks-<agent>.json` with the agent's hook config format
2. Create or reuse `hooks/session-start` — the script reads SKILL.md, strips frontmatter, wraps in `<EXTREMELY_IMPORTANT>`, and prints JSON
3. Handle the agent's expected JSON output shape

**Shape B — In-process plugin** (if the agent supports JS/TS plugin modules with lifecycle callbacks):

1. Create `.agentname/plugins/slopnought.js` (or `.ts`)
2. Implement lifecycle hooks: `config()` for skill registration, `transform()`/`context()` for bootstrap injection
3. Add dedup guard (check if bootstrap is already present)
4. Cache bootstrap at module level

**Shape C — Instructions file** (if the agent has a `contextFileName` manifest field):

1. Create `AGENTNAME.md` with `@`-include pointing to SKILL.md
2. The harness loads this file automatically every session
3. No hooks or code needed

### 3. Verify

After creating the files:
1. Install the plugin in the target agent
2. Start a new session
3. Verify the model acknowledges Slopnought is active
4. Test that the model can load reference files using the agent's native tools
5. Test `/slopnought-audit` if the agent supports slash commands

## Modifying existing integrations

### Updating bootstrap injection

If the agent changes its hook config format or JSON output shape:
1. Update the hook config file (`hooks/hooks-<agent>.json`)
2. Update the session-start script's JSON output for that agent
3. Test with a fresh session

### Adding a new reference file

If you add a new reference file to `skills/slopnought/references/`:
1. The file is automatically available to all agents (it's in the shared skills directory)
2. For Shape C agents, add an `@`-include in the context file
3. For Shape A and B agents, the model loads references via the agent's native read tool

## Code style

- Skill content should remain agent-agnostic (no tool names, no agent references)
- Reference files describe patterns, not tool-specific implementations
- Bootstrap scripts handle agent-specific JSON output formats
- Never hardcode paths — use env vars or relative paths

## Testing checklist

Before submitting changes:

- [ ] Skill content loads in the target agent
- [ ] Bootstrap is injected at session start
- [ ] Dedup guard prevents double injection (if applicable)
- [ ] Windows support works (if Shape A)
- [ ] No user config files are modified
- [ ] Uninstall is clean (no leftover files or config changes)
