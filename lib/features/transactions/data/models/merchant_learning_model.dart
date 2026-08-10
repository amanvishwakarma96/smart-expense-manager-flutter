import 'package:isar_community/isar.dart';

part 'merchant_learning_model.g.dart';

@collection
class MerchantLearningModel {
  MerchantLearningModel({
    this.id = Isar.autoIncrement,
    this.encryptedMerchant = '',
    this.mappedCategoryId = 0,
    this.confidence = 1,
    required this.updatedAt,
  });

  Id id;
  String encryptedMerchant;
  int mappedCategoryId;
  int confidence;
  DateTime updatedAt;
}
