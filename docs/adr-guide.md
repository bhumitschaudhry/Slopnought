# Architecture Decision Records (ADR) Guide

ADRs are how rationale survives past the context window or conversation that produced a decision. Slopnought includes ADR support in both code generation and refactoring modes.

## What is an ADR?

An ADR is a short, durable record of a decision that has lasting structural impact on a codebase — the kind of decision a future developer (or agent) would otherwise have to reverse-engineer from the code alone, or guess at.

## When to write one

Write an ADR when a decision meets most of these:

- It would be **expensive or risky to silently reverse** (e.g., choice of database, core library, major architectural pattern).
- A reasonable future developer might ask **"why didn't we just do the obvious simpler thing?"** and the answer isn't self-evident from the code.
- It **constrains future work** — once made, other decisions build on top of it.
- It involved **real tradeoffs**, where more than one reasonable option existed and one was chosen for specific reasons.

**Don't** write one for routine implementation choices, naming, or anything where the "obvious" approach was simply taken with no real alternative considered.

## Where to put them

Conventionally, a numbered, append-only log:

```
docs/adr/0001-use-postgres-for-primary-storage.md
docs/adr/0002-standardize-on-result-types-for-error-handling.md
```

If the project already has a convention (`docs/decisions/`, `DECISIONS.md`, a wiki), match that instead of inventing a new location.

ADRs are **never edited to reflect new thinking** — if a past decision is later reversed, write a new ADR that explicitly supersedes the old one. The old one stays, marked as superseded, because the history is itself valuable context.

## Template

Use `skills/slopnought/assets/adr-template.md` as the starting structure:

```markdown
# [ADR number]. [Short, descriptive title]

**Status:** Proposed | Accepted | Superseded by [ADR-XXXX]
**Date:** [YYYY-MM-DD]

## Context
What situation or problem prompted this decision?

## Decision
State plainly what was decided.

## Alternatives considered
- **[Alternative A]** — what it was, why it wasn't chosen.
- **[Alternative B]** — what it was, why it wasn't chosen.

## Consequences
**This makes easier:**
- ...

**This makes harder, or forecloses:**
- ...

**Risks introduced:**
- ...

## Notes
Optional: links to related ADRs, relevant discussions, code locations.
```

## Writing them well

- **Write for zero context.** The reader wasn't there when the decision was made.
- **Be honest about downsides.** An ADR that only lists upsides is marketing, not documentation.
- **Be factual and specific.** "We chose Postgres because it's good" is not useful. "We chose Postgres over MongoDB because the data is highly relational and we needed transactional guarantees across those relationships" is.
- **Reference from code.** Add a comment like `// see docs/adr/0003-...` near the relevant code so someone reading the code stumbles into the rationale.

## ADRs in Slopnought's modes

### During code generation

When you make a non-trivial architectural choice while writing new code, consider whether it warrants an ADR. The decision should be:
- Expensive to reverse
- Non-obvious to a future reader
- Constraining future work

### During refactoring audits

Step 6 of the refactoring workflow explicitly calls for ADRs. Any remediation that reflects a real decision (choosing a pattern to standardize on, restructuring a module boundary) should produce an ADR.

At minimum, an audit with remediation should leave behind:
- ADRs for structural decisions made during remediation
- Updated module-level documentation for anything restructured
- A note of what was fixed, what was deferred, and what to watch for

## Example ADR

```markdown
# 0003. Use Result types for error handling

**Status:** Accepted
**Date:** 2026-06-22

## Context
The codebase had inconsistent error handling: some functions threw exceptions, some returned null, some returned error objects. This made it impossible to write reliable error-handling code at call sites, and every new function required understanding which convention it followed.

## Decision
Standardize on `Result<T, E>` return types for all business logic functions. Exceptions are reserved for truly unrecoverable conditions (out of memory, corrupted state).

## Alternatives considered
- **Keep exceptions everywhere** — the current default, but leads to swallowed errors and unreliable catch blocks.
- **Error codes** — simpler but loses type safety and doesn't compose well.
- **Go-style `(value, error)` tuples** — similar to Result but less expressive for complex error types.

## Consequences
**This makes easier:**
- Exhaustive error handling at call sites (compiler enforces checking)
- Composing error-prone operations (Result.map, Result.flatMap)
- Testing error paths (no need to assert exception throwing)

**This makes harder, or forecloses:**
- Every function signature changes to return Result
- Callers must unwrap or chain, adding boilerplate
- Third-party libraries that throw must be wrapped at the boundary

**Risks introduced:**
- Migration risk: existing code that throws won't be caught by new error handling until migrated
- Team unfamiliarity with Result patterns may slow initial adoption

## Notes
- See `src/errors/result.ts` for the Result type implementation
- See `docs/adr/0002-...` for the related decision on error type taxonomy
```
