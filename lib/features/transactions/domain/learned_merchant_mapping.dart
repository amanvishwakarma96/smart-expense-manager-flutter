class LearnedMerchantMapping {
  const LearnedMerchantMapping({
    required this.id,
    required this.merchant,
    required this.categoryId,
    required this.confidence,
    required this.updatedAt,
  });

  final int id;
  final String merchant;
  final int categoryId;
  final int confidence;
  final DateTime updatedAt;
}
