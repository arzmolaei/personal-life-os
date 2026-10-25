# Architecture Specification

## 1. Architecture style

Personal Life OS uses a **local-first modular monolith** for Android.

This means:

- one deployable Android application
- strong internal domain boundaries
- local database as primary source of truth
- offline-capable core workflows
- optional network integrations at the edges
- no mandatory backend for basic product value

Microservices are explicitly rejected for the initial product because they add operational complexity without solving a current product problem.

## 2. Architectural priorities

In order:

1. correctness
2. security/privacy
3. data integrity
4. reliability/recovery
5. maintainability
6. UX
7. performance
8. scalability

## 3. Domain map

```text
                PERSONAL LIFE OS
                       |
        +--------------+--------------+
        |              |              |
     FINANCE         LIFE          INTELLIGENCE
        |              |              |
   ledger/money     planning       matching
   accounts         activity       classification
   transactions     routines       forecast
   loans/debts      projects       insights
   assets           goals          assistant
        |              |              |
        +--------------+--------------+
                       |
                EXPERIENCE LAYER
                       |
             Today / History / Search
```

The detailed logical domains are:

- Finance
- Planning
- Activity
- Review / History
- Intelligence
- Shared Kernel / Infrastructure

## 4. Ownership rule

Every canonical entity has exactly one owning domain.

No other domain may directly mutate that entity's persistence representation.

Cross-domain behavior happens through:

- application use cases/orchestration
- explicit interfaces
- entity links
- internal domain events
- read-model projections

A cross-domain convenience query is not justification for collapsing domain boundaries.

## 5. Finance domain

Owns canonical financial truth.

Major concepts:

- Money
- Account
- JournalEntry
- JournalLine
- SourceEvent
- Transaction metadata
- Merchant
- Counterparty
- Category
- BalanceSnapshot
- Loan
- Installment
- Debt/Receivable
- Budget/Plan
- Commitment
- Financial Goal/Reserve
- Asset
- AssetValuation

Finance must maintain explicit invariants around balanced movement, transfers, refunds, liabilities, and reconciliation.

## 6. Planning domain

Owns future intent.

Major concepts:

- Area
- Project
- Goal
- Milestone
- Task
- TaskSchedule
- Reminder
- Routine definition
- DailyPlan
- Weekly planning structures

Scheduling intent must not be overwritten merely because reality changed.

## 7. Activity domain

Owns actual historical execution.

Major concepts:

- TaskCompletion
- TaskReschedule/transition history
- RoutineOccurrence
- ActivityLog
- FocusSession (optional/later)
- DailyNote

Planning answers “what was intended?”. Activity answers “what actually happened?”.

## 8. Review / History domain

Owns derived read models, not canonical truth.

Examples:

- Today projection
- Daily timeline
- Weekly review
- Monthly review
- Yearly review
- Calendar history
- project/activity summaries
- combined life/finance history

All derived read models must be rebuildable from canonical data.

## 9. Intelligence domain

Owns derived interpretation and recommendations.

Includes:

- parser confidence
- duplicate matching
- transfer/refund/payment matching
- classification
- anomaly detection
- safe-to-spend calculation service
- forecast
- insights
- scenario simulation
- later natural-language query/explanation

Intelligence can propose. Canonical domains validate and own accepted state.

AI output is never direct financial truth.

## 10. Shared kernel

Only genuinely shared value concepts belong here.

Candidate concepts:

- EntityId
- Money type/value primitives
- Currency
- Instant/LocalDate/LocalTime abstractions
- Tag primitives
- Reminder primitives
- EntityLink
- Audit metadata
- result/error primitives

The shared kernel must stay small. If a concept is domain-specific, it stays in its domain.

## 11. Application layers

Per feature/domain, target flow:

```text
Compose UI
   ↓
Presentation / ViewModel
   ↓
Application Use Case
   ↓
Domain Model / Policy
   ↓
Repository Interface
   ↓
Repository Implementation
   ↓
Local / Device / Optional Network Data Source
```

UI must not contain persistence queries or core business rules.

## 12. State flow

Target UI architecture uses unidirectional data flow.

- persistent data changes in repository/database
- repositories expose reactive streams
- use cases compose domain behavior
- ViewModels produce UI state
- Compose renders state and emits user intents

Avoid hidden mutable singleton state.

## 13. Local source of truth

Canonical user data is local first.

Cloud services, when added, must synchronize or back up local state rather than becoming required runtime truth for basic features.

A server outage must not make core finance/tasks/history unusable.

## 14. Transaction capture architecture

All raw capture sources feed a common pipeline:

```text
SMS
Notification
Manual entry
File import
Recurring rule
Future API
      ↓
SourceEvent
      ↓
Normalize
      ↓
Parse
      ↓
Deduplicate
      ↓
Account match
      ↓
Transaction/event match
      ↓
Type detection
      ↓
Merchant/counterparty match
      ↓
Classification
      ↓
Confidence/risk decision
      ↓
Auto-confirm OR Review Inbox
      ↓
Finance canonical model
```

Raw source and canonical transaction remain separate.

## 15. Parser architecture

Bank parsers are versioned adapters/plugins behind a common interface.

Requirements:

- parser identity/version recorded with parsed source event
- fixtures/regression tests per supported pattern
- unknown/ambiguous is safer than wrong
- remote rule packs may update declarative patterns
- remote rules must be authenticated/versioned and unable to execute arbitrary code

## 16. Internal event architecture

Use a lightweight in-process event mechanism when cross-domain reactions are needed.

Examples:

- financial payment matched → application orchestration may complete a linked task
- task completed → review projection updates
- account reconciled → finance health projection updates

Do not introduce Kafka/RabbitMQ or distributed event infrastructure for the mobile monolith.

Important events that affect audit/recovery may also be persisted.

## 17. Entity linking

Cross-domain relationships should use an explicit link concept rather than foreign-key coupling across every table.

Conceptual structure:

```text
EntityLink
- sourceType
- sourceId
- targetType
- targetId
- linkType
- createdAt
```

Examples:

- Task ↔ Financial Commitment
- Task ↔ Transaction
- Goal ↔ Account/Reserve
- Project ↔ Financial plan

Links do not transfer ownership.

## 18. Database direction

Target local persistence is Room/SQLite unless an ADR replaces it.

Database design rules:

- explicit primary keys suitable for future synchronization
- no floating point money
- migrations are first-class code
- migration tests are mandatory
- audit/history where overwrite would destroy meaning
- indexes based on demonstrated query paths
- derived summaries should not become the only copy of truth

## 19. Identifier direction

Use globally unique identifiers for canonical entities rather than relying solely on local auto-increment IDs.

Reason: future multi-device sync or import/merge becomes far safer when IDs are not device-local sequences.

Exact ID format is deferred to the data-model ADR/spec.

## 20. Date/time model

Do not conflate:

- instant in time
- calendar date
- local wall-clock time
- timezone

A task scheduled for a Jalali-visible calendar date must not shift merely because the user changes timezone.

Store canonical temporal data in appropriate semantic types; convert for Persian/Jalali presentation at the UI boundary.

## 21. Backup architecture

Backup is a first-class recovery subsystem.

Target paths:

- encrypted local backup
- optional encrypted user-owned cloud backup (for example Google Drive)
- structured export where appropriate

Restore flow must validate:

- encryption/version metadata
- checksum/integrity
- schema compatibility
- parseability

Never replace a valid local database with an invalid backup before validation succeeds.

## 22. Search architecture

Global search is cross-domain but does not own canonical entities.

A dedicated search index/read model may be built from domain changes.

Search must support structured fields first. Natural language is a later translation layer over safe structured queries.

## 23. Security architecture

Security concerns cross all layers:

- local data protection
- Android Keystore-backed key handling
- biometric/PIN application lock
- encrypted backup
- sensitive logging restrictions
- secure parser rule delivery
- privacy-safe diagnostics
- screenshot/recent-app privacy options where appropriate

See `docs/SECURITY_AND_PRIVACY.md`.

## 24. Observability architecture

Logs and diagnostics are metadata-first and privacy-safe.

Never require raw user financial/life content for ordinary debugging.

See `docs/LOGGING_AND_OBSERVABILITY.md`.

## 25. Target Android technology direction

Exact versions will be frozen later in a toolchain ADR.

Current direction:

- Kotlin
- Jetpack Compose
- AndroidX
- Room
- Coroutines + Flow
- WorkManager
- DataStore for appropriate preferences
- dependency injection (implementation to be frozen later)
- Gradle version catalog/convention plugins once scaffolded

Avoid adopting libraries before a concrete need exists.

## 26. Proposed module direction

Initial module map may evolve through ADRs, but target responsibilities are:

```text
:app

:core:model
:core:domain
:core:database
:core:security
:core:designsystem
:core:search
:core:testing

:finance:ledger
:finance:accounts
:finance:transactions
:finance:planning

:life:planning
:life:activity
:life:routines
:life:projects

:review:history
:intelligence:matching
:intelligence:classification
:intelligence:forecast

:capture:sms
:capture:notification
:capture:import

:feature:today
:feature:money
:feature:plan
:feature:history
:feature:settings
```

Do not create modules purely for architectural aesthetics. Module boundaries should enforce meaningful ownership or build/test isolation.

## 27. Performance expectations

The product should remain responsive with many years of personal data.

Principles:

- no heavy I/O on main thread
- reactive incremental queries
- indexes for real query paths
- avoid recomputing expensive cross-domain summaries on every frame
- use rebuildable projections/caches where justified
- performance tests only where evidence indicates risk

## 28. Failure strategy

Failures must be explicit and recoverable.

Examples:

- parser unsure → review inbox
- backup corrupt → refuse restore, preserve current data
- balance mismatch → expose reconciliation state
- import partially invalid → preview and deterministic acceptance policy
- background sync/update unavailable → local core still works

Never silently coerce invalid financial data just to keep a flow moving.

## 29. Evolution rule

Architecture may change, but significant changes require an ADR describing:

- problem
- options considered
- decision
- consequences
- migration impact
- rollback/recovery impact

Large rewrites are not allowed without evidence and an approved ADR.
