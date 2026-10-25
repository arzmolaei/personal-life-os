# Multi-Agent Workflow

## Goal

Allow multiple AI systems or developers to work on the project independently without duplicating completed work, overwriting one another, or losing the ability to compare implementations.

## 1. One writable branch per agent/task

Never give multiple independent agents the same writable branch.

For experiments starting from the same baseline:

```text
agent/a/<task>
agent/b/<task>
agent/c/<task>
agent/d/<task>
```

All experiment branches must start from the exact same baseline SHA if their results will be compared.

Record the baseline SHA in the issue/plan and branch handoff.

## 2. Preferred task ownership

Parallelize only work that has clear boundaries.

Good parallel candidates:

- independent research/spec tasks
- separate parser adapters with a frozen interface
- independent UI prototype alternatives
- test fixture expansion after parser contracts are frozen
- review/security audit against an unchanged branch

Bad parallel candidates:

- several agents editing the same data model concurrently
- two agents both refactoring shared core architecture
- tasks whose interface is still undecided

When interfaces are not frozen, sequence the work instead.

## 3. Agent startup contract

Every agent must read:

1. `AGENTS.md`
2. `PROJECT_STATE.md`
3. relevant spec(s)
4. relevant ADR(s)
5. active plan/issue
6. recent commits affecting its area

Then it records/understands:

- baseline SHA
- branch
- exact owned task
- inputs/interfaces it consumes
- outputs/interfaces it may change
- verification required

## 4. No chat-only ownership

A task assigned to an agent must have durable repository context through one of:

- GitHub Issue
- implementation plan task
- explicit branch description/handoff in project state

Do not rely on “I told Claude/Codex yesterday” as project state.

## 5. Commit discipline for agents

Every agent commits each coherent verified slice.

Recommended sequence:

1. test/spec change that establishes expected behavior
2. implementation that makes it pass
3. small documentation/state update if required

Do not wait until hours of work have accumulated before the first commit.

## 6. Agent checkpoint before handoff

A voluntary handoff requires:

- relevant verification run
- coherent work committed
- active plan updated
- project state updated if milestone-level state changed
- branch + HEAD SHA reported
- exact next task reported
- any uncommitted work explicitly described

The next agent must inspect Git rather than blindly repeat the previous task.

## 7. Comparative implementation workflow

When the same problem is intentionally given to several AIs:

1. freeze the baseline SHA
2. create independent branches from that SHA
3. provide the same repository prompt/instructions
4. prohibit cross-reading another experiment branch unless comparison is the task
5. require each agent to run the same acceptance tests
6. compare branches against baseline
7. evaluate:
   - correctness
   - tests
   - data integrity
   - architecture compliance
   - security/privacy
   - maintainability
   - complexity
   - UX where relevant
8. choose one implementation or cherry-pick clearly compatible pieces

Never merge multiple competing implementations mechanically.

## 8. Cross-agent interface contracts

When Agent B depends on Agent A, freeze an interface in the plan/spec first.

The plan should define:

- type/function/schema names
- inputs
- outputs
- failure behavior
- tests proving the contract

Agent B may mock the frozen contract but should not silently redefine it.

## 9. Integration agent role

When parallel work converges, one agent/person acts as integrator.

Integrator responsibilities:

- read all branch diffs
- inspect tests, not only summaries
- resolve interface conflicts against specs/ADRs
- reject unnecessary duplicate implementations
- run the combined verification suite
- update project state

The integrator must not trust an agent's “done” statement without checking the actual Git diff and verification evidence.

## 10. Reviewer role

For high-risk changes, use an agent that did not author the implementation when practical.

Review focus priority:

1. correctness/invariants
2. data loss/corruption risk
3. security/privacy
4. recovery/migration
5. missing tests
6. architecture violations
7. maintainability
8. performance
9. style

## 11. Conflict resolution authority

Use this order:

1. accepted product spec
2. accepted ADR
3. domain spec
4. active implementation plan
5. existing tested behavior
6. agent judgment

If two documents at the same authority conflict in a user-visible or data-integrity way, escalate/document rather than silently choosing.

## 12. Duplicate-work prevention

Before starting a task, search:

- recent commits
- open/closed issues
- active plans
- relevant files/tests

If the feature already exists, verify it before adding a second implementation.

## 13. Experiment disposal

Rejected experimental branches should not be merged simply because work was spent on them.

Keep or delete branches according to repository housekeeping policy, but record the decision if the rejected experiment contains a useful architectural lesson.

Important lessons become ADR context or issue comments, not permanent dead production code.

## 14. Separate repository copies

If an AI tool requires a separate repository:

- create it from a known baseline commit
- retain all root governance files
- record `UPSTREAM_BASELINE_SHA` in its project state
- never assume changes automatically exist in the canonical repo
- integrate back through a reviewed patch/PR/cherry-pick strategy

Branches in the canonical repository remain preferred where tooling permits because ancestry/comparison is simpler.
