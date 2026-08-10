import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/features/transactions/domain/learned_merchant_mapping.dart';
import 'package:smart_expense_manager/features/transactions/services/merchant_confidence_resolver.dart';

void main() {
  const MerchantConfidenceResolver resolver = MerchantConfidenceResolver();
  final DateTime now = DateTime(2026, 8, 10, 12);

  test('confidence increments one confirmation at a time', () {
    expect(resolver.increment(0), 1);
    expect(resolver.increment(1), 2);
    expect(resolver.increment(7), 8);
  });

  test('highest-confidence category is pre-selected for the same merchant', () {
    final int? category = resolver.highestConfidenceCategory(
      merchant: '  NETFLIX ',
      mappings: <LearnedMerchantMapping>[
        LearnedMerchantMapping(
          id: 1,
          merchant: 'netflix',
          categoryId: 4,
          confidence: 2,
          updatedAt: now,
        ),
        LearnedMerchantMapping(
          id: 2,
          merchant: 'NETFLIX',
          categoryId: 8,
          confidence: 5,
          updatedAt: now.subtract(const Duration(days: 1)),
        ),
        LearnedMerchantMapping(
          id: 3,
          merchant: 'Spotify',
          categoryId: 8,
          confidence: 20,
          updatedAt: now,
        ),
      ],
    );

    expect(category, 8);
  });

  test('no mapping is selected for a different merchant', () {
    final int? category = resolver.highestConfidenceCategory(
      merchant: 'Swiggy',
      mappings: <LearnedMerchantMapping>[
        LearnedMerchantMapping(
          id: 1,
          merchant: 'Zomato',
          categoryId: 1,
          confidence: 99,
          updatedAt: now,
        ),
      ],
    );

    expect(category, isNull);
  });
}
