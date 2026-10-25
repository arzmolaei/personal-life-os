# Release and Milestone Checklist

Use this checklist before declaring an integrated milestone/release recoverable.

## 1. Scope

- [ ] Milestone scope is documented.
- [ ] Explicit non-goals/follow-up work are recorded.
- [ ] No unrelated work is included.

## 2. Repository state

- [ ] Work is integrated from a dedicated branch/PR.
- [ ] `main` contains no intentional WIP commit.
- [ ] `PROJECT_STATE.md` reflects actual integrated state.
- [ ] Relevant plans/issues are updated/closed appropriately.
- [ ] Exact integrated commit SHA is recorded.

## 3. Verification

- [ ] Required CI checks pass.
- [ ] Relevant unit tests pass.
- [ ] Relevant integration/migration tests pass.
- [ ] Build/static checks pass.
- [ ] Critical smoke/UI checks pass where applicable.
- [ ] Verification output was inspected, not assumed.

## 4. Data safety

- [ ] Database migration impact is understood.
- [ ] Backup/restore compatibility is understood.
- [ ] Any irreversible data transformation has a recovery strategy.
- [ ] No production/user data is embedded in fixtures/assets/logs.

## 5. Security/privacy

- [ ] No credentials or signing material are committed.
- [ ] New permissions/data flows were reviewed.
- [ ] Release logging/telemetry does not expose sensitive content.
- [ ] Dependency changes were reviewed.

## 6. Architecture

- [ ] No accepted ADR/spec was silently violated.
- [ ] Significant new decision has an ADR.
- [ ] Domain ownership remains explicit.

## 7. Recovery point

Preferred:

- [ ] Create a Git tag/release for the exact verified commit.

If tooling cannot create the tag immediately:

- [ ] Record the exact SHA in `PROJECT_STATE.md`.
- [ ] Optionally create `snapshot/<milestone>` pointing to that SHA.
- [ ] Create the permanent tag/release later without moving the milestone baseline.

## 8. Release notes

Include:

- summary
- important changes
- architecture/product decisions
- verification performed
- migration/data notes
- known limitations
- exact commit/tag

## 9. Rollback question

Before release, answer:

> If the next version is broken, can we restore code *and preserve/repair user data*?

If the answer is unknown, the milestone is not release-ready.
