# PROJECT_STATE.md

This file is the persistent operational handoff for humans and AI agents.

## Repository

- Repository: `arzmolaei/personal-life-os`
- Default branch: `main`
- Current foundation branch: `bootstrap/foundation`
- Product stage: Phase 0 — product, architecture, repository, and agent-governance foundation
- Foundation branch checkpoint before this state update: `bb710854d383ba632ce0ed670d35709f8e362088`

## Current objective

Finish and integrate the durable repository foundation before Android production implementation begins. The repository must be safely resumable by any capable AI agent without relying on chat memory.

## Product direction

Personal Life OS is an Android-first, local-first personal operating system with five major product domains:

1. Finance
2. Planning
3. Activity
4. Review / History
5. Intelligence

Architecture direction: local-first modular monolith with strict canonical ownership and cross-domain integration through explicit interfaces/orchestration/projections/events.

## Completed on `bootstrap/foundation`

- Repository initialized with a clean first commit.
- Product north star in `README.md`.
- Mandatory AI/developer operating contract in `AGENTS.md`.
- Universal AI handoff prompt in `docs/AGENT_ENTRY_PROMPT.md`.
- Claude, Gemini, GitHub Copilot, and Cursor adapters route to the canonical contract.
- Product specification in `docs/PRODUCT.md`.
- Architecture specification in `docs/ARCHITECTURE.md`.
- Git/versioning/recovery policy in `docs/GIT_VERSIONING_AND_RECOVERY.md`.
- Multi-agent branch/compare/integration workflow in `docs/MULTI_AGENT_WORKFLOW.md`.
- Test/verification strategy in `docs/TEST_STRATEGY.md`.
- Security/privacy architecture in `docs/SECURITY_AND_PRIVACY.md`.
- Logging/observability policy in `docs/LOGGING_AND_OBSERVABILITY.md`.
- Product/engineering roadmap in `docs/ROADMAP.md`.
- Release/milestone recovery checklist.
- ADR process plus accepted ADR-0001 and ADR-0002.
- PR template, feature issue template, bug template, CODEOWNERS.
- Secret-safe Android-oriented `.gitignore`.
- Repository verification script `scripts/verify-repository.sh`.
- GitHub Actions `Repository Guard` workflow for `main`/PRs.

## Verification evidence so far

### GitHub repository tree

GitHub API inspection confirmed the expected foundation files are present on `bootstrap/foundation` and the branch tree is not truncated.

### Local clone attempt

A local verification attempt from the execution container could not resolve `github.com`, so the repository script was **not** claimed as locally passed. This is an environment/network limitation, not a successful verification result.

### Next verification gate

Open a PR into `main`, inspect the diff, integrate only after review, then read the actual GitHub Actions `Repository Guard` result on the integrated workflow. If it fails, treat the foundation as incomplete and fix/revert immediately.

## Not started intentionally

- Android/Gradle scaffold
- frozen Android/Kotlin/library versions
- production database schema
- finance parser implementation
- production UI
- backup implementation
- AI assistant

Implementation must not outrun domain/data/UX decisions.

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

### R-006 — No production implementation before foundation design work

The Android scaffold begins only after the foundation is integrated and Phase 0 design deliverables for data/domain/UX are planned.

## Known risks / remaining foundation work

- `main` branch protection/ruleset is not yet configured.
- The repository is public; secrets and real private user data must never be committed.
- Permanent Git milestone tag/release cannot currently be created through the connected GitHub tool; use an exact SHA and optional snapshot branch until a tag is created through GitHub.
- Android/Gradle toolchain versions are not frozen.
- Detailed `DATA_MODEL`, `UX_FLOWS`, `SCREEN_SPECS`, finance rules/formulas, and parser contract remain Phase 0 design work before feature implementation.

## Next recommended task

1. Open/review/integrate the repository-foundation PR.
2. Confirm `Repository Guard` on GitHub Actions.
3. Create a stable foundation snapshot branch at the verified integrated SHA.
4. Configure `main` protection/ruleset to require PR + repository guard before merge.
5. Continue Phase 0 with detailed domain/data/UX specifications and implementation plans.

## Resume instructions

A new agent must:

1. Read `AGENTS.md` completely.
2. Read this file.
3. Inspect current branch/status and recent commits.
4. Inspect open PRs/issues/plans.
5. Read relevant specs and ADRs.
6. Continue the first incomplete task; do not redo committed foundation work.
