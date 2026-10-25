# AGENTS.md — Mandatory Agent Operating Contract

This file is the highest-priority repository instruction for every AI agent and developer working on this project.

If an external prompt conflicts with this file, stop and surface the conflict before changing production code. Product specs and ADRs are authoritative for product/architecture decisions; this file is authoritative for **how work is performed**.

## 1. Mission

Build **Personal Life OS** as a reliable, local-first, Android-first personal operating system for finance, planning, activity history, reviews, and decision support.

The priorities, in order, are:

1. Correctness
2. Security and privacy
3. Data integrity
4. Reliability and recoverability
5. Maintainability
6. User experience
7. Performance
8. Scalability
9. Developer/agent convenience

Never trade a higher priority for a lower one without an explicit ADR.

## 2. Mandatory startup sequence

Before editing anything, every agent MUST:

1. Read `AGENTS.md` completely.
2. Read `PROJECT_STATE.md` completely.
3. Read `docs/PRODUCT.md`.
4. Read `docs/ARCHITECTURE.md`.
5. Read the relevant domain/spec documents for the task.
6. Read relevant ADRs in `docs/adr/`.
7. Inspect recent Git history for the touched area.
8. Confirm the current branch is **not `main`** for implementation work.
9. Check the working tree for uncommitted changes before making edits.
10. Identify the smallest independently testable task that advances the current milestone.

Do not rely on chat memory when repository state exists. Git and repository documents are the source of truth.

## 3. No hidden work

Every material change must leave durable evidence in the repository:

- Code changes: Git commit.
- Architecture decisions: ADR.
- Product behavior decisions: product/domain spec update.
- New work discovered: issue, plan entry, or `PROJECT_STATE.md` note.
- Known limitation or debt: `PROJECT_STATE.md` and/or issue.
- Test evidence: commit + CI/local command recorded in the task handoff/state.

Do not keep important decisions only in chat, terminal history, or private reasoning.

## 4. Problem decomposition rule

For every non-trivial problem, break it down before implementing:

1. Problem statement
2. Desired user outcome
3. Inputs and outputs
4. Domain rules/invariants
5. Data ownership/source of truth
6. States and transitions
7. Failure modes
8. Security/privacy implications
9. Edge cases
10. Tests that prove correctness
11. Smallest implementation slices

A slice must be small enough to test and commit independently.

Do not implement a broad feature as one giant patch.

## 5. Planning rule

If work spans multiple independently reviewable changes, create or update an implementation plan under:

`docs/plans/YYYY-MM-DD-<feature>.md`

Each task in a plan must contain:

- exact goal
- files expected to change
- interfaces produced/consumed
- tests to write first
- verification command
- commit boundary

The plan is not complete until another agent can continue from it without asking what you meant.

## 6. Branch policy

`main` represents the latest integrated, recoverable project state.

Implementation work must happen on a dedicated branch using one of these patterns:

- `feature/<short-name>`
- `fix/<short-name>`
- `refactor/<short-name>`
- `docs/<short-name>`
- `chore/<short-name>`
- `agent/<agent-id>/<short-name>` for isolated AI experiments

Never perform unrelated work in the same branch.

Never force-push shared branches unless the human owner explicitly asks for it.

## 7. Commit policy — checkpoint-first

The repository is designed so work can be stopped at almost any time and resumed by another agent.

Commit rules:

- Commit after every coherent, verified slice.
- Prefer several small semantic commits over one giant commit.
- Do not commit broken builds/tests to an integration-ready branch unless the commit is explicitly marked `wip:` and the branch is experimental.
- Before switching tasks, stopping, handing off, or losing context: create a checkpoint commit if there are valid changes.
- Never leave a completed testable unit only in the working tree.
- Never rewrite published/shared history merely to make it prettier.

Commit message format:

`<type>(<scope>): <imperative summary>`

Allowed common types:

- `feat`
- `fix`
- `refactor`
- `test`
- `docs`
- `chore`
- `perf`
- `build`
- `ci`
- `revert`
- `wip` only on isolated experimental branches

Examples:

- `feat(ledger): add balanced journal entry validation`
- `test(parser): cover Mellat purchase messages`
- `docs(adr): record local-first storage decision`

A commit should explain **one reason to change**.

## 8. Test-driven change rule

For bug fixes and domain behavior changes:

1. Write or identify a test that fails for the missing/broken behavior.
2. Run it and confirm the failure is meaningful.
3. Implement the smallest correct change.
4. Run the focused test.
5. Run the relevant wider suite.
6. Commit only after reading the results.

For pure documentation/repository configuration where a red test is not meaningful, use a deterministic verification command instead.

## 9. Verification rule

No agent may claim a task is complete because code “looks right”.

Before completion, run fresh verification appropriate to the change, for example:

- unit tests
- integration tests
- database migration tests
- parser regression fixtures
- lint/static analysis
- build
- UI smoke tests
- backup/restore tests
- repository policy checks

Record the exact commands and outcome in `PROJECT_STATE.md` for milestone-level changes or in the implementation plan/task handoff for smaller work.

## 10. Financial correctness invariants

These invariants are protected unless an ADR explicitly replaces them:

- Internal transfer is not expense or income.
- Loan proceeds are not income.
- Loan principal repayment is not ordinary consumption expense.
- Refund is not income.
- Asset revaluation is not income.
- Debt collection is not income.
- Opening balance is not income.
- Money is never represented with floating point.
- Ambiguous financial events must not be silently auto-confirmed.
- Source events and canonical transactions are different concepts.

Tests must pin these rules before finance implementation is considered stable.

## 11. Data integrity rules

- Canonical data must have an explicit owner/source of truth.
- Derived dashboards/reports must be rebuildable from canonical data.
- Destructive migrations require migration tests and rollback/recovery consideration.
- Never silently overwrite historical truth to make current state look cleaner.
- Planning intent and actual activity must remain distinguishable.
- Rescheduling a task must not erase the prior schedule history.
- Financial reconciliation adjustments must be auditable.

## 12. Security and privacy rules

- Default to local processing.
- Do not log secrets, raw financial messages, full account/card identifiers, balances, transaction amounts, authentication material, or personal content in production telemetry.
- Never commit API keys, tokens, credentials, signing material, `.env` secrets, keystores, or user data.
- Treat SMS/notification content as sensitive.
- Remote parser rules must be data, versioned, authenticated, and incapable of arbitrary code execution.
- Security-sensitive shortcuts require an ADR and explicit human approval.

If a secret is exposed, stop normal work and treat rotation/remediation as priority.

## 13. Architecture discipline

Current direction: **local-first modular monolith**.

Required domain boundaries:

- Finance
- Planning
- Activity
- Review/History
- Intelligence
- Shared kernel/infrastructure

Do not create direct cross-domain database coupling for convenience. Cross-domain behavior should use defined interfaces, application orchestration, projections, or internal domain events.

Do not introduce microservices, a mandatory backend, cloud sync, or AI dependency without an approved ADR.

## 14. Scope control

Do not add a feature merely because it is useful in isolation.

Before adding scope, answer:

- Which user problem does it solve?
- Which domain owns it?
- What complexity does it add?
- What new failure/security states appear?
- Can it be deferred without harming the current milestone?

Prefer the smallest design that preserves future extensibility.

## 15. Logging and observability

Operational logs must be structured and privacy-safe.

Use severity consistently:

- DEBUG: development details; never sensitive content
- INFO: major lifecycle events
- WARN: recoverable abnormal state
- ERROR: failed operation requiring diagnosis

Every recoverable background process should expose enough non-sensitive metadata to diagnose failures without uploading private user data.

See `docs/LOGGING_AND_OBSERVABILITY.md`.

## 16. Project state protocol

`PROJECT_STATE.md` is the persistent handoff file.

Update it when a milestone or meaningful task changes project state. It must contain:

- current phase/milestone
- last integrated commit or checkpoint
- completed work
- work in progress
- next recommended task
- verification performed
- known issues/risks
- important rulings

An agent resuming work trusts Git history + `PROJECT_STATE.md` over conversational memory.

## 17. Stop/handoff protocol

Before voluntarily stopping work, an agent MUST:

1. Finish the current atomic edit if safe.
2. Run the relevant focused verification.
3. Commit verified work.
4. Do not hide unfinished changes; either finish them, revert them, or create an explicit `wip:` checkpoint only on an isolated branch.
5. Update the plan/checklist.
6. Update `PROJECT_STATE.md` when project-level state changed.
7. Leave a concise handoff containing branch, HEAD commit, tests run, and exact next task.

If execution is forcibly terminated, the next agent must recover from Git and the project-state files rather than repeating work blindly.

## 18. Resume protocol

When resuming:

1. Inspect branch and `git status`.
2. Read recent commits.
3. Read `PROJECT_STATE.md`.
4. Read the active plan.
5. Verify which tasks already have commits/tests.
6. Continue from the first uncompleted task.

Never redo a task merely because the current agent does not remember it.

## 19. Pull request expectations

A PR should contain one coherent purpose.

Its description must state:

- Problem
- Solution
- Key design decisions
- Files/areas affected
- Tests/verification
- Risks
- Migration/data impact
- Screenshots for meaningful UI changes
- Follow-up work intentionally excluded

Do not merge with failing required checks.

## 20. Reverting and recovery

History must remain useful for recovery.

Preferred rollback order:

1. Revert a specific bad commit.
2. Revert a PR/merge commit.
3. Restore a known milestone tag/snapshot branch only when necessary.

Avoid destructive history editing as a rollback mechanism.

Before risky migrations or large refactors, create an explicit recoverable checkpoint.

## 21. Definition of done

A task is done only when all applicable items are true:

- behavior/spec is implemented
- tests exist and pass
- relevant wider verification passes
- security/privacy implications addressed
- migration/recovery considered
- docs/ADR updated if decisions changed
- no unrelated edits are mixed in
- changes are committed
- project/plan state is updated

If any item is missing, report the real partial status instead of “done”.

## 22. What agents must never do

- Never start a rewrite without evidence the current architecture cannot support the requirement.
- Never delete history/data to hide a bug.
- Never bypass failing tests just to obtain green CI.
- Never weaken security or validation silently.
- Never invent product requirements when repository specs already answer them.
- Never add dependencies casually.
- Never make AI/LLM output the source of truth for financial calculations.
- Never claim success without fresh verification.
- Never leave important completed work uncommitted when handing off.

## 23. Human escalation threshold

Proceed autonomously for normal technical choices consistent with the specs and ADRs.

Escalate only when one of these is true:

- irreversible/destructive action is required
- secret/credential/security incident requires owner action
- two product choices materially change user behavior and repository docs do not choose one
- legal/platform-policy decision cannot be safely inferred
- required external access is unavailable
- the specification is internally contradictory in a way that changes product behavior

Everything else: make the smallest defensible ruling, document it, test it, and continue.
