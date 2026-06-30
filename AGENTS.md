# Slopnought — Agent Instructions

## What this is

Slopnought is a code maintainability skill that makes AI-generated code understandable, extensible, testable, secure, and maintainable. It works across multiple coding agents via a two-layer architecture: harness-agnostic skills and bootstrap injectors.

## How skills work

1. At session start, the bootstrap injector reads `skills/slopnought/SKILL.md` and injects it into the model's context wrapped in `<EXTREMELY_IMPORTANT>` tags.
2. The bootstrap teaches the model that Slopnought exists, that it must be checked before acting, and how to use the agent's native tools.
3. The model loads additional reference files (`references/code-generation-mode.md`, `references/refactoring-mode.md`, etc.) as needed during the session.

## Skill modes

- **Code generation mode** — for writing new code. Read `references/code-generation-mode.md`.
- **Codebase refactoring mode** — invoked via `/slopnought-audit`. Read `references/refactoring-mode.md`.

## Key reference files

- `references/anti-patterns.md` — catalog of LLM code failure modes. Read once per session.
- `references/code-generation-mode.md` — how to write maintainable new code.
- `references/refactoring-mode.md` — how to audit and improve existing code.
- `references/architecture-records.md` — when and how to write ADRs.
- `assets/adr-template.md` — ADR template.

## Adding to a new agent

To add Slopnought to a new coding agent:

1. Create a bootstrap injection mechanism (hook, plugin, or context file)
2. Create a manifest the agent recognizes
3. Verify the bootstrap is injected at session start
