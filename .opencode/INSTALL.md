# Slopnought — OpenCode Installation

## Install

Add to your `opencode.json`:

```json
{
  "plugin": [
    "slopnought@git+https://github.com/BhumitChaudhry/Slopnought.git"
  ]
}
```

To pin a version:

```json
{
  "plugin": [
    "slopnought@git+https://github.com/BhumitChaudhry/Slopnought.git#v1.0.0"
  ]
}
```

## How it works

The plugin registers the `skills/slopnought/` directory via the `config` hook so OpenCode discovers the skill. On every agent step, the `experimental.chat.messages.transform` hook injects the bootstrap context as a user-role message (avoids system-message token bloat).

A dedup guard checks if `EXTREMELY_IMPORTANT` is already present in the first user message to prevent double injection. Bootstrap content is cached at module level.

## Uninstall

Remove the `slopnought` entry from the `plugin` array in your `opencode.json`.
