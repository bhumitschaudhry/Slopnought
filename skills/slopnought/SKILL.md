---
name: slopnought
description: Use for ANY coding task — new features, bug fixes, modules, or refactors — meant to outlive this session and be touched by others later. Two modes. Code generation mode makes new code stay understandable, extensible, testable, secure, and maintainable rather than just passing the task, enforcing architectural boundaries, consistent patterns, modular design, meaningful naming, error handling, documentation of intent, and tests, while preventing duplicated logic, context collapse, brittle shortcuts, hidden dependencies, and architecture drift. Refactoring mode exposes `/slopnought-audit`, scanning an existing codebase for architectural weaknesses, code smells, duplication, oversized files, missing tests, undocumented business logic, and security issues, then producing a prioritized remediation plan and optionally applying fixes. Trigger for production code, new features, modules/services/components, codebase review or cleanup, tech debt, or code quality — even without the word "maintainability."
---

# Slopnought

## Why this skill exists

Code that merely passes the task at hand is cheap to produce and expensive to live with. The most common way LLM-generated code fails isn't that it's wrong — it's that it works once, today, and then becomes a liability: nobody (human or agent) who reads it six weeks later can tell what it does, why it does it that way, what's safe to change, or what will quietly break if they change it anyway.

This skill exists to make maintainability a **first-class requirement**, evaluated with the same seriousness as "does it work." A task isn't done when the code runs — it's done when a stranger could pick it up, understand it in minutes, change it safely, and trust the tests to catch their mistakes.

This skill has two modes:

1. **Code generation mode** — for writing new code (features, modules, services, fixes). Always active implicitly whenever the agent is producing code that isn't a disposable one-off script.
2. **Codebase refactoring mode** — invoked via `/slopnought-audit`, for analyzing and improving existing code.

Read `references/code-generation-mode.md` before writing new code under this skill, and `references/refactoring-mode.md` when running an audit. Both reference `references/anti-patterns.md`, which catalogs the specific ways LLM-generated code tends to fail — read it once at the start of a session and keep it in mind throughout.

## The core question

Before writing or changing a single line, and again before calling the work done, ask:

> **If a competent developer who has never seen this project opened this file with no other context, would they understand what it does, why it exists, how it connects to the rest of the system, how to verify it works, and what they'd risk by changing it?**

If the honest answer is no, the work isn't finished — regardless of whether the immediate task "works."

## How to use this skill

**For new code or features** → read `references/code-generation-mode.md`. It covers architectural boundaries, naming, error handling, security, documentation of intent, testing, and the specific discipline needed to avoid the failure modes in `references/anti-patterns.md`.

**For auditing or improving an existing codebase** → the user (or agent) invokes `/slopnought-audit`. Read `references/refactoring-mode.md` for the full workflow: how to scan, score, prioritize, report, and (with consent) remediate.

**For writing an Architecture Decision Record** (either mode may call for one) → use `references/architecture-records.md` and the template at `assets/adr-template.md`.

Don't try to hold all the reference material in your head at once — load the relevant file for the mode you're in, and re-check `anti-patterns.md` whenever something starts to feel like a shortcut.

## Non-negotiable principles (apply in both modes)

These five hold regardless of which mode you're in or how small the task seems:

1. **Maintainability is a requirement, not a nice-to-have.** A fast, working solution that nobody can safely modify later has not actually solved the problem — it has deferred it, with interest. Weigh maintainability alongside correctness and delivery speed when making tradeoffs, not after them.

2. **Optimize for the next reader, not for fewest keystrokes now.** The next reader might be a human teammate, a future agent session with zero memory of this one, or you in a different context window. Write as if you will have none of the context you have right now — because structurally, you won't.

3. **Every non-obvious decision needs a visible reason.** If a reviewer would reasonably ask "why is this done this way?", the answer should already be written down — in a comment, a docstring, a commit message, or an ADR — not locked in the head of whoever wrote it.

4. **Consistency beats local optimality.** A slightly-worse pattern applied consistently across a codebase is more maintainable than five locally-optimal patterns that all do the same thing differently. Match what's already there before introducing something new; if the existing pattern is genuinely bad, fix it deliberately and broadly, not by quietly adding a sixth variant.

5. **If you wouldn't want to debug it at 2am with no memory of writing it, don't ship it.** This is the gut-check version of everything above. Trust it when something feels like a shortcut.

## Scope discipline

This skill is about maintainability, not about gold-plating. It does not mean:
- Adding abstraction layers for hypothetical future requirements that don't exist yet (speculative generality is itself a maintainability problem — it adds indirection that has to be understood for no current benefit).
- Rewriting working, well-understood code because a newer pattern exists.
- Writing exhaustive documentation for trivial, self-evident code.

The judgment call is always: *does this serve the next reader, or does it serve an abstract ideal of "good code"?* When genuinely unsure whether something is over-engineering or right-sized, say so and explain the tradeoff rather than silently picking one.
