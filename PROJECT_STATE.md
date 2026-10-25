# PROJECT_STATE.md

This file is the persistent operational handoff for humans and AI agents.

## Repository

- Repository: `arzmolaei/personal-life-os`
- Default branch: `main`
- Current foundation branch: `bootstrap/foundation`
- Product stage: Phase 0 — product, architecture, repository, and agent-governance foundation

## Current objective

Create a durable repository foundation before production implementation begins. The repository must be safely resumable by any capable AI agent without relying on chat memory.

## Product direction

Personal Life OS is an Android-first, local-first personal operating system with five major product domains:

1. Finance
2. Planning
3. Activity
4. Review / History
5. Intelligence

The first implementation target is Android. The architecture direction is a local-first modular monolith with strict domain boundaries.

## Completed

- Repository initialized.
- Product north star recorded in `README.md`.
- Mandatory agent operating contract created in `AGENTS.md`.

## In progress

Repository foundation is being established:

- product specification
- architecture specification
- Git/versioning/recovery policy
- logging/observability policy
- security/privacy policy
- test strategy
- roadmap and milestone rules
- ADR system
- GitHub issue/PR templates
- repository verification/CI guard
- AI-client adapter instructions

## Not started

No Android production code has been scaffolded yet.

No database schema is frozen yet.

No finance parser implementation exists yet.

No UI implementation exists yet.

This is intentional: implementation must not outrun product/domain/architecture decisions.

## Current rulings

### R-001 — Repository is the source of truth

Chat history is not authoritative. Important decisions must be persisted in specs, ADRs, plans, project state, tests, and commits.

### R-002 — Recoverability over perfect history aesthetics

Do not rewrite shared history merely to make it visually cleaner. Prefer small semantic commits and `git revert` for rollback.

### R-003 — Agent work is isolated

Implementation agents work on dedicated branches. `main` is for integrated, verified state.

### R-004 — Frequent verified checkpoints

An agent should commit every coherent verified slice and create a checkpoint before handoff. This cannot mathematically protect the final seconds before a forced process kill, but it minimizes unrecoverable work and prevents intentional handoffs with completed uncommitted changes.

## Verification status

Repository foundation verification is not yet complete. Do not report Phase 0 complete until repository policy checks and document coverage checks are added and run.

## Known risks

- GitHub branch protection/rulesets are not yet configured.
- Repository is currently public; no secrets or user financial data may ever be committed.
- No CI workflow exists yet.
- No milestone tag/release baseline exists yet.
- Android/Gradle toolchain versions are not yet frozen.

## Next recommended task

Complete the governance/spec foundation on `bootstrap/foundation`, add deterministic repository verification, open a PR into `main`, verify the diff/checks, and merge only after evidence is reviewed.

## Resume instructions

A new agent should:

1. Read `AGENTS.md`.
2. Read this file.
3. Inspect `git log --oneline --decorate -20` or the equivalent GitHub commit history.
4. Inspect the active branch and open PRs.
5. Continue the first incomplete foundation task without redoing committed work.
