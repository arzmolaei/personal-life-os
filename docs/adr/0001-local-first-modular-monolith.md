# ADR-0001: Local-first modular monolith

- Status: Accepted
- Date: 2026-10-25

## Context

The product handles private financial and life-history data, must remain useful without reliable internet, and is initially an Android application. A mandatory backend or distributed architecture would increase privacy risk, cost, operational complexity, and failure modes before multi-device requirements are proven.

## Decision

Build the initial product as a **local-first modular monolith**:

- one Android deployable
- local canonical database
- strict internal domain boundaries
- optional network services at the edges
- no mandatory backend for core product value

## Alternatives considered

### Cloud-first client/server

Rejected for the initial product because it makes basic use dependent on connectivity/server availability and moves sensitive data into a larger trust boundary.

### Microservices

Rejected because there is no current distributed scaling problem that justifies operational complexity.

### Unstructured single-module application

Rejected because Finance, Planning, Activity, History, and Intelligence have different data ownership/invariants and need enforceable boundaries for multi-agent development.

## Consequences

Positive:

- core offline operation
- smaller privacy boundary
- simpler deployment/recovery
- faster local interactions
- easier early-stage development

Negative:

- future sync requires careful conflict design
- local migrations/backup become critical
- module boundaries must be maintained by discipline and tests

## Migration / recovery impact

No existing production data exists. Future cloud/sync work must adapt around local canonical state rather than replacing it casually.

## Revisit triggers

Revisit only if product requirements establish a necessary always-online collaborative workflow or server-side capability that cannot be delivered safely as an optional edge service.
