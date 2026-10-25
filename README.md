# Personal Life OS

A local-first, Android-first personal operating system for money, planning, activity history, reviews, and decision support.

## Product north star

The app should help a person answer five questions with minimal manual bookkeeping:

1. Where is my money?
2. Where did it go?
3. What do I need to do today?
4. What did I actually do?
5. What should I do next?

## Repository role

This repository is the **single source of truth** for product decisions, architecture, implementation plans, tests, project state, and agent operating rules.

Any AI agent or developer working on this project must read `AGENTS.md` and `PROJECT_STATE.md` before making changes.

## Core principles

- Local-first and offline-capable
- Financial correctness over convenience
- Automation-first, but never silently wrong
- Explainable calculations and recommendations
- Modular domain boundaries
- Persian-first UX, Jalali-aware UI, Iran financial workflows
- Git history is part of the product: small reversible commits, no untracked design decisions

## Current stage

**Phase 0 — Product and repository foundation.**

No production implementation should begin until the domain, architecture, data model, UX flows, security model, test strategy, and agent contract are documented and reviewed.
