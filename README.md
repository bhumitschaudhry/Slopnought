# Slopnought

An AI coding skill that makes generated code maintainable. Not "feature complete" — **future developer friendly.**

LLMs are great at solving today's problem. They're terrible at leaving code you can safely change tomorrow. Slopnought fixes that.

---

## The Problem

You've seen this before: the AI writes code that works, then you try to modify it three weeks later and nothing makes sense. Business logic is duplicated across files. Architecture happened by accident. Nobody wrote down *why* anything was built this way.

Slopnought is a prompt-level skill that makes your coding agent think about maintainability *while it writes code*, not after.

---

## What It Does

**Code Generation Mode** — active whenever your agent writes new code. It pushes for clear boundaries, good naming, explicit errors, and decisions documented with rationale.

**Refactoring Mode** — run `/slopnought-audit` to get a prioritized list of what's wrong with your codebase. Not a style checklist — actual architectural problems, hidden coupling, missing tests, and security gaps.

---

## Installation

Easiest way — just tell your agent:

```text
Load the Slopnought maintainability skill from https://github.com/BhumitChaudhry/Slopnought
```

Or install permanently for **Claude Code**:

```bash
git clone https://github.com/BhumitChaudhry/Slopnought.git
cp -r Slopnought/skills/slopnought ~/.claude/skills/slopnought
```

It'll load automatically at session start.

---

## What's Inside

```
skills/slopnought/
├── SKILL.md                          # Main skill instructions
├── references/
│   ├── anti-patterns.md              # Common AI code failure modes
│   ├── code-generation-mode.md       # How to write maintainable code
│   ├── refactoring-mode.md           # How to audit existing code
│   └── architecture-records.md       # When/how to write ADRs
└── assets/
    └── adr-template.md              # Template for architecture decisions
```

---

## The Core Idea

Before your agent finishes writing code, ask:

> Would a developer who's never seen this project understand what this does, why it exists, how to test it, and what breaks if they change it?

If not, it's not done.

---

## License

MIT
