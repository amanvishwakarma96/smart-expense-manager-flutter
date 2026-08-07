# Weekly Money Quests

PiggyAI weekly money quests are a playful, fully local habit layer. They are intentionally separate from financial enforcement: a quest can encourage a choice, but it never blocks spending, changes a transaction, edits a budget, moves money, or updates a savings goal.

## Challenge types

- **Weekly spending cap:** choose an INR amount and watch confirmed debit spending against it from Monday through Sunday.
- **No-spend days:** choose between one and seven days. A day counts when no confirmed debit transaction exists for that local calendar day.

Only confirmed transactions are used. Pending SMS detections do not affect challenge progress until the user confirms them.

## Streaks and rewards

A completed week is finalized the next time PiggyAI prepares challenge data. Consecutive successful weeks build a streak. Missing or unsuccessful weeks simply stop the streak; they do not create penalties.

Local reward badges unlock at:

- First successful week
- Three consecutive successful weeks
- Five total successful weeks
- Ten total successful weeks

## Privacy

- Challenge calculations run entirely on the device.
- No network client, backend, analytics, telemetry, advertising, or remote AI is used.
- Spending-cap values follow the app-wide privacy masking toggle.
- Challenge history is stored only in the local Isar database.
- Challenge history is deliberately excluded from password-protected financial backup exports.
- Restoring a financial backup clears challenge history so old streak results are never applied to replaced financial data.
- Delete-all clears challenge history together with the other local application data.
