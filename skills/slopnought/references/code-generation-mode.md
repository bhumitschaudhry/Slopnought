# Code Generation Mode

This mode governs how to write new code — features, modules, services, bug fixes, anything that will persist in a codebase. The goal stated plainly: **solve the task in a way that someone with zero context can pick up later, understand quickly, change safely, and trust.**

Read `anti-patterns.md` alongside this if you haven't already this session — every section below is, in part, a defense against one or more of those failure modes.

## Before writing any code

A few minutes of orientation prevents most of the failure modes in `anti-patterns.md`. Skip this only for genuinely throwaway scripts with no future readers.

1. **Look at what's already there.** Is this an existing codebase or a greenfield project? If existing: read the relevant directory structure, find 2-3 files that do something similar to what you're about to write, and note their conventions — naming, error handling style, how they're tested, how they're organized into layers. Your new code should look like a natural sibling to these, not an import from elsewhere.
2. **Identify the architectural boundary this code belongs to.** Is this business logic, a data access layer, a UI component, an API handler, infrastructure/config? Each layer has a job; code that does two layers' jobs at once (e.g., a UI component that also contains business rules and direct database calls) is the seed of architecture drift.
3. **Check for existing abstractions before building new ones.** Search for utilities, helpers, base classes, or shared modules that already do something close to what you need. Reuse or extend rather than duplicate (see anti-pattern #1).
4. **Note what you don't know.** If the task is ambiguous about behavior at the edges (what happens on empty input? on failure? on concurrent access?), decide explicitly and write the decision down — don't let it default silently.

## Architectural boundaries

Maintainable systems have a small number of clear, named layers, and each piece of code lives in exactly one. Common patterns: presentation/UI ↔ application/business logic ↔ data access ↔ infrastructure. The exact names and count vary by project and framework — match whatever the project already uses, or for greenfield work, pick something conventional for the stack and state it.

Rules of thumb:
- **Business logic should not know about its caller.** A function that computes a price, validates an order, or applies a business rule shouldn't need to know whether it's being called from an HTTP handler, a CLI, or a test.
- **Data access should not contain business rules.** A repository or query function returns data; it doesn't decide whether that data means the order is "fulfillable."
- **UI/presentation should orchestrate, not decide.** It calls into business logic and renders the result; it shouldn't independently re-implement validation or calculations that exist elsewhere.
- **Dependencies should point one direction.** Lower layers (data access, infrastructure) shouldn't import from or know about higher layers (business logic, UI). If they need to, that's usually a sign something is misplaced or a dependency-inversion pattern (interfaces/protocols) is needed.

When a task seems to require violating these boundaries (e.g., "just put the database call directly in the component, it's faster"), that's worth surfacing to the user as a tradeoff rather than doing silently — sometimes the shortcut is genuinely the right call for a prototype, but it should be a decision, not a default.

## Modular design and reusable abstractions

- **Single responsibility per module/function.** If describing what a function does requires "and," it's often two functions. This isn't a hard rule (some glue code legitimately does several small things) but it's a useful pressure check.
- **Extract abstractions when you see real repetition, not before.** Don't build a generic plugin system for one use case "in case we need it later" — that's speculative generality, which is its own maintainability cost (see Scope Discipline in SKILL.md). Extract when you actually see the same logic needed twice, or when the task explicitly calls for extensibility.
- **Prefer composition over deep inheritance.** Deep inheritance hierarchies are notoriously hard for a newcomer (or a future agent) to trace; composition and explicit interfaces are usually easier to follow and modify.
- **Keep functions and files at a human-readable size.** There's no universal hard number, but if a function is doing five distinct things, or a file has grown to hold three unrelated concerns, that's a maintainability cost worth splitting up as part of the current change, not deferring.

## Meaningful naming

Names are the cheapest, highest-leverage documentation a codebase has — they're read far more often than any comment.

- Names should describe **what something is or does**, not how it's implemented or how it was historically built (`activeUserSessions`, not `tempList2` or `dataFromOldMigration`).
- Booleans read as predicates (`isValid`, `hasPermission`, `canRetry`), not ambiguous nouns.
- Functions that have side effects should signal it (`saveUser`, `deleteCache`) — a function named like a pure query (`getUser`) shouldn't quietly mutate state.
- Match the vocabulary of the domain. If the business calls something an "invoice," don't call it a "bill" in one place and an "invoice" in another — pick the term the domain/codebase already uses and stay consistent.
- Avoid abbreviations unless they're already idiomatic in the codebase or domain (`id`, `url` are fine; `usrCfgMgr` is not).

## Error handling

- **Decide and state the error-handling strategy up front, and be consistent with it.** Exceptions vs. result/error-return types vs. error codes — pick what the codebase already uses; for greenfield work, pick one and apply it uniformly.
- **Fail at the boundary, with a specific, actionable message.** Validate inputs where they enter the system (API boundary, function's public interface, file/config load) and reject bad input with a message that says what was wrong and ideally what was expected — not a generic "something went wrong."
- **Never silently swallow an error.** Catching an exception and doing nothing (or just logging at debug level and continuing) hides failures from everyone, including future debugging. If an error is genuinely safe to ignore, say why in a comment.
- **Distinguish recoverable from unrecoverable conditions.** A transient network error might warrant a retry; a programming error (null where a value was guaranteed) usually shouldn't be silently caught — it should surface loudly so it gets fixed.
- **Don't use exceptions/errors for ordinary control flow** where a normal return value or explicit type would be clearer (e.g., "not found" is often a legitimate return value, not necessarily an exception).

## Security baseline

Treat these as default behavior, not optional extras, for any code that touches user input, external data, secrets, or auth:

- **Never trust input.** Validate and sanitize at every trust boundary — user input, query params, file uploads, third-party API responses, even data read back from your own database if it could have been written by untrusted code paths.
- **Parameterize, never interpolate, for queries.** SQL/NoSQL queries built via string concatenation of user input are an injection risk regardless of how unlikely it seems in context.
- **Never hardcode secrets, keys, or credentials.** Use environment variables, secret managers, or whatever mechanism the project already uses. If you encounter a hardcoded secret while working in existing code, flag it — don't add a second one.
- **Apply least privilege.** Code should request/use only the access it actually needs (file permissions, DB roles, API scopes).
- **Encode output for its destination.** HTML-escape before rendering into HTML, parameterize before rendering into shell commands, etc. — injection isn't only a SQL problem.
- **Don't write your own crypto.** Use established, maintained libraries for hashing, encryption, and token generation.
- **Log enough to debug, not enough to leak.** Don't log secrets, full credit card numbers, passwords, or other sensitive personal data, even at debug level.

If a security tradeoff is being made deliberately (e.g., skipping auth on an internal-only dev endpoint), say so explicitly rather than leaving it to look like an oversight.

## Documentation of intent

The goal isn't maximal documentation — it's making sure intent isn't trapped in one person's (or one session's) head.

- **Comment the why, not the what.** `// increment counter` above `counter++` is noise. `// retry budget capped at 3 — the upstream API rate-limits aggressively past that` is signal.
- **Document module-level purpose.** Each non-trivial module/file should make it discoverable, at a glance, what it's responsible for and why it exists as a separate unit — a short header comment or docstring is usually enough.
- **Document public interfaces.** Functions/classes/endpoints that other code depends on should document parameters, return values, error conditions, and any non-obvious preconditions — especially anything a caller could get wrong.
- **Call out risk.** If a piece of code is fragile, has a non-obvious failure mode, or interacts with something external in a way that isn't safe to casually change, say so directly ("this assumes X; if that assumption breaks, see Y").
- **Use an ADR for decisions with lasting structural impact.** Choice of database, major library, architectural pattern, or anything where a future developer might reasonably ask "why did we do it this way instead of the obvious alternative?" — see `architecture-records.md`. Not every decision needs one; reserve it for choices that would be expensive to silently reverse or hard to reconstruct the reasoning for.

## Testing

- **Tests are part of the deliverable, not an optional follow-up.** Code without tests isn't verifiably correct and isn't safely changeable — both are maintainability failures, independent of whether the code happens to work right now.
- **Test behavior, not implementation.** Tests should describe what the code is supposed to do in terms a domain reader would recognize, so they remain valid (and remain useful documentation) even if the implementation is refactored.
- **Cover the edges, not just the happy path.** Empty input, boundary values, error conditions, concurrent access where relevant — these are exactly where weak validation (anti-pattern #7) hides.
- **Name tests so failures are self-explanatory.** A failing test named `test_2` tells the next person nothing. `test_rejects_negative_quantity` tells them exactly what broke.
- **Match the project's existing test framework and conventions** rather than introducing a second one.
- **If something genuinely can't be tested yet** (e.g., requires infrastructure not available in this environment), say so explicitly and note what coverage is missing, rather than silently skipping it.

## Closing the loop

Before considering a piece of work finished, re-run the core question from SKILL.md against the actual diff: would an unfamiliar developer understand what changed, why, how it fits, how it's tested, and what's risky about it? If anything in this checklist was skipped or shortcut for a real reason (time pressure, environment limitation, explicit user instruction), say so plainly rather than letting it pass as a silent gap — that's the single highest-leverage habit for keeping a codebase honest about its own state.
