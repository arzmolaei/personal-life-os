# ADR-0002: Separate Finance, Planning, and Activity ownership

- Status: Accepted
- Date: 2026-10-25

## Context

The product combines money management with tasks, routines, and historical activity. A naive design could place everything into one generic “activity” table or allow direct cross-domain mutations. That would make financial correctness, historical truth, testing, and parallel AI development fragile.

## Decision

Maintain distinct canonical ownership:

- **Finance** owns financial truth.
- **Planning** owns future intent.
- **Activity** owns what actually happened.
- **Review/History** owns derived projections only.
- **Intelligence** proposes classifications/forecasts but does not own canonical truth.

Cross-domain relationships use explicit application orchestration, entity links, read projections, or internal events rather than direct table ownership leakage.

## Alternatives considered

### One generic event/activity model

Rejected because it makes money invariants and planning/history semantics harder to enforce and reason about.

### Finance as primary domain with tasks attached

Rejected because planning/activity is a first-class product capability, not a note field on accounting records.

### Planning as primary domain with financial attributes

Rejected because financial transactions require dedicated ledger/accounting semantics and reconciliation.

## Consequences

Positive:

- clearer ownership and tests
- easier independent development
- preserved distinction between plan and reality
- finance remains correct even as life features grow

Negative:

- cross-domain views require projections/orchestration
- some concepts need explicit linking instead of simple foreign keys

## Migration / recovery impact

No production migration now. Future schema changes that collapse these boundaries require a superseding ADR and migration/recovery plan.

## Revisit triggers

Only if real implementation experience demonstrates that a specific boundary creates duplicated canonical truth that cannot be resolved through interfaces/projections.
