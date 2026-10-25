# Contributing

All contributors and AI agents must follow `AGENTS.md`.

## Standard workflow

1. Read `AGENTS.md` and `PROJECT_STATE.md`.
2. Identify an existing issue/plan or create a scoped one.
3. Branch from the intended verified baseline.
4. Implement the smallest independently testable slice.
5. Run focused verification, then the relevant wider suite.
6. Commit with semantic commit messages.
7. Update durable docs/state when behavior/architecture/project state changed.
8. Open a PR using the repository template.
9. Do not merge until required checks pass and the diff is reviewed.

## Branch names

- `feature/<name>`
- `fix/<name>`
- `refactor/<name>`
- `docs/<name>`
- `chore/<name>`
- `agent/<agent-id>/<name>`

## Commit format

`<type>(<scope>): <imperative summary>`

Examples:

- `feat(ledger): validate balanced journal entries`
- `fix(tasks): preserve original schedule when postponing`
- `test(parser): add Mellat refund fixtures`
- `docs(adr): define encrypted backup key ownership`

## Pull requests

Keep PRs coherent and reviewable. Split unrelated work.

A PR must explain:

- problem
- solution
- design decisions
- verification
- data/migration impact
- security/privacy impact
- risk and rollback
- intentionally excluded follow-up work

## Review order

Reviewers prioritize:

1. correctness
2. data-loss/corruption risk
3. security/privacy
4. recovery/migrations
5. tests
6. architecture boundaries
7. maintainability
8. UX
9. performance
10. style

## Main branch

Do not use `main` for feature development. `main` should remain an integrated recoverable state.

## Secrets and personal data

Never commit credentials, tokens, keystores, real banking messages, personal backups, private notes, or real financial records.
