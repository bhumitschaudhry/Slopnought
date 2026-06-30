# Slopnought Documentation

Welcome to the Slopnought documentation. Slopnought is a code maintainability skill that makes AI-generated code understandable, extensible, testable, secure, and maintainable across 11 coding agents.

## Guides

| Document | Description |
|---|---|
| [Installation](./installation.md) | Install Slopnought in any of the 11 supported agents |
| [Architecture](./architecture.md) | The three-layer architecture that makes cross-agent skills work |
| [Bootstrap Injection](./bootstrap.md) | How the bootstrap reaches the model in each agent |
| [Skill Modes](./skill-modes.md) | Code generation mode and codebase refactoring mode |
| [Tool Mappings](./tool-mappings.md) | Per-agent tool name translation tables |
| [Architecture Decision Records](./adr-guide.md) | When and how to write ADRs using Slopnought |
| [Contributing](./contributing.md) | Add Slopnought to a new coding agent |

## Quick start

Pick your agent and clone the repo:

```bash
git clone https://github.com/BhumitChaudhry/Slopnought.git
```

Then follow the agent-specific instructions in [Installation](./installation.md):

```bash
# Claude Code — copy skills into place
cp -r Slopnought/skills/slopnought ~/.claude/skills/slopnought
cp -r Slopnought/skills/slopnought-audit ~/.claude/skills/slopnought-audit

# OpenCode — add to opencode.json plugin array
# Pi — pi install git:github.com/BhumitChaudhry/Slopnought
# Antigravity — cd Slopnought && bash install-agy.sh
```

See [Installation](./installation.md) for all 11 agents.

## What Slopnought does

Slopnought turns maintainability into a first-class requirement. Instead of code that merely passes the task, you get code a stranger could pick up, understand in minutes, change safely, and trust the tests to catch their mistakes.

**Two modes:**

- **Code generation mode** — always active when writing new code. Enforces architectural boundaries, consistent patterns, meaningful naming, error handling, security baselines, documentation of intent, and tests.
- **Codebase refactoring mode** — invoked via `/slopnought-audit`. Scans an existing codebase for architectural weaknesses, code smells, duplication, missing tests, undocumented business logic, and security issues, then produces a prioritized remediation plan.

## The core question

Before writing or changing a single line, and again before calling the work done:

> If a competent developer who has never seen this project opened this file with no other context, would they understand what it does, why it exists, how it connects to the rest of the system, how to verify it works, and what they'd risk by changing it?
