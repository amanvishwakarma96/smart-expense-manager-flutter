# Phase 16 — Payoff what-if simulator

PiggyAI's payoff simulator is a read-only extension of the local EMI & Repayment Planner. It lets a user compare the currently saved repayment plan with a hypothetical one-time prepayment, a higher recurring installment, or both.

## What the simulator does

- Starts from the existing debt ledger's current outstanding balance and recorded repayment total.
- Reuses the saved repayment plan's cadence, first due date, and optional APR.
- Applies an optional one-time extra amount only to the hypothetical outstanding balance.
- Applies an optional extra-per-installment amount only to the hypothetical future installment.
- Compares estimated payoff date, remaining installment count, and projected remaining interest with the saved plan.
- Shows estimated days saved, installments saved, and projected interest saved when both projections support those values.
- Can show when a hypothetical one-time amount would clear the tracked outstanding immediately.
- Can demonstrate when a higher hypothetical installment changes a `Payment too low` projection into a valid payoff estimate.

## Read-only boundary

The simulator never writes financial data. Values entered on the screen are transient widget state only and are discarded when the user leaves the screen.

It does not:

- create or confirm a transaction;
- create a debt-ledger entry;
- mark an EMI or repayment as paid;
- change the debt outstanding balance;
- edit, pause, resume, or replace the saved repayment plan;
- persist a what-if scenario to Isar, preferences, secure storage, or backup files.

A real repayment still requires the existing explicit manual-ledger or confirmed-transaction-link workflow.

## Projection model

`PayoffScenarioService` delegates the actual schedule math to `RepaymentScheduleService` so Phase 16 keeps the exact same deterministic assumptions as Phase 15:

- weekly schedules advance exactly seven days;
- monthly schedules preserve their original calendar-day anchor and clamp only for shorter months;
- optional APR uses the same local periodic estimate of 52 weekly or 12 monthly periods per year;
- a future installment that cannot cover one projected period of interest remains `Payment too low`;
- lender fees, penalties, prepayment charges, floating-rate changes, taxes, and lender-specific compounding rules are not modeled.

The one-time hypothetical amount is treated as reducing principal immediately for comparison purposes. This is guidance only and is not a representation of a lender statement or settlement quote.

## Privacy and offline guarantees

- All scenario math runs on-device.
- The screen respects PiggyAI's amount privacy mode, including masking scenario inputs and projections while privacy mode is enabled.
- The simulator adds no sensitive persisted text field and no database collection.
- No backend, cloud sync, HTTP client, remote AI, analytics, telemetry, advertising, or Android `INTERNET` permission is introduced.
- Because what-if values are not persisted, encrypted backup snapshot version 7 remains unchanged.

## Validation contract

Phase 16 tests cover:

- extra recurring payments shortening payoff;
- one-time prepayments reducing projected outstanding and interest;
- immediate hypothetical settlement;
- recovery from a payment-too-low baseline by increasing the hypothetical installment;
- a zero-extra scenario reproducing the saved-plan projection;
- rejection of negative hypothetical amounts;
- the absence of repository, Isar, transaction-write, and network dependencies from the scenario calculator;
- explicit UI copy confirming that the simulator never records a payment or changes the debt balance.
