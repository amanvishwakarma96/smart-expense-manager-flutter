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
5. Dart performs detailed parsing and applies local merchant rules.
6. Sensitive text fields are encrypted again with an installation-specific key stored through `flutter_secure_storage`.
7. Isar stores the pending transaction locally.
8. The user confirms, edits, categorizes, or discards the transaction.
9. Riverpod streams refresh dashboard and budget views.

No step sends SMS or financial data over a network.
