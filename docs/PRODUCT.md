# Product Specification — Personal Life OS

## 1. Product definition

Personal Life OS is a Persian-first, Android-first, local-first personal operating system that combines two major parts of everyday life without turning the user into an accountant or project manager:

- **money** — where it is, where it went, what is committed, what is safe to spend
- **time/work** — what should be done, what was actually done, what changed, and what happened on a given day/week/month

The system should collect as much information as safely possible, understand it, organize it, preserve history, and surface only the decisions or ambiguities that need human attention.

## 2. Primary user questions

The product must eventually answer these reliably:

1. Where is my money?
2. Where did my money go?
3. How much can I safely spend right now?
4. What do I need to do today?
5. What did I actually do today / on a specific past date?
6. What did I accomplish this week/month/year?
7. Which tasks, payments, goals, or commitments are becoming risky?
8. If I continue this pattern, what is likely to happen?
9. What should I do next?

## 3. Product philosophy

### Automation-first

The user should not manually duplicate information the system can infer with high confidence.

### Accuracy before automation

A wrong financial record is worse than a question in the review inbox.

### Progressive complexity

A normal user sees a simple interface. Advanced models and controls remain available without dominating daily use.

### Plan and reality are distinct

What the user intended to do and what actually happened must both be preserved.

### Local-first

Core use remains available without internet. Sensitive data belongs primarily on the device.

### Explainable intelligence

Important figures and recommendations must have a visible reason/breakdown.

### Neutral language

The product reports patterns without shaming or manipulative gamification.

## 4. Main product domains

### Finance

Responsible for:

- accounts
- transactions
- income/expenses
- transfers
- merchants/counterparties
- categories/tags
- cash flow
- reported vs book balance
- reconciliation
- loans/installments
- debts/receivables
- recurring payments
- commitments
- budgets/plans
- goals/reserves
- assets and valuation
- net worth
- safe-to-spend
- financial forecasts

### Planning

Responsible for future intent:

- tasks
- scheduling
- due dates
- priorities/focus
- projects
- areas
- goals
- milestones
- routines/habits
- daily and weekly planning
- reminders
- events/calendar integration

### Activity

Responsible for historical reality:

- task completion
- reschedule history
- actual activity logs
- routine occurrences
- optional focus sessions
- daily notes

### Review / History

Responsible for projections over canonical data:

- daily timeline
- daily review
- weekly review
- monthly review
- yearly review
- calendar history
- cross-domain history/search

### Intelligence

Responsible for derived decisions and explanations:

- parser confidence
- duplicate/matching confidence
- classification
- anomaly detection
- insights
- forecasts
- scenario simulation
- natural-language query/explanation in later phases

AI/LLMs are never the source of truth for money or historical facts.

## 5. Navigation direction

Target high-level navigation:

- Today
- Money
- Plan
- History
- More

`Today` is a cross-domain projection, not a data-owning domain.

## 6. Today experience

The Today screen should answer within seconds:

- what matters today?
- what is next?
- what payments/commitments are approaching?
- what is my safe-to-spend position?
- what needs review?

Possible content:

- three focus items
- scheduled tasks
- events
- routines
- upcoming financial commitments
- financial review inbox count
- safe-to-spend
- today’s expense snapshot

The screen must not become a dense BI dashboard.

## 7. End-of-day experience

The user should be able to see:

- planned work
- completed work
- unfinished work
- postponed work
- canceled work
- unplanned activities that happened
- notable financial activity
- a short optional note

Review should be quick and optional, not a mandatory ritual.

## 8. Historical experience

A date such as “2 Shahrivar” should remain meaningful months or years later.

The date view may show:

- what was planned that day
- what actually completed
- what moved to another date
- events
- routines
- manually logged activities
- financial transactions and totals
- short note

History must reflect what actually happened at the time; later edits must not erase planning history.

## 9. Weekly/monthly/yearly review

Reviews are derived, not manually reconstructed.

Useful metrics include:

- important work completed
- project/milestone progress
- tasks repeatedly postponed
- routine consistency
- financial income/expense/cash-flow
- savings and net-worth movement
- major changes and anomalies

Task count alone must never be equated with productivity.

## 10. Financial transaction capture

The architecture must allow several sources:

- SMS
- banking notifications
- manual entry
- CSV/Excel import
- recurring rules
- future supported APIs

Raw source events are distinct from canonical financial transactions so duplicate signals can map to one transaction.

The application must remain usable if SMS permission is unavailable.

## 11. Financial review inbox

Ambiguous financial events should enter a review inbox rather than silently changing financial truth.

Possible review reasons:

- uncertain category
- uncertain transfer match
- possible duplicate
- balance mismatch
- possible refund/reversal
- debt repayment match
- unsupported/changed bank message format

## 12. Money representation

Never use floating point for monetary values.

The internal canonical unit for Iranian currency will be selected in the detailed finance/data-model spec. UI may show toman while retaining exact canonical storage.

## 13. Safe-to-spend

Safe-to-spend is different from bank balance.

It should consider, as applicable:

- spendable liquid balance
- pending outflows
- confirmed commitments before the planning horizon
- remaining essential spending plan
- goal reservations
- safety buffer

The value must always have an explainable breakdown.

Future income should not silently inflate current safe-to-spend. Current position and forecasted position must remain distinguishable.

## 14. Tasks and scheduling

Task identity and scheduling history are distinct.

A task can be scheduled for one date, moved, and completed later without losing the original intent.

`scheduled date` and `due date` are different concepts.

Task completion is a historical event and should not simply overwrite task state.

## 15. Projects, areas, and goals

- **Area:** ongoing part of life with no natural completion, such as work or study.
- **Project:** finite outcome containing tasks/milestones.
- **Goal:** higher-level desired outcome that may involve projects, habits, or financial reserves.
- **Milestone:** meaningful checkpoint toward a project/goal.

The hierarchy must remain useful without forcing every task into every layer.

## 16. Routines/habits

Recurring behavior must preserve occurrence history rather than rewriting a single row.

Streaks may exist as secondary information but must not drive manipulative UX.

## 17. Cross-domain linking

Finance and planning/activity remain separate domains but can be linked.

Examples:

- “pay rent” task ↔ financial commitment ↔ matched payment transaction
- savings goal ↔ reserved account/asset
- purchase task ↔ resulting transaction

A link does not transfer source-of-truth ownership between domains.

## 18. Search

Global search should eventually find across:

- tasks
- projects
- activities
- dates
- transactions
- merchants
- counterparties
- notes
- categories/tags

Natural-language search is a later intelligence layer over structured queries.

## 19. Security/privacy product promises

- core data is usable offline
- no secret or raw private financial content in telemetry by default
- database/backups are protected
- biometric/PIN lock is supported in later implementation
- recent-app privacy and sensitive-screen options are considered
- cloud capabilities are opt-in and must not become mandatory for basic use

## 20. Explicit non-goals for personal core

Do not turn the product into business accounting software.

Not part of the personal core:

- inventory
- sales invoicing
- payroll
- tax/accounting compliance
- CRM
- store management
- corporate accounting UI

A future business workspace would be a separate product concern.

## 21. North-star success metric

For financial workflows, a primary metric is **manual intervention rate**: how often the user must correct or manually enter data that the system could safely automate.

For planning/history, success is not raw task count. The product should make it easy to know what matters now and accurately remember what happened later.

## 22. Version 1 quality bar

Version 1 should not be declared complete until a user can:

- run the app primarily offline
- establish accounts and reliable balances
- capture/import transactions
- distinguish transfer/refund/loan/debt semantics correctly
- review ambiguous financial events
- maintain useful categories and search
- manage tasks/projects/routines without losing schedule history
- see Today and historical day views
- see core financial reports and safe-to-spend
- back up and restore safely
- trust that calculations, migration, and rollback paths are tested
