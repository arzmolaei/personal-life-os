# Architecture Decision Records (ADRs)

ADRs record important technical/product-architecture decisions so future agents do not re-open settled questions without evidence.

## Status values

- Proposed
- Accepted
- Superseded
- Rejected
- Deprecated

## Naming

`NNNN-short-decision-title.md`

Never reuse an ADR number.

## Required structure

```markdown
# ADR-NNNN: Title

- Status: Accepted
- Date: YYYY-MM-DD

## Context
What problem/constraint requires a decision?

## Decision
What is being chosen?

## Alternatives considered
What credible alternatives were evaluated and why were they not selected?

## Consequences
Positive and negative consequences.

## Migration / recovery impact
What does this mean for existing data/code and rollback?

## Revisit triggers
What evidence would justify reopening this decision?
```

## Rules

- Significant architecture changes require an ADR before or with implementation.
- ADRs explain **why**, specs explain **what**, code/tests explain **how**.
- Do not edit an old accepted ADR to pretend a later decision was always true. Create a new ADR that supersedes it.
- An agent may make routine implementation decisions without ADRs when they do not change architecture, data ownership, privacy/security posture, or public behavior.
