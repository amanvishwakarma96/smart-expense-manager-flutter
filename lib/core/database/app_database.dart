import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/merchant_rule_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/transaction_model.dart';

class AppDatabase {
  AppDatabase._();

  static Future<Isar> open() async {
    final directory = await getApplicationSupportDirectory();
    return Isar.open(
      <CollectionSchema<dynamic>>[
        TransactionModelSchema,
        CategoryModelSchema,
        MerchantRuleModelSchema,
      ],
      directory: directory.path,
      name: 'piggyai',
      inspector: false,
    );
  }
}
