# Product and Engineering Roadmap

This roadmap defines sequencing, not fixed dates. A later phase may start only when its prerequisites are stable enough to avoid expensive rework.

## Phase 0 — Foundation

Goal: create an agent-resumable, testable, recoverable project foundation before production implementation.

Deliverables:

- product spec
- architecture spec
- agent contract
- Git/versioning/recovery policy
- security/privacy model
- logging/observability policy
- test strategy
- ADR framework and initial decisions
- GitHub PR/issue templates
- repository policy verification + CI
- initial data/domain design plans

Exit gate:

- required foundation docs exist
- repository guard passes
- foundation PR is reviewed and integrated
- exact baseline commit is recorded/tagged as foundation milestone

## Phase 1 — Android/toolchain scaffold

Goal: reproducible Android project with empty but real module boundaries.

Deliverables:

- Gradle/Android/Kotlin versions frozen by ADR
- Compose app shell
- baseline modules
- CI build/lint/test
- version catalog/convention setup as justified
- test utilities

Exit gate:

- clean clone builds
- baseline unit tests run
- CI green
- no production feature logic yet

## Phase 2 — Shared primitives and canonical persistence

Goal: safe foundational types and database architecture.

Deliverables:

- Entity IDs
- money/currency representation
- temporal primitives/policies
- Room schema v1
- repository patterns
- migration test harness
- audit primitives

Exit gate:

- no floating-point money
- database round-trip tests
- migration harness working
- schema decision documented

## Phase 3 — Finance ledger core

Goal: mathematically correct financial truth before capture/UI sophistication.

Deliverables:

- Account
- JournalEntry / JournalLine
- balance invariants
- transfer semantics
- refund/reversal semantics
- loan/debt base semantics
- opening balance/adjustment rules

Exit gate:

- financial invariant suite green
- property/invariant tests where useful
- no report derives incorrect income/expense from transfers/refunds/loans

## Phase 4 — Accounts, transactions, and manual workflows

Goal: usable financial core without relying on automation.

Deliverables:

- account management
- transaction detail/edit
- category/merchant/counterparty model
- split allocation
- basic search
- book balance

Exit gate:

- critical manual workflows work offline
- financial source-of-truth behavior verified

## Phase 5 — Capture engine

Goal: multi-source event ingestion architecture.

Deliverables:

- SourceEvent
- SMS adapter (subject to platform policy/permission path)
- notification adapter
- manual source
- file import path
- deduplication/idempotency framework

Exit gate:

- duplicate raw sources do not create duplicate canonical financial records
- app remains usable when SMS permission is unavailable

## Phase 6 — Iranian parser and matching engine

Goal: reliable Iranian banking message interpretation.

Deliverables:

- versioned parser registry
- anonymized fixture library
- parser confidence
- bank/source adapters
- account matching
- transfer/refund/payment candidate matching
- remote declarative rule architecture if justified

Exit gate:

- parser regression suite green
- unknown format fails safely into review rather than wrong auto-confirmation

## Phase 7 — Financial review inbox and reconciliation

Goal: make uncertainty explicit and repairable.

Deliverables:

- review reasons
- candidate confirmation/correction
- reported vs book balance
- balance snapshots
- reconciliation flow
- auditable adjustments

Exit gate:

- ambiguous cases never silently change canonical truth
- reconciliation differences are explainable

## Phase 8 — Life planning core

Goal: real planning without destroying historical intent.

Deliverables:

- Area
- Project
- Goal/Milestone base
- Task
- TaskSchedule
- reschedule history
- TaskCompletion
- Reminder model

Exit gate:

- scheduled date vs due date semantics tested
- rescheduling preserves history
- completion records actual time

## Phase 9 — Activity, routines, and Today

Goal: answer what should happen today and what actually happened.

Deliverables:

- Routine/Occurrence
- ActivityLog
- DailyPlan
- Today projection
- quick completion/logging
- unplanned activity

Exit gate:

- Today is derived from canonical data
- day history remains reproducible

## Phase 10 — History and reviews

Goal: useful historical memory.

Deliverables:

- day view
- timeline projection
- weekly review
- monthly review
- calendar history
- cross-domain search projection

Exit gate:

- user can inspect a past date and distinguish plan from reality
- derived history rebuild tests exist

## Phase 11 — Financial planning

Goal: move from accounting to decision support.

Deliverables:

- recurring financial rules
- commitments/bills
- loans/installments depth
- debt/receivable workflows
- monthly financial plan/budget
- goal reserves/sinking funds

Exit gate:

- obligations and future reserves are represented explicitly

## Phase 12 — Safe-to-spend and forecast

Goal: provide trustworthy actionable financial position.

Deliverables:

- planning horizon rules
- current safe-to-spend
- explanation breakdown
- forecasted position
- confidence/uncertainty representation
- scenario simulation baseline

Exit gate:

- formulas are fully unit-tested
- current and forecasted money are not conflated
- every output is explainable

## Phase 13 — Assets and net worth

Goal: broader financial position.

Deliverables:

- asset holdings
- valuation snapshots
- liabilities integration
- net worth
- decomposition of savings vs valuation change

Exit gate:

- valuation changes do not masquerade as income

## Phase 14 — Backup, restore, and recovery hardening

Goal: user data survivability.

Deliverables:

- encrypted local backup
- integrity metadata
- restore preview/validation
- corrupted backup rejection
- optional user-owned cloud backup design/implementation

Exit gate:

- full restore suite green
- failed restore cannot destroy valid current data

## Phase 15 — Security and privacy hardening

Goal: production security review.

Deliverables:

- app lock
- key management review
- release logging audit
- sensitive screen behavior
- secret/dependency scanning
- permission UX

Exit gate:

- security checklist reviewed
- release build verified

## Phase 16 — UX polish, accessibility, performance

Goal: transform correct software into a high-quality daily product.

Deliverables:

- design system polish
- Persian/RTL verification
- accessibility
- empty/error states
- large-data performance review
- device compatibility review

Exit gate:

- critical journeys meet UX/performance quality bar

## Phase 17 — Intelligence and insights

Goal: useful pattern detection without making AI the truth layer.

Deliverables:

- deterministic insights
- anomaly detection
- behavior trends
- recurring/subscription suggestions
- recommendation explanations

Exit gate:

- every insight traces back to verified structured data

## Phase 18 — Optional AI assistant

Goal: natural-language access to existing structured truth.

Deliverables:

- query translation
- safe tool/data access
- structured calculation APIs
- explanation generation
- hallucination guardrails

Exit gate:

- AI never directly invents balances/transactions/history
- answers cite structured source records internally

## Phase 19 — Multi-device / household (future)

Only after a dedicated sync/security ADR.

Potential scope:

- encrypted sync
- device identity/revocation
- conflict resolution
- household/shared items
- permission model

This phase must not distort the local-first single-user architecture prematurely.

## Milestone discipline

Each phase should end with:

1. verification evidence
2. project-state update
3. known-risk review
4. clean integrated commit
5. stable tag/release or exact baseline SHA recorded

Do not claim a phase complete because its happy-path UI exists.
