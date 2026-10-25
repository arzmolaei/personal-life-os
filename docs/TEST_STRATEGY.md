# Test and Verification Strategy

## 1. Purpose

Personal Life OS stores financial and personal-history data. A visually correct screen is not enough. The test system must protect domain invariants, migrations, backup/restore, parsers, history semantics, and critical user flows.

The repository follows an **evidence-before-completion** rule: no task is complete until fresh verification appropriate to that task has run and its result has been inspected.

## 2. Test layers

### Unit tests

Fast deterministic tests for:

- Money arithmetic
- ledger balance invariants
- financial classification policies
- safe-to-spend formulas
- loan/debt calculations
- matching policies
- parser rules
- task scheduling/history policies
- routine occurrence behavior
- date/time conversion policies
- forecast functions

### Integration tests

Tests crossing real subsystem boundaries:

- Room/database repositories
- parser → source event → matching → canonical finance flow
- database migrations
- backup creation/restore
- search projections
- cross-domain entity links
- internal event/orchestration behavior

### UI tests

Focused on high-value flows, not every visual detail:

- onboarding
- quick transaction/task entry
- financial review inbox
- task completion/reschedule
- Today screen actions
- day-history view
- backup/restore confirmation
- reconciliation

### End-to-end smoke tests

Small number of flows proving the application starts and the most important user journeys work on a representative emulator/device configuration.

## 3. Mandatory financial invariants

Tests must permanently pin these behaviors:

- internal transfer is not income/expense
- loan proceeds are not income
- principal repayment is not normal consumption expense
- refund is not income
- asset revaluation is not income
- debt collection is not income
- opening balance is not income
- money never uses floating-point representation
- unbalanced journal entries are rejected
- ambiguous financial events are not silently auto-confirmed
- duplicate source signals can map to one canonical transaction

Any change that breaks these tests is presumed incorrect until a spec/ADR intentionally changes the invariant.

## 4. Mandatory planning/activity invariants

Tests must pin:

- scheduled date and due date are different
- rescheduling preserves prior scheduling history
- completion time is historical fact and not inferred by rewriting the planned date
- unplanned activity can exist without a prior task
- recurring routine occurrences are independent historical records
- deleting/canceling future intent does not silently erase already-recorded historical activity
- day/month history is derived from canonical facts and remains reproducible

## 5. Parser regression fixtures

Every supported bank/source format must have anonymized fixtures.

Target structure:

```text
fixtures/
  finance/
    sms/
      mellat/
      melli/
      pasargad/
      saman/
    notification/
    import/
```

Each fixture should specify expected parsed output without containing real personal data.

When a parser changes, the entire relevant fixture suite runs.

Parser philosophy:

**unknown is safer than wrong**.

## 6. Database migration tests

Every schema migration after the first production schema must have automated tests covering:

- migration from each supported previous version (or documented supported path)
- preservation of canonical records
- preservation of financial amounts exactly
- preservation of task/activity history
- required indexes/constraints
- expected derived-data rebuild behavior

A migration is not complete merely because a clean install works.

## 7. Backup/restore tests

Backup tests must include:

- successful encrypted backup creation
- successful restore
- wrong key/credential handling
- corrupted archive rejection
- checksum failure
- unsupported future schema handling
- old supported schema migration after restore
- current database remains untouched when pre-restore validation fails

Backup without tested restore is not considered a backup feature.

## 8. Property-based/invariant testing

Where suitable, use generated input tests for algorithms where examples alone are weak.

Candidates:

- Money arithmetic
- balanced journal entry transformations
- split transactions preserving total amount
- safe-to-spend never losing unexplained value
- round-trip serialization
- date/calendar conversions
- matching score boundaries

## 9. Concurrency and idempotency tests

Background processing can observe duplicate events or retry work.

Test:

- same source event processed twice does not create duplicate canonical records
- retry after partial failure is deterministic
- concurrent parser/import/background work cannot corrupt balances/history
- background workers are idempotent where retries are possible

## 10. Privacy/security verification

Automated checks should eventually scan for:

- committed secrets
- unsafe logging patterns
- release debug flags
- exported Android components that should not be exported
- insecure network config where applicable
- backup/restore encryption regressions

Security-sensitive logic also requires focused unit/integration tests.

## 11. Static quality gates

Before integration, the intended Android CI will run relevant checks such as:

- Gradle build
- unit tests
- Android lint
- Kotlin/static analysis if adopted
- formatting check if adopted
- dependency/security checks where practical
- repository policy verification

Exact commands are frozen when the Android scaffold is introduced.

## 12. Test naming

Tests should describe behavior, not implementation.

Good:

`transfer_between_owned_accounts_does_not_increase_expense_total`

Bad:

`testMethod2`

The test name should make a failed invariant understandable without reading the implementation.

## 13. Red-green requirement

For bug fixes and new domain behavior:

1. create a failing test
2. run it and confirm the intended failure
3. implement minimal correct behavior
4. run focused test
5. run relevant suite
6. commit

Do not write tests after the implementation merely to document what the code already happens to do when a meaningful red test was possible.

## 14. Test data policy

Never commit real user SMS, bank details, personal notes, credentials, or production backups as fixtures.

Fixtures must be synthetic/anonymized while retaining the structural characteristics necessary to reproduce parsing behavior.

## 15. UI screenshot/golden tests

Use selectively for stable design-system components or screens where layout regressions are expensive.

Do not make the entire project depend on brittle pixel snapshots.

## 16. Performance verification

Do not prematurely micro-benchmark everything.

Add benchmarks for demonstrated/high-risk operations such as:

- large transaction import
- rebuilding search/review projections
- historical report queries
- parser batch processing
- database migration

Performance optimizations require measurement before and after.

## 17. Quality gates by change class

### Documentation only

- repository policy check
- link/path sanity where automated

### Domain logic

- focused unit tests
- relevant module suite
- build/static checks

### Database

- repository tests
- migration tests
- relevant integration suite

### Parser

- new/changed fixture test
- full parser regression suite

### Backup/security

- focused failure-path tests
- integration suite
- security review checklist

### UI

- ViewModel/domain tests
- UI tests for critical interaction
- screenshot/video evidence in PR when meaningful

## 18. CI principle

CI is a gate, not a substitute for local reasoning.

Agents must read the output of commands/checks they rely on. A green badge does not justify ignoring a failing local reproduction or untested migration path.

## 19. No completion by assertion

Phrases such as “should work”, “looks correct”, or “tests probably pass” are not verification.

A completion statement must be backed by fresh command/check output for the relevant scope.
