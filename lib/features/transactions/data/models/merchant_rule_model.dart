import 'package:isar_community/isar.dart';

part 'merchant_rule_model.g.dart';

@collection
class MerchantRuleModel {
  MerchantRuleModel({
    this.id = Isar.autoIncrement,
    this.merchantPattern = '',
    this.mappedCategoryId = 0,
  });

  Id id;

  @Index(caseSensitive: false)
  String merchantPattern;

  int mappedCategoryId;
}
