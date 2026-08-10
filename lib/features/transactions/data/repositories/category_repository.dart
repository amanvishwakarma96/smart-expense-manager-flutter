import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/merchant_learning_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/merchant_rule_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/recurring_transaction_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/transaction_model.dart';

enum CategoryDeleteResult { deleted, notFound, lastCategory, inUse }

class CategoryRepository {
  CategoryRepository(this._isar);

  final Isar _isar;

  Stream<List<CategoryModel>> watchAll() {
    return _isar.categoryModels.where().watch(fireImmediately: true).map((
      List<CategoryModel> items,
    ) {
      items.sort((CategoryModel a, CategoryModel b) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
      return items;
    });
  }

  Future<List<CategoryModel>> getAll() async {
    final List<CategoryModel> items = await _isar.categoryModels
        .where()
        .findAll();
    items.sort((CategoryModel a, CategoryModel b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return items;
  }

  Future<void> seedDefaults() async {
    final List<CategoryModel> existing = await _isar.categoryModels
        .where()
        .findAll();
    final Set<String> existingNames = existing
        .map((CategoryModel item) => item.name.trim().toLowerCase())
        .toSet();

    final List<CategoryModel> defaults = <CategoryModel>[
      CategoryModel(
        name: 'Food',
        iconName: 'utensils',
        hexColor: 'FFB7A1',
        monthlyBudgetLimit: 6000,
      ),
      CategoryModel(
        name: 'Groceries',
        iconName: 'basket',
        hexColor: 'FFE4A3',
        monthlyBudgetLimit: 6000,
      ),
      CategoryModel(
        name: 'Transport',
        iconName: 'car',
        hexColor: '9FD8CB',
        monthlyBudgetLimit: 4000,
      ),
      CategoryModel(
        name: 'Shopping',
        iconName: 'shopping-bag',
        hexColor: 'CBB8FF',
        monthlyBudgetLimit: 5000,
      ),
      CategoryModel(
        name: 'Bills',
        iconName: 'receipt',
        hexColor: 'A8D8FF',
        monthlyBudgetLimit: 8000,
      ),
      CategoryModel(
        name: 'Health',
        iconName: 'heart-pulse',
        hexColor: 'FFCAD4',
        monthlyBudgetLimit: 3000,
      ),
      CategoryModel(name: 'Housing', iconName: 'home', hexColor: 'F8C8B8'),
      CategoryModel(
        name: 'Entertainment',
        iconName: 'movie',
        hexColor: 'E8C7FF',
        monthlyBudgetLimit: 3000,
      ),
      CategoryModel(name: 'Travel', iconName: 'flight', hexColor: 'B7DDF6'),
      CategoryModel(name: 'Education', iconName: 'school', hexColor: 'D6E8A8'),
      CategoryModel(
        name: 'Investments',
        iconName: 'trending-up',
        hexColor: 'B9E2D0',
      ),
      CategoryModel(
        name: 'Loans & EMI',
        iconName: 'account-balance',
        hexColor: 'FFD0B5',
      ),
      CategoryModel(
        name: 'Transfers',
        iconName: 'swap-horiz',
        hexColor: 'D7DCE5',
      ),
      CategoryModel(name: 'Income', iconName: 'payments', hexColor: 'BEE7C5'),
      CategoryModel(
        name: 'Other',
        iconName: 'circle',
        hexColor: 'D7DCE5',
        monthlyBudgetLimit: 3000,
      ),
    ];

    final List<CategoryModel> missing = defaults
        .where((CategoryModel item) {
          return !existingNames.contains(item.name.toLowerCase());
        })
        .toList(growable: false);
    if (missing.isEmpty) {
      return;
    }
    await _isar.writeTxn(() => _isar.categoryModels.putAll(missing));
  }

  Future<int> save({
    int? id,
    required String name,
    required String iconName,
    required String hexColor,
    required double monthlyBudgetLimit,
  }) async {
    final String normalizedName = name.trim();
    if (normalizedName.length < 2 || normalizedName.length > 28) {
      throw ArgumentError.value(
        normalizedName,
        'name',
        'Use between 2 and 28 characters',
      );
    }
    if (monthlyBudgetLimit < 0) {
      throw ArgumentError.value(
        monthlyBudgetLimit,
        'monthlyBudgetLimit',
        'Budget cannot be negative',
      );
    }

    final List<CategoryModel> categories = await getAll();
    final bool duplicate = categories.any((CategoryModel item) {
      return item.id != id &&
          item.name.toLowerCase() == normalizedName.toLowerCase();
    });
    if (duplicate) {
      throw ArgumentError.value(
        normalizedName,
        'name',
        'A category with this name already exists',
      );
    }

    final CategoryModel category = id == null
        ? CategoryModel()
        : await _isar.categoryModels.get(id) ?? CategoryModel(id: id);
    category
      ..name = normalizedName
      ..iconName = iconName.trim().isEmpty ? 'circle' : iconName.trim()
      ..hexColor = hexColor.replaceAll('#', '').toUpperCase()
      ..monthlyBudgetLimit = monthlyBudgetLimit;
    return _isar.writeTxn(() => _isar.categoryModels.put(category));
  }

  Future<void> updateBudget(int id, double monthlyLimit) async {
    final CategoryModel? category = await _isar.categoryModels.get(id);
    if (category == null) {
      return;
    }
    category.monthlyBudgetLimit = monthlyLimit;
    await _isar.writeTxn(() => _isar.categoryModels.put(category));
  }

  Future<CategoryDeleteResult> delete(int id) async {
    final CategoryModel? category = await _isar.categoryModels.get(id);
    if (category == null) {
      return CategoryDeleteResult.notFound;
    }
    if (await _isar.categoryModels.count() <= 1) {
      return CategoryDeleteResult.lastCategory;
    }

    final List<TransactionModel> transactions = await _isar.transactionModels
        .where()
        .findAll();
    final List<RecurringTransactionModel> recurring = await _isar
        .recurringTransactionModels
        .where()
        .findAll();
    final List<MerchantRuleModel> rules = await _isar.merchantRuleModels
        .where()
        .findAll();
    final List<MerchantLearningModel> learned = await _isar
        .merchantLearningModels
        .where()
        .findAll();
    final bool inUse =
        transactions.any((TransactionModel item) => item.categoryId == id) ||
        recurring.any(
          (RecurringTransactionModel item) => item.categoryId == id,
        ) ||
        rules.any((MerchantRuleModel item) => item.mappedCategoryId == id) ||
        learned.any(
          (MerchantLearningModel item) => item.mappedCategoryId == id,
        );
    if (inUse) {
      return CategoryDeleteResult.inUse;
    }

    await _isar.writeTxn(() => _isar.categoryModels.delete(id));
    return CategoryDeleteResult.deleted;
  }
}
