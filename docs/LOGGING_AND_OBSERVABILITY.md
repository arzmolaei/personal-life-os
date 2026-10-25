# Logging and Observability Specification

## 1. Goal

Provide enough evidence to diagnose failures, recover background work, and measure reliability without turning logs or analytics into a second copy of the user's private life.

## 2. Logging principles

- structured over free-form where practical
- privacy-safe by default
- no raw financial/personal content in production logs
- stable event/error codes for diagnosis
- enough context to reproduce system behavior using synthetic fixtures
- diagnostics should identify software state, not expose user content

## 3. Severity model

### DEBUG

Development-only detail. Must still avoid secrets and highly sensitive payloads because debug logs can escape.

### INFO

Important lifecycle events that are normal:

- parser rule pack loaded
- backup job started/completed
- migration started/completed
- projection rebuild completed

### WARN

Abnormal but recoverable condition:

- unsupported source pattern
- balance mismatch detected
- background retry scheduled
- parser rule rollback used

### ERROR

Operation failed and requires diagnosis:

- backup cannot be written
- migration aborted
- canonical write failed
- rule package validation failed

Do not use exceptions as ordinary control flow merely to create log entries.

## 4. Structured fields

Prefer fields such as:

- eventCode
- operationId
- sourceType
- parserId
- parserVersion
- rulePackVersion
- appVersion
- databaseSchemaVersion
- durationMs
- retryCount
- errorCategory
- entityType
- pseudonymous local entity ID when truly needed

Avoid fields such as:

- raw SMS body
- transaction amount
- balance
- merchant/person name
- task title
- note body
- account/card number

## 5. Error taxonomy

Create stable error categories rather than relying only on exception text.

Example groups:

- `CAPTURE_*`
- `PARSER_*`
- `MATCHING_*`
- `LEDGER_*`
- `DB_*`
- `MIGRATION_*`
- `BACKUP_*`
- `RESTORE_*`
- `SECURITY_*`
- `PROJECTION_*`

A user-facing message and a diagnostic error code are different concerns.

## 6. Correlation IDs

Long multi-step operations should have an operation/correlation ID generated locally.

Examples:

- import
- backup
- restore
- migration
- parser batch
- projection rebuild

The correlation ID must not encode user data.

## 7. Background work state

Background jobs that may retry should persist enough non-sensitive state to explain:

- last attempt
- attempt count
- success/failure category
- next scheduled retry
- relevant version identifiers

Do not rely only on transient logcat output for recoverability.

## 8. In-app data health

The product may expose a user-facing Data Health screen showing safe summaries such as:

- last successful backup
- accounts needing reconciliation
- unmatched/unsupported source-event count
- parser rule version/status
- failed background job count
- database/projection health indicators

This is not the same as raw developer logs.

## 9. Crash reporting policy

If crash reporting is adopted:

- sanitize breadcrumbs
- disable automatic capture of sensitive text fields where possible
- review exception messages
- never attach database rows/raw source content automatically
- document provider and data flow in privacy docs

## 10. Analytics policy

Product analytics should favor aggregates/counters that answer product reliability questions without private content.

Useful examples:

- percentage of captured events auto-confirmed
- parser unsupported-format rate by parser version
- backup success rate
- feature flow completion count
- crash-free session rate

Sensitive dimensions such as merchant/person/task text are excluded.

## 11. Financial observability

A financial transaction can be audited through canonical metadata/history, not by dumping private values into logs.

For debugging classification, record things like:

- classifier version
- rule ID
- confidence bucket
- review reason code

rather than full input content.

## 12. Audit events vs logs

Audit history is durable product data; logs are diagnostic data.

Examples of audit-worthy events:

- reconciliation adjustment accepted
- transaction manually corrected
- task rescheduled
- backup restored
- classification rule created

Audit entries must be designed as product/domain records with retention semantics, not as accidental log lines.

## 13. Retention

Local diagnostic logs should be bounded by size/time.

Do not allow unbounded logs to consume device storage.

Uploaded diagnostics, if introduced, require explicit retention/privacy rules before implementation.

## 14. User-controlled diagnostic export

A future support flow may generate a diagnostic package containing:

- app/build version
- schema version
- device/OS compatibility metadata
- error codes/counts
- parser/rule versions
- recent operation outcomes

The package should exclude private content by default and clearly preview categories before sharing.

## 15. Observability verification

Tests/checks should eventually verify:

- sensitive models are not accidentally stringified into production logs
- release builds disable verbose developer logging
- background error states survive process restart where necessary
- log buffers remain bounded
- analytics events contain approved fields only

## 16. No console-debug architecture

Permanent behavior must not depend on manually reading logcat.

If a failure matters to user data integrity or recoverability, represent it through explicit state/error handling and tests, with logs as supporting evidence only.
