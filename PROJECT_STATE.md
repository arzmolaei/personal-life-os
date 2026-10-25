# PROJECT_STATE.md

This file is the persistent operational handoff for humans and AI agents.

## Repository

- Repository: `arzmolaei/personal-life-os`
- Default branch: `main`
- Product stage: Phase 0 — detailed domain/data/UX design before Android implementation
- Verified foundation merge SHA: `37853807f22b248543e50671d5114602ad2ca676`
- Stable foundation snapshot branch: `snapshot/v0.1.0-foundation`
- Parallel AI baseline branches:
  - `agent/a/baseline`
  - `agent/b/baseline`
  - `agent/c/baseline`
  - `agent/d/baseline`

All four agent baseline branches and the snapshot branch were created from the exact verified foundation SHA above.

## Current objective

Continue Phase 0 design work from a stable repository foundation. Do not begin broad production feature implementation until detailed canonical data/domain contracts and UX flows are written and reviewed.

## Product direction

Personal Life OS is an Android-first, local-first personal operating system with five major product domains:

1. Finance
2. Planning
3. Activity
4. Review / History
5. Intelligence

Architecture direction: local-first modular monolith with strict canonical ownership and cross-domain integration through explicit interfaces/orchestration/projections/events.

## Integrated foundation

The repository foundation was merged through PR #1 with granular commit history preserved.

Integrated foundation includes:

- product north star and product specification
- mandatory `AGENTS.md` operating contract
- universal AI entry prompt
- Claude, Gemini, GitHub Copilot, and Cursor instruction adapters
- persistent project-state protocol
- architecture specification
- Git/versioning/recovery strategy
- multi-agent workflow
- test/verification strategy
- security/privacy architecture
- logging/observability strategy
- roadmap and release/milestone checklist
- ADR process + ADR-0001 + ADR-0002
- PR/feature/bug templates and CODEOWNERS
- Android/secret-safe `.gitignore`
- repository verification script
- GitHub Actions Repository Guard

## Verification evidence

### GitHub diff/tree review

Before integration, GitHub comparison showed the foundation branch was 28 commits ahead of the initial `main`, 0 behind, with foundation additions only and no deletions. Recursive GitHub tree inspection confirmed expected files were present.

### Repository Guard

GitHub Actions workflow `Repository Guard` ran on the integrated foundation merge SHA:

- Run ID: `40173911784`
- Event: `push`
- Branch: `main`
- Head SHA: `37853807f22b248543e50671d5114602ad2ca676`
- Status: `completed`
- Conclusion: `success`

This is the authoritative foundation verification result.

### Local container limitation

A separate local clone attempt from the assistant execution container failed DNS resolution for `github.com` before clone. It was correctly treated as no local verification, not as a pass. The GitHub Actions result above provides the executed repository-guard evidence.

## Current rulings

### R-001 — Repository is the source of truth

Chat history is not authoritative. Important decisions live in specs, ADRs, plans, state, tests, and commits.

### R-002 — Recoverability over history aesthetics

Prefer semantic commits and explicit revert over destructive shared-history rewriting.

### R-003 — Agent work is isolated

Implementation agents work on dedicated branches. `main` is integrated recoverable state.

### R-004 — Frequent verified checkpoints

Commit each coherent verified slice and checkpoint before voluntary handoff. Forced termination can still lose the final uncommitted seconds; Git + state files minimize this risk and prevent intentional handoffs with completed uncommitted work.

### R-005 — Parallel AI work uses a common baseline

Competing agents should normally use independent `agent/<id>/<task>` branches created from the same baseline SHA. Separate repositories are reserved for tools/workflows that truly require physical repo isolation.

### R-006 — No broad production implementation before detailed design contracts

The Android scaffold/toolchain can be planned next, but feature implementation must not outrun the canonical data model, critical financial rules, task/history semantics, UX flows, and parser contracts.

## Known risks / administrative follow-up

- `main` branch protection/ruleset is not yet configured; repository tooling currently exposes read-only branch-protection access, so this remains a GitHub administration action.
- Repository is public; secrets and real user financial/personal data must never be committed.
- Permanent Git milestone tag/release is not currently exposed by the connected GitHub mutation tools. `snapshot/v0.1.0-foundation` + exact SHA is the recovery marker until a permanent tag is created through GitHub.
- Android/Gradle/Kotlin versions are not frozen.

## Remaining Phase 0 design work

Before major implementation, create and review at minimum:

- `docs/DATA_MODEL.md`
- `docs/FINANCE_DOMAIN.md`
- `docs/LIFE_DOMAIN.md`
- `docs/FINANCIAL_RULES.md`
- `docs/SAFE_TO_SPEND.md`
- `docs/PARSER_ENGINE.md`
- `docs/UX_FLOWS.md`
- `docs/SCREEN_SPECS.md`
- initial implementation plans under `docs/plans/`
- toolchain/module ADR for Android scaffold

## Next recommended task

Start the detailed domain design by decomposing canonical entities, ownership, invariants, state transitions, and cross-domain links before freezing the database schema.

Recommended order:

1. Finance domain + financial invariants
2. Planning/activity domain + history semantics
3. Shared canonical data model
4. Safe-to-spend and forecast formulas
5. parser/matching contract
6. UX flows and screen specifications
7. Android/toolchain scaffold plan

## Resume instructions

A new agent must:

1. Read `AGENTS.md` completely.
2. Read this file.
3. Inspect current branch/status and recent commits.
4. Inspect open PRs/issues/plans.
5. Read relevant specs and ADRs.
6. Continue the first incomplete task; do not redo integrated foundation work.
