# Slopnought

> *Like a dreadnought, code should still be standing—and understandable—years after it was written.*

Slopnought is a maintainability-first AI coding skill that helps coding agents produce code that remains understandable, testable, extensible, secure, and safe to modify long after the original implementation is finished.

Instead of optimizing for "feature complete," Slopnought optimizes for "future developer friendly."

---

## Why Slopnought Exists

LLM-generated code often succeeds at solving today's problem while creating tomorrow's maintenance burden.

Common failure modes include:

* Architecture that emerges accidentally instead of intentionally
* Business logic duplicated across files
* Poor naming and unclear abstractions
* Missing rationale behind important decisions
* Weak test coverage
* Hidden dependencies and side effects
* Security and validation gaps
* Code that becomes difficult to safely change after only a few iterations

Slopnought treats maintainability as a first-class requirement rather than an afterthought.

---

## Modes

### Code Generation Mode

Applied whenever new code is created.

The skill encourages:

* Clear architectural boundaries
* Consistent patterns and conventions
* Explicit error handling
* Strong validation
* Meaningful naming
* Documentation of intent rather than implementation
* Testability by design
* Minimal coupling and hidden dependencies

The goal is code that another developer can understand quickly and modify confidently.

### Refactoring Mode

Activated using:

```text
/slopnought-audit
```

The skill reviews an existing codebase and identifies:

* Architectural weaknesses
* Code smells
* Duplication
* Missing tests
* Undocumented business rules
* Security concerns
* Areas of excessive complexity

It then produces a prioritized remediation plan focused on long-term maintainability rather than superficial cleanup.

---

## Core Principle

Before writing code, and again before considering the work complete, ask:

> If a competent developer who has never seen this project opened this file today, would they understand what it does, why it exists, how it fits into the system, how to verify it works, and what risks they introduce by changing it?

If the answer is no, the implementation is not finished.

---

## Key Concepts

### Anti-Patterns

A catalog of common failure modes found in AI-generated codebases, including:

* Context-collapse architecture
* Copy-paste business logic
* Hidden assumptions
* Over-abstraction
* Under-abstraction
* Tight coupling
* Missing rationale
* Test avoidance

### Architecture Decision Records (ADRs)

Significant architectural decisions should be documented so future contributors understand:

* What decision was made
* Why it was made
* Alternatives considered
* Consequences and trade-offs

### Maintainability Reviews

Every significant change should be evaluated for:

* Clarity
* Testability
* Modularity
* Security
* Observability
* Ease of future modification

---

## Repository Structure

```text
skills/
└── slopnought/
    ├── SKILL.md
    ├── references/
    │   ├── anti-patterns.md
    │   ├── code-generation-mode.md
    │   ├── refactoring-mode.md
    │   └── architecture-records.md
    └── assets/
        └── adr-template.md
```

---

## Using Slopnought

Add the contents of `skills/slopnought/SKILL.md` to your coding agent's system prompt, instructions, memory, or skill mechanism.

Most modern coding agents support some form of reusable instruction loading. Slopnought is intentionally tool-agnostic and can be adapted to any agent environment.

---

## Design Goal

Slopnought does not attempt to make code perfect.

It attempts to make code understandable.

Because maintainable software is rarely the software with the fewest bugs—it is the software that can still be safely changed when requirements inevitably evolve.

---

## License

MIT
