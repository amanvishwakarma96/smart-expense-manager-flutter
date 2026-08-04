import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/merchant_rule_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/transaction_model.dart';

class AppDatabase {
  AppDatabase._();

  static Future<Isar> open() async {
    final directory = await getApplicationSupportDirectory();
    final List<CollectionSchema<dynamic>> schemas =
        <CollectionSchema<dynamic>>[
      TransactionModelSchema,
      CategoryModelSchema,
      MerchantRuleModelSchema,
    ];
    return Isar.open(
      schemas,
      directory: directory.path,
      name: 'piggyai',
      inspector: false,
    );
  }
}
