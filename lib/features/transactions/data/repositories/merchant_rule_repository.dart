import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/merchant_rule_model.dart';

class MerchantRuleRepository {
  MerchantRuleRepository(this._isar);

  final Isar _isar;

  Stream<List<MerchantRuleModel>> watchAll() {
    return _isar.merchantRuleModels.where().watch(fireImmediately: true).map(
      (List<MerchantRuleModel> items) {
        items.sort((MerchantRuleModel a, MerchantRuleModel b) {
          return a.merchantPattern.compareTo(b.merchantPattern);
        });
        return items;
      },
    );
  }

  Future<List<MerchantRuleModel>> getAll() async {
    final List<MerchantRuleModel> items = await _isar.merchantRuleModels
        .where()
        .findAll();
    items.sort((MerchantRuleModel a, MerchantRuleModel b) {
      final int length = b.merchantPattern.length.compareTo(
        a.merchantPattern.length,
      );
      return length != 0
          ? length
          : a.merchantPattern.compareTo(b.merchantPattern);
    });
    return items;
  }

  Future<int> saveRule({
    int? id,
    required String merchantPattern,
    required int categoryId,
  }) async {
    final String pattern = merchantPattern.trim().toLowerCase();
    if (pattern.length < 2 || pattern.length > 48) {
      throw ArgumentError.value(
        merchantPattern,
        'merchantPattern',
        'Use between 2 and 48 characters',
      );
    }
    final CategoryModel? category = await _isar.categoryModels.get(categoryId);
    if (category == null) {
      throw ArgumentError.value(
        categoryId,
        'categoryId',
        'Choose an existing category',
      );
    }

    final List<MerchantRuleModel> rules = await _isar.merchantRuleModels
        .where()
        .findAll();
    final bool duplicate = rules.any((MerchantRuleModel item) {
      return item.id != id && item.merchantPattern.toLowerCase() == pattern;
    });
    if (duplicate) {
      throw ArgumentError.value(
        merchantPattern,
        'merchantPattern',
        'A rule for this pattern already exists',
      );
    }

    final MerchantRuleModel rule = id == null
        ? MerchantRuleModel()
        : await _isar.merchantRuleModels.get(id) ?? MerchantRuleModel(id: id);
    rule
      ..merchantPattern = pattern
      ..mappedCategoryId = categoryId;
    return _isar.writeTxn(() => _isar.merchantRuleModels.put(rule));
  }

  Future<void> delete(int id) async {
    await _isar.writeTxn(() => _isar.merchantRuleModels.delete(id));
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
