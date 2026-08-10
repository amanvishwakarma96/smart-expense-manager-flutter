import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/core/security/secure_cipher_service.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/merchant_learning_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/merchant_rule_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/learned_merchant_mapping.dart';
import 'package:smart_expense_manager/features/transactions/services/merchant_confidence_resolver.dart';

class MerchantRuleRepository {
  MerchantRuleRepository(
    this._isar,
    this._cipher, {
    this._confidenceResolver = const MerchantConfidenceResolver(),
  });

  final Isar _isar;
  final SecureCipherService _cipher;
  final MerchantConfidenceResolver _confidenceResolver;

  static const Set<String> _genericMerchants = <String>{
    'bank transaction',
    'bank transfer',
    'card transaction',
    'upi transaction',
    'atm cash withdrawal',
  };

  Stream<List<MerchantRuleModel>> watchAll() {
    return _isar.merchantRuleModels.where().watch(fireImmediately: true).map((
      List<MerchantRuleModel> items,
    ) {
      items.sort((MerchantRuleModel a, MerchantRuleModel b) {
        return a.merchantPattern.compareTo(b.merchantPattern);
      });
      return items;
    });
  }

  Stream<List<LearnedMerchantMapping>> watchLearnedMappings() {
    return _isar.merchantLearningModels
        .where()
        .watch(fireImmediately: true)
        .asyncMap(_toLearnedMappings);
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

  Future<List<LearnedMerchantMapping>> getLearnedMappings() async {
    final List<MerchantLearningModel> items = await _isar
        .merchantLearningModels
        .where()
        .findAll();
    return _toLearnedMappings(items);
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

  Future<bool> learnCategory({
    required String merchant,
    required int categoryId,
  }) async {
    final CategoryModel? category = await _isar.categoryModels.get(categoryId);
    if (category == null) {
      return false;
    }
    final String? pattern = _learnablePattern(merchant);
    if (pattern == null) {
      return false;
    }

    final List<MerchantRuleModel> rules = await _isar.merchantRuleModels
        .where()
        .findAll();
    MerchantRuleModel? existing;
    for (final MerchantRuleModel rule in rules) {
      if (rule.merchantPattern.toLowerCase() == pattern) {
        existing = rule;
        break;
      }
    }
    if (existing != null && existing.mappedCategoryId == categoryId) {
      return false;
    }
    final MerchantRuleModel learned = existing ?? MerchantRuleModel();
    learned
      ..merchantPattern = pattern
      ..mappedCategoryId = categoryId;
    await _isar.writeTxn(() => _isar.merchantRuleModels.put(learned));
    return true;
  }

  Future<bool> recordConfirmedCategory({
    required String merchant,
    required int categoryId,
  }) async {
    final CategoryModel? category = await _isar.categoryModels.get(categoryId);
    final String? pattern = _learnablePattern(merchant);
    if (category == null || pattern == null) {
      return false;
    }

    final List<MerchantLearningModel> models = await _isar
        .merchantLearningModels
        .where()
        .findAll();
    for (final MerchantLearningModel model in models) {
      final String stored = await _cipher.decrypt(model.encryptedMerchant);
      if (stored == pattern && model.mappedCategoryId == categoryId) {
        model
          ..confidence = _confidenceResolver.increment(model.confidence)
          ..updatedAt = DateTime.now();
        await _isar.writeTxn(() => _isar.merchantLearningModels.put(model));
        return true;
      }
    }

    final MerchantLearningModel model = MerchantLearningModel(
      encryptedMerchant: await _cipher.encrypt(pattern),
      mappedCategoryId: categoryId,
      confidence: 1,
      updatedAt: DateTime.now(),
    );
    await _isar.writeTxn(() => _isar.merchantLearningModels.put(model));
    return true;
  }

  Future<void> editLearnedMapping({
    required int id,
    required int categoryId,
  }) async {
    final CategoryModel? category = await _isar.categoryModels.get(categoryId);
    if (category == null) {
      throw ArgumentError.value(
        categoryId,
        'categoryId',
        'Choose an existing category',
      );
    }
    final MerchantLearningModel? model = await _isar.merchantLearningModels.get(
      id,
    );
    if (model == null) {
      return;
    }
    model
      ..mappedCategoryId = categoryId
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.merchantLearningModels.put(model));
  }

  Future<void> deleteLearnedMapping(int id) async {
    await _isar.writeTxn(() => _isar.merchantLearningModels.delete(id));
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
    return _confidenceResolver.highestConfidenceCategory(
      merchant: merchant,
      mappings: await getLearnedMappings(),
    );
  }

  Future<List<LearnedMerchantMapping>> _toLearnedMappings(
    List<MerchantLearningModel> models,
  ) async {
    final List<LearnedMerchantMapping> result = <LearnedMerchantMapping>[];
    for (final MerchantLearningModel model in models) {
      result.add(
        LearnedMerchantMapping(
          id: model.id,
          merchant: await _cipher.decrypt(model.encryptedMerchant),
          categoryId: model.mappedCategoryId,
          confidence: model.confidence,
          updatedAt: model.updatedAt,
        ),
      );
    }
    result.sort((LearnedMerchantMapping a, LearnedMerchantMapping b) {
      final int merchant = a.merchant.compareTo(b.merchant);
      if (merchant != 0) {
        return merchant;
      }
      final int confidence = b.confidence.compareTo(a.confidence);
      return confidence != 0 ? confidence : a.id.compareTo(b.id);
    });
    return result;
  }

  String? _learnablePattern(String merchant) {
    String normalized = merchant
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\b\d{4,}\b'), ' ')
        .replaceAll(RegExp(r'[^a-z0-9@.& _-]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (normalized.length > 48) {
      normalized = normalized.substring(0, 48).trim();
    }
    if (normalized.length < 2 || _genericMerchants.contains(normalized)) {
      return null;
    }
    return normalized;
  }
}
