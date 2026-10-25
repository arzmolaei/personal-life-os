# GitHub Copilot Instructions

This repository has a canonical agent contract.

Before generating or modifying code:

- read and obey `/AGENTS.md`
- read `/PROJECT_STATE.md`
- read `/docs/PRODUCT.md` and `/docs/ARCHITECTURE.md`
- read relevant ADRs/specs/plans
- inspect existing tests and recent history

Do not silently redefine architecture, product behavior, data ownership, financial invariants, privacy posture, or commit/testing rules.

Prefer the smallest independently testable change and preserve existing verified behavior.

See `/docs/AGENT_ENTRY_PROMPT.md` for the universal handoff model.
