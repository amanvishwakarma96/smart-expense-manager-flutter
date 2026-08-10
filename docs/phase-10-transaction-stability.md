# Phase 10 — transaction intelligence and stability

PiggyAI treats two properties separately:

- **Direction:** Debit or Credit, matching the bank/SMS movement.
- **Purpose:** Expense, Income, Transfer, Borrowed, Lent, Loan received, Loan/EMI payment, Refund/reversal, Investment, Cash withdrawal, Cash deposit, or Other.

This separation prevents a loan, borrowed amount, refund, or transfer credit from being counted as salary/income and prevents transfers/investments from automatically being counted as normal spending.

## Automatic Android SMS flow

New transaction SMS messages are encrypted into the native local queue. If PiggyAI is open, the Android receiver signals Flutter immediately and the queue is parsed without requiring an app restart. If the app is closed, the encrypted queue is drained the next time PiggyAI starts.

SMS parsing remains local and transactions still enter **Pending review** before affecting budgets.

## Category automation

Category resolution is deterministic and local:

1. A user-learned merchant rule wins first.
2. Otherwise PiggyAI uses local merchant/SMS keywords and transaction purpose.
3. If no specific rule matches, the transaction falls back to Transfers/Other as appropriate.

When a user corrects a merchant category in Review or an editor, PiggyAI stores a local merchant rule so later matching transactions are categorized automatically.

## Analytics rules

- Income totals include only `Income` purpose.
- Spending totals include `Expense` and `Loan/EMI payment` purposes.
- Transfers, borrowed money, loan proceeds, refunds, investments, and cash movements are kept out of normal income/spending totals unless their purpose is manually changed.
- Budget alerts use only budget-counting spending purposes.
- Weekly spending challenges use the same semantic spending definition.

## Quick Challenge fix

Creating a new challenge no longer dereferences a null existing challenge. The default no-spend target is initialized safely to two days.

## Backup compatibility

Encrypted backup snapshot version 5 stores transaction purpose for both confirmed/pending transactions and recurring templates. Snapshot versions 1–4 remain restorable; legacy entries without purpose use their historical Debit→Expense and Credit→Income fallback.
