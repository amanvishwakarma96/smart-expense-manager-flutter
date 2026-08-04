import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';

class CategoryRepository {
  CategoryRepository(this._isar);

  final Isar _isar;

  Stream<List<CategoryModel>> watchAll() {
    return _isar.categoryModels.where().watch(fireImmediately: true);
  }

  Future<List<CategoryModel>> getAll() {
    return _isar.categoryModels.where().findAll();
  }

  Future<void> seedDefaults() async {
    if (await _isar.categoryModels.count() > 0) {
      return;
    }

    final List<CategoryModel> defaults = <CategoryModel>[
      CategoryModel(
        name: 'Food',
        iconName: 'utensils',
        hexColor: 'FFB7A1',
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
      CategoryModel(
        name: 'Other',
        iconName: 'circle',
        hexColor: 'D7DCE5',
        monthlyBudgetLimit: 3000,
      ),
    ];

    await _isar.writeTxn(() => _isar.categoryModels.putAll(defaults));
  }

  Future<void> updateBudget(int id, double monthlyLimit) async {
    final CategoryModel? category = await _isar.categoryModels.get(id);
    if (category == null) {
      return;
    }
    category.monthlyBudgetLimit = monthlyLimit;
    await _isar.writeTxn(() => _isar.categoryModels.put(category));
  }
}
