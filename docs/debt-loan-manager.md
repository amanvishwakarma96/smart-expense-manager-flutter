# Debt & Loan Manager

PiggyAI keeps debt planning local and deliberately separate from transaction detection.

## Ledger types

- **Borrowed money** — money received from a person that the user owes back.
- **Money lent** — money the user gave someone and expects to receive back.
- **Loan** — a formal loan balance such as a bank or finance-company loan.

Counterparty names and private notes are encrypted before Isar persistence.

## Confirmation boundary

PiggyAI never creates a debt ledger from SMS, a merchant, or a transaction automatically.

A balance can change only when the user:

1. explicitly saves a manual ledger entry, or
2. selects a compatible **confirmed** transaction and confirms **Link**.

Linking adds a ledger movement and keeps the original transaction unchanged. A transaction can be linked to only one debt-ledger entry.

## Balance semantics

`outstanding = max(0, opening balance + increases - repayments)`

The opening balance may be ₹0 when the user wants to link the original principal transaction. This avoids counting the same principal twice.

Transaction-purpose compatibility is deterministic:

- Borrowed + Credit + `borrowed` → balance increase.
- Loan + Credit + `loanReceived` → balance increase.
- Borrowed/Loan + Debit + `loanRepayment` → repayment.
- Lent + Debit + `lent` → receivable increase.
- Lent + Credit + `lentRepayment` → repayment received.

Ordinary income, expense, transfer, refund, investment, and cash movements are not linked merely because their amounts match.

## Private reminders

Due reminders are optional and user-enabled. Supported lead times are 1, 3, and 7 days. Scheduling is local and inexact; the preferred time is approximately 9:00 AM in the device timezone.

Notification content is generic and never contains a counterparty, amount, account, balance, category, private note, or raw SMS.

## Backup and deletion

Encrypted snapshot version 6 includes debt accounts and ledger entries. Sensitive text is inside the password-encrypted backup envelope and is re-encrypted with the destination installation key after restore.

Versions 1 through 5 remain restorable. Because those versions predate debt ledgers, restoring one clears current debt data and obsolete debt reminders instead of merging old and new state.

Delete All clears debt accounts, ledger entries, and their reminders before the installation encryption key is removed.

## Release validation

Phase 14 must pass schema generation, `dart format lib test`, `flutter analyze --fatal-infos`, the full Flutter test suite, the Android debug APK build, and the existing 16 KB APK/native-library compatibility check before PR review. Release signing remains isolated to the protected `main` workflow after merge.
