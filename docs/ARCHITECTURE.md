# Architecture

PiggyAI follows a feature-first architecture and keeps all runtime data local.

```text
lib/
├── core/
│   ├── database/
│   ├── providers/
│   ├── security/
│   ├── theme/
│   └── utils/
└── features/
    ├── dashboard/
    ├── settings/
    ├── sms_engine/
    └── transactions/
```

## Data flow

1. Android receives a transaction-looking SMS.
2. Native Kotlin performs a coarse keyword and amount filter.
3. The message is encrypted with an Android Keystore AES-GCM key and queued in private `SharedPreferences`.
4. Flutter drains the queue through a method channel.
5. Dart performs detailed parsing, checks explicit merchant rules, then checks encrypted merchant→category confidence learned only from confirmed manual corrections before falling back to deterministic local category inference.
6. Before a new SMS-derived record is queued, local duplicate analysis compares account tail, amount, merchant similarity, and a five-minute timestamp window against pending and confirmed records.
7. Sensitive text fields are encrypted again with an installation-specific key stored through `flutter_secure_storage`; learned merchant text uses this same field-encryption service.
8. Isar stores the pending transaction locally, including an optional numeric `possibleDuplicateOf` reference when the detector finds a likely match.
9. The user confirms, edits, categorizes, or discards the transaction. A manually corrected category increases its encrypted merchant mapping confidence only after confirmation; duplicate warnings never remove or confirm a record automatically.
10. Dashboard analysis reads confirmed local history. Subscription detection groups the last 90 days of non-recurring confirmed debits by normalized merchant and amount, then checks consecutive seven- or thirty-day intervals with a ±3 day tolerance. Existing recurring templates are excluded.
11. Subscription suggestions are transient UI guidance. Dismissing a suggestion changes only dashboard state; accepting one opens the shared recurring editor with prefilled fields, and no recurring record is created until the user explicitly presses Save.
12. Riverpod streams refresh dashboard, settings, and budget views.

No step sends SMS or financial data over a network.
