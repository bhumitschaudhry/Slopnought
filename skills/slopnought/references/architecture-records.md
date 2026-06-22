# Architecture Decision Records (ADRs)

An ADR is a short, durable record of a decision that has lasting structural impact on a codebase — the kind of decision a future developer (or agent) would otherwise have to reverse-engineer from the code alone, or guess at. ADRs are how rationale survives past the context window or conversation that produced it.

## When to write one

Write an ADR when a decision meets most of these:
- It would be **expensive or risky to silently reverse** (e.g., choice of database, core library, major architectural pattern).
- A reasonable future developer might ask **"why didn't we just do the obvious simpler thing?"** and the answer isn't self-evident from the code.
- It **constrains future work** — once made, other decisions build on top of it.
- It involved **real tradeoffs**, where more than one reasonable option existed and one was chosen for specific reasons.

Don't write one for routine implementation choices, naming, or anything where the "obvious" approach was simply taken with no real alternative considered — that's just normal code, not a decision worth preserving separately.

## Where to put them

Conventionally, a numbered, append-only log: `docs/adr/0001-use-postgres-for-primary-storage.md`, `docs/adr/0002-standardize-on-result-types-for-error-handling.md`, etc. If the project already has a convention (a `docs/decisions/` folder, a `DECISIONS.md`, a wiki), match that instead of inventing a new location.

ADRs are **never edited to reflect new thinking** — if a past decision is later reversed or changed, write a new ADR that explicitly supersedes the old one and says why. The old one stays, marked as superseded, because the history of "we used to do X for reason Y, then switched to Z because W" is itself valuable context.

## Format

Use `assets/adr-template.md` as the starting structure. Keep ADRs short — a page or less is normal. The goal is a quick, high-signal read for someone trying to understand why something is the way it is, not an essay.

The essential sections:
- **Context** — what situation/problem prompted this decision. What were the constraints?
- **Decision** — what was actually decided, stated plainly.
- **Alternatives considered** — what else was on the table, and why each wasn't chosen. This is often the most valuable part — it preempts the future "why didn't we just..." question directly.
- **Consequences** — what this decision makes easier, what it makes harder, what it forecloses, what risks it introduces.

## Writing them well

- Write for someone with **zero context on this conversation/session** — they weren't there when the decision was made.
- Be honest about downsides. An ADR that only lists upsides is marketing, not documentation — the "consequences" section should include real costs and risks, not just benefits.
- Keep it factual and specific. "We chose Postgres because it's good" is not useful; "We chose Postgres over MongoDB because the data is highly relational (orders ↔ line items ↔ products) and we needed transactional guarantees across those relationships" is.
- Reference the ADR from the code it concerns where practical (a comment like `// see docs/adr/0003-...` near the relevant code) so someone reading the code stumbles into the rationale rather than having to know to look for it.
