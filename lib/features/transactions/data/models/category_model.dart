import 'package:isar_community/isar.dart';

part 'category_model.g.dart';

@collection
class CategoryModel {
  CategoryModel({
    this.id = Isar.autoIncrement,
    this.name = '',
    this.iconName = 'circle',
    this.hexColor = '8A7CF5',
    this.monthlyBudgetLimit = 0,
  });

  Id id;

  @Index(unique: true, caseSensitive: false)
  String name;

  String iconName;
  String hexColor;
  double monthlyBudgetLimit;
}
