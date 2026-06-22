# Skill Modes

Slopnought has two modes, each designed for a different phase of software development.

## Code generation mode

**When:** Always active when writing new code — features, modules, services, bug fixes, anything that will persist in a codebase.

**Goal:** Solve the task in a way that someone with zero context can pick up later, understand quickly, change safely, and trust.

**Full reference:** `skills/slopnought/references/code-generation-mode.md`

### Before writing any code

1. **Look at what's already there.** Find 2-3 similar files and note their conventions. New code should look like a natural sibling, not an import from elsewhere.
2. **Identify the architectural boundary.** Business logic, data access, UI, API handler, infrastructure? Each layer has a job.
3. **Check for existing abstractions.** Search before building. Reuse or extend rather than duplicate.
4. **Note what you don't know.** Decide explicitly about edge cases and write the decision down.

### Key areas enforced

- **Architectural boundaries** — clear layering, one-directional dependencies
- **Modular design** — single responsibility, composition over inheritance
- **Meaningful naming** — describe what something is, not how it was built
- **Error handling** — consistent strategy, fail at the boundary, never swallow errors
- **Security baseline** — never trust input, parameterize queries, least privilege
- **Documentation of intent** — comment the why, not the what
- **Testing** — tests are part of the deliverable, test behavior not implementation

### Anti-patterns to avoid

Code generation mode defends against these failure modes (full catalog in `references/anti-patterns.md`):

1. **Duplicated logic** — same rule in multiple places
2. **Context collapse** — code that fits the request but not the system
3. **Brittle shortcuts** — hardcoded values, magic numbers, swallowed exceptions
4. **Inconsistent conventions** — mixed naming, error handling, formatting
5. **Hidden dependencies** — implicit coupling via execution order or shared state
6. **Missing rationale** — unusual code with no explanation of why
7. **Weak validation** — trusting input without checking it
8. **Architecture drift** — codebase structure gradually diverging from intended design

---

## Codebase refactoring mode

**When:** Invoked via `/slopnought-audit` or equivalent phrasing ("audit this codebase," "find tech debt," "help us clean this up").

**Goal:** Analyze an existing codebase, produce a prioritized, evidence-based remediation plan, and — only with consent — apply improvements.

**Full reference:** `skills/slopnought/references/refactoring-mode.md`

### Workflow

```
┌─────────────┐     ┌──────────┐     ┌──────────────┐     ┌──────────┐
│ 1. Scope     │────→│ 2. Scan  │────→│ 3. Score &   │────→│ 4. Report│
│    audit     │     │          │     │    prioritize │     │          │
└─────────────┘     └──────────┘     └──────────────┘     └──────────┘
                                                                │
                                                          ┌─────▼──────┐
                                                          │ 5. Remediate│
                                                          │ (optional)  │
                                                          └─────┬──────┘
                                                                │
                                                          ┌─────▼──────┐
                                                          │ 6. Preserve │
                                                          │    context  │
                                                          └────────────┘
```

### Step 1: Scope the audit

Before scanning, clarify:
- Whole codebase, or a specific area?
- Read-only analysis, or analysis + remediation?
- Any known pain points already?
- Constraints (languages, deadlines, legacy areas)?

### Step 2: Scan

Work through the codebase systematically against these categories:

- **Architectural weaknesses** — layering violations, circular dependencies, unclear entry points
- **Code smells** — duplicated logic, dead code, god objects
- **Oversized files/functions** — relative to codebase norms
- **Inconsistent patterns** — naming, error handling, different approaches to the same problem
- **Missing tests** — no coverage, weak tests, skipped tests
- **Undocumented business logic** — non-obvious rules with no explanation
- **Security concerns** — injection risks, hardcoded secrets, missing validation
- **Unclear project intent** — no documentation of what the system is for

### Step 3: Score and prioritize

For each finding, assess:
- **Risk** — cost of not fixing (production incidents, security exposure, development slowdown)
- **Effort** — blast radius, test coverage, design decisions needed

Bucket findings (Critical / High / Medium / Low) and order by risk × effort.

### Step 4: Report

Produce a remediation plan with: Summary, Scope and method, Findings by priority, Suggested sequencing, What this audit did not cover.

### Step 5: Remediate (with consent)

- Confirm scope before starting
- Work in small, reviewable increments
- Tests before refactor where missing
- Apply code generation mode to every fix
- Re-run tests after each increment
- Don't silently change behavior

### Step 6: Preserve context

For any structural decision made during remediation, write an ADR (see [ADR Guide](./adr-guide.md)).

---

## Using both modes together

A typical workflow:

1. **Refactoring mode** identifies tech debt and produces a remediation plan
2. **Code generation mode** guides the actual fixes, ensuring each change is maintainable
3. **ADR guide** documents the decisions made during remediation

The modes share the same anti-patterns catalog and non-negotiable principles — they just apply them at different scales.
