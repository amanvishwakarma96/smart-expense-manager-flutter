# EMI & Repayment Planner

PiggyAI's repayment planner is a deterministic, on-device planning layer attached to an existing private debt or loan ledger.

## What a plan stores

A plan contains only local planning metadata:

- parent debt-ledger ID;
- weekly or monthly cadence;
- planned installment amount;
- optional annual percentage rate (APR) used for estimates;
- first due date;
- outstanding balance and repaid-total baselines captured when the plan is saved;
- paused state and local timestamps.

It does not store a new merchant, account number, SMS body, lender credential, or remote identifier.

## Financial confirmation boundary

A repayment plan never changes financial records automatically.

Saving, editing, pausing, or deleting a plan does **not**:

- create an expense or EMI transaction;
- mark an installment as paid;
- add a repayment to the debt ledger;
- link a bank transaction;
- change the debt's outstanding balance.

After a real payment happens, the user still records a manual repayment or explicitly links a compatible confirmed bank transaction in the Debt & Loan Manager. The planner then recalculates from that confirmed ledger state.

## Schedule calculation

Weekly plans advance by exactly seven calendar days.

Monthly plans preserve the original due-day anchor and clamp only when a month is shorter. A plan beginning on 31 January therefore projects 28/29 February and returns to 31 March rather than drifting permanently to the 28th.

The planner compares actual repayment progress since the saved baseline with the installment amount expected by today's due dates. It can surface:

- **On track**;
- **Due today**;
- **Behind plan**, including the scheduled amount not yet covered by recorded repayments;
- **Settled**;
- **Payment too low** when an interest-bearing installment would not cover even one projected period of interest.

## Interest estimate

When APR is zero or omitted, the schedule is a straight balance/installment projection.

When APR is supplied, PiggyAI converts it into a simple periodic rate using 12 periods per year for monthly plans or 52 for weekly plans. Each projected payment is split into estimated interest first and remaining principal second. The result is planning guidance, not a lender statement or amortization guarantee; real lenders may use different compounding, fees, day-count rules, penalties, floating rates, taxes, or rounding.

## Replanning

Editing an existing plan intentionally creates a new planning baseline from the ledger's current outstanding balance and recorded repayment total. Historical transactions and ledger entries are not rewritten.

## Privacy and backup

All calculations run locally and deterministically. The feature has no HTTP client, remote AI model, analytics, telemetry, or network path.

Encrypted financial snapshot version 7 includes repayment-plan metadata inside the same password-encrypted backup envelope. Versions 1 through 6 remain restorable; because those snapshots predate repayment plans, restoring one clears current plan metadata instead of merging old financial state with a newer schedule.

Deleting a parent debt permanently or using Delete All also removes its repayment-plan metadata.
