import 'package:smart_expense_manager/features/transactions/domain/learned_merchant_mapping.dart';

class MerchantConfidenceResolver {
  const MerchantConfidenceResolver();

  int increment(int current) => current < 1 ? 1 : current + 1;

  int? highestConfidenceCategory({
    required String merchant,
    required Iterable<LearnedMerchantMapping> mappings,
  }) {
    final String normalized = _normalize(merchant);
    if (normalized.isEmpty) {
      return null;
    }
    final List<LearnedMerchantMapping> matches = mappings
        .where((LearnedMerchantMapping item) {
          return _normalize(item.merchant) == normalized;
        })
        .toList(growable: false)
      ..sort((LearnedMerchantMapping a, LearnedMerchantMapping b) {
        final int confidence = b.confidence.compareTo(a.confidence);
        if (confidence != 0) {
          return confidence;
        }
        final int recent = b.updatedAt.compareTo(a.updatedAt);
        return recent != 0 ? recent : a.id.compareTo(b.id);
      });
    return matches.isEmpty ? null : matches.first.categoryId;
  }

  String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
