import 'package:smart_expense_manager/features/dashboard/domain/subscription_suggestion.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';
import 'package:smart_expense_manager/features/transactions/domain/recurring_transaction.dart';

class SubscriptionDetectorService {
  const SubscriptionDetectorService();

  static const int lookbackDays = 90;
  static const int jitterDays = 3;
  static const int minimumOccurrences = 3;

  List<SubscriptionSuggestion> detect({
    required List<ExpenseTransaction> transactions,
    required List<RecurringTransaction> recurringTransactions,
    required DateTime now,
  }) {
    final DateTime cutoff = now.subtract(const Duration(days: lookbackDays));
    final Map<String, List<ExpenseTransaction>> groups =
        <String, List<ExpenseTransaction>>{};

    for (final ExpenseTransaction item in transactions) {
      if (item.status != TransactionStatus.confirmed ||
          !item.isDebit ||
          item.isRecurring ||
          item.timestamp.isBefore(cutoff) ||
          item.timestamp.isAfter(now)) {
        continue;
      }
      final String merchant = _normalizeMerchant(item.merchant);
      if (merchant.isEmpty) {
        continue;
      }
      final int amountPaise = (item.amount * 100).round();
      final List<ExpenseTransaction> bucket = groups.putIfAbsent(
        '$merchant|$amountPaise',
        () => <ExpenseTransaction>[],
      );
      bucket.add(item);
    }

    final List<SubscriptionSuggestion> result = <SubscriptionSuggestion>[];
    for (final List<ExpenseTransaction> group in groups.values) {
      if (group.length < minimumOccurrences) {
        continue;
      }
      group.sort((ExpenseTransaction a, ExpenseTransaction b) {
        return a.timestamp.compareTo(b.timestamp);
      });
      final RecurringFrequency? frequency = _detectFrequency(group);
      if (frequency == null) {
        continue;
      }
      final ExpenseTransaction latest = group.last;
      if (_alreadyRecurring(
        merchant: latest.merchant,
        amount: latest.amount,
        recurringTransactions: recurringTransactions,
      )) {
        continue;
      }
      result.add(
        SubscriptionSuggestion(
          id: _suggestionId(latest.merchant, latest.amount, frequency),
          merchant: latest.merchant,
          amount: latest.amount,
          frequency: frequency,
          nextExpectedAt: _nextExpectedAt(latest.timestamp, frequency, now),
          occurrences: group.length,
          categoryId: _latestCategory(group),
        ),
      );
    }

    result.sort((SubscriptionSuggestion a, SubscriptionSuggestion b) {
      final int occurrences = b.occurrences.compareTo(a.occurrences);
      return occurrences != 0
          ? occurrences
          : a.merchant.toLowerCase().compareTo(b.merchant.toLowerCase());
    });
    return result;
  }

  RecurringFrequency? _detectFrequency(List<ExpenseTransaction> items) {
    bool weekly = true;
    bool monthly = true;
    for (int index = 1; index < items.length; index += 1) {
      final double days =
          items[index].timestamp
              .difference(items[index - 1].timestamp)
              .inMinutes /
          Duration.minutesPerDay;
      if ((days - 7).abs() > jitterDays) {
        weekly = false;
      }
      if ((days - 30).abs() > jitterDays) {
        monthly = false;
      }
    }
    if (weekly) {
      return RecurringFrequency.weekly;
    }
    if (monthly) {
      return RecurringFrequency.monthly;
    }
    return null;
  }

  bool _alreadyRecurring({
    required String merchant,
    required double amount,
    required List<RecurringTransaction> recurringTransactions,
  }) {
    final String normalized = _normalizeMerchant(merchant);
    return recurringTransactions.any((RecurringTransaction item) {
      return _normalizeMerchant(item.merchant) == normalized &&
          (item.amount - amount).abs() <= 0.01;
    });
  }

  DateTime _nextExpectedAt(
    DateTime last,
    RecurringFrequency frequency,
    DateTime now,
  ) {
    final Duration cadence = frequency == RecurringFrequency.weekly
        ? const Duration(days: 7)
        : const Duration(days: 30);
    DateTime next = last.add(cadence);
    while (!next.isAfter(now)) {
      next = next.add(cadence);
    }
    return next;
  }

  int? _latestCategory(List<ExpenseTransaction> items) {
    for (final ExpenseTransaction item in items.reversed) {
      if (item.categoryId != null) {
        return item.categoryId;
      }
    }
    return null;
  }

  String _suggestionId(
    String merchant,
    double amount,
    RecurringFrequency frequency,
  ) {
    return '${_normalizeMerchant(merchant)}|${(amount * 100).round()}|${frequency.name}';
  }

  String _normalizeMerchant(String value) {
    return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }
}
