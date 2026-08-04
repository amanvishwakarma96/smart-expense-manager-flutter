import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/features/transactions/data/models/merchant_rule_model.dart';

class MerchantRuleRepository {
  MerchantRuleRepository(this._isar);

  final Isar _isar;

  Future<List<MerchantRuleModel>> getAll() {
    return _isar.merchantRuleModels.where().findAll();
  }

  Future<void> saveRule({
    required String merchantPattern,
    required int categoryId,
  }) async {
    final MerchantRuleModel rule = MerchantRuleModel(
      merchantPattern: merchantPattern.trim().toLowerCase(),
      mappedCategoryId: categoryId,
    );
    await _isar.writeTxn(() => _isar.merchantRuleModels.put(rule));
  }

  Future<int?> matchCategory(String merchant) async {
    final String normalized = merchant.trim().toLowerCase();
    final List<MerchantRuleModel> rules = await getAll();
    for (final MerchantRuleModel rule in rules) {
      if (normalized.contains(rule.merchantPattern)) {
        return rule.mappedCategoryId;
      }
    }
    return null;
  }
}
