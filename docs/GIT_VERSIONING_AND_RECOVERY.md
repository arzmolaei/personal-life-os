# Git Versioning and Recovery Strategy

## Goal

Git history is an operational recovery system, not merely a record of code changes.

The project must support:

- stopping one AI agent and resuming with another
- comparing parallel agent implementations
- reverting one bad change without losing unrelated work
- returning to a known milestone state
- understanding why a change exists months later
- proving which tests were associated with a change

## 1. Branch model

### `main`

`main` is always the latest integrated, reviewed, recoverable state.

Rules:

- no feature implementation directly on `main`
- no experimental commits on `main`
- only verified PRs should enter `main`
- a broken `main` is treated as a project incident

### Work branches

Use:

- `feature/<name>`
- `fix/<name>`
- `refactor/<name>`
- `docs/<name>`
- `chore/<name>`
- `agent/<agent-id>/<name>`

Each branch owns one coherent purpose.

## 2. Parallel AI strategy

When several AI systems work independently, do **not** point them all at the same writable branch.

Preferred options:

### Option A — separate branches in one repository

Create branches from the same known baseline:

- `agent/a/<task>`
- `agent/b/<task>`
- `agent/c/<task>`
- `agent/d/<task>`

Advantages:

- exact common ancestry
- easy GitHub compare
- no duplicated repository governance
- easy cherry-pick of individual commits
- cheaper maintenance

### Option B — separate repositories

Use when the user explicitly wants physically independent copies or an AI tool requires isolated repos.

Every copy must originate from the same baseline commit and keep the baseline SHA recorded in its `PROJECT_STATE.md`.

For normal experimentation, Option A is preferred.

## 3. Atomic commit rule

A commit should represent one logical reason to change.

Good:

- add ledger balance invariant
- add parser fixture for Mellat purchase
- fix duplicate transaction match window
- document backup encryption decision

Bad:

- “updates”
- “final”
- “fix everything”
- one commit containing architecture rewrite, UI restyle, parser changes, and documentation

## 4. Commit message convention

Format:

`<type>(<scope>): <imperative summary>`

Examples:

- `feat(tasks): preserve reschedule history`
- `fix(ledger): reject unbalanced journal entries`
- `test(backup): cover corrupted archive restore`
- `docs(adr): record parser rule signing policy`
- `ci(repo): enforce foundation files`

The subject should explain what changed. The body, when needed, explains **why** and any risk/migration notes.

## 5. Checkpoint policy

Agents must checkpoint verified work frequently.

Create a commit when:

- a red-green test cycle is complete
- a small spec/document is complete
- a migration and its tests are complete
- a UI flow is independently reviewable
- before changing task area
- before handoff or voluntary stop

Do not intentionally leave completed work only in the working tree.

### Forced interruption limitation

No Git policy can guarantee saving edits made milliseconds before a process is forcibly killed. The mitigation is frequent atomic commits plus durable project-state/checklist files.

## 6. Pull request policy

A PR is an integration gate, not a dump of accumulated changes.

Every PR must document:

- problem
- approach
- key architecture/product decisions
- tests and commands run
- data/migration impact
- privacy/security impact
- known risks
- excluded follow-up work

Merge only after checks pass and the diff is reviewed.

## 7. Merge strategy

Default recommendation:

**Squash only when the branch commits are noisy implementation scaffolding and no individual commit is useful for future rollback.**

Otherwise prefer preserving meaningful commits.

For this repository, clean atomic commit history has operational value, so preserve it where practical.

Never rewrite already shared history merely to achieve a prettier graph.

## 8. Milestone snapshots

At important integrated milestones, create a stable Git tag/release in GitHub, for example:

- `v0.1.0-foundation`
- `v0.2.0-ledger-core`
- `v0.3.0-transaction-capture`
- `v0.4.0-planning-core`
- `v1.0.0`

The release notes should contain:

- exact scope
- major decisions
- known limitations
- verification commands/results
- migration notes

If tooling cannot create a tag automatically, the project state must explicitly record the exact commit SHA until the tag is created through GitHub.

## 9. Snapshot branches

For high-risk work where a tag cannot yet be created, a temporary snapshot branch may be used:

`snapshot/<milestone>`

It must point at a verified commit and must not be used for ongoing development.

Tags/releases remain the preferred long-term milestone marker.

## 10. Rollback methods

### Revert one change

Preferred:

`git revert <commit>`

This keeps history and creates an auditable inverse change.

### Revert an integrated PR

Revert the PR/merge commit through GitHub or Git.

### Return to a historical version for inspection

Checkout the milestone tag or exact SHA in a separate branch/worktree.

Do not reset `main` backward merely to inspect old code.

### Emergency restoration

If `main` is broken and a clean revert cannot be produced quickly:

1. identify the last verified milestone SHA/tag
2. branch from it
3. diagnose from the broken branch separately
4. restore via explicit revert/fix PR

Avoid force-moving shared `main` unless the owner explicitly approves an emergency history rewrite.

## 11. Database/migration rollback

Git rollback does not automatically roll back user data.

Every irreversible database migration must define:

- migration test
- compatibility behavior
- backup expectation
- recovery path
- whether downgrade is supported

Never assume “we can revert the commit” is sufficient for a schema/data migration.

## 12. Release/version semantics

Use Semantic Versioning once executable releases exist.

Before `1.0.0`, minor versions may mark major product milestones while patch versions are safe corrections.

Examples:

- `0.2.0` new ledger milestone
- `0.2.1` ledger bugfix
- `0.3.0` new capture capability

Release versions must be derived from verified integrated state, never arbitrary local branches.

## 13. Agent handoff record

At every meaningful handoff record:

- repository
- branch
- HEAD SHA
- active plan
- completed plan tasks
- test commands + outcome
- uncommitted changes, if any
- exact next task
- blockers/risks

The preferred durable location is `PROJECT_STATE.md` or the active plan/issue, not chat alone.

## 14. Recovery checklist for a new agent

1. Read `AGENTS.md`.
2. Read `PROJECT_STATE.md`.
3. Inspect current branch and status.
4. Inspect recent commits.
5. Locate open plan/issue.
6. Compare plan completion markers with actual commits/tests.
7. Resume the first incomplete slice.
8. Never repeat completed work merely because context was lost.
