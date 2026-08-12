import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_expense_manager/features/challenges/data/models/weekly_challenge_model.dart';
import 'package:smart_expense_manager/features/debts/data/models/debt_account_model.dart';
import 'package:smart_expense_manager/features/debts/data/models/debt_ledger_entry_model.dart';
import 'package:smart_expense_manager/features/goals/data/models/savings_goal_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/merchant_learning_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/merchant_rule_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/recurring_transaction_model.dart';
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
        MerchantLearningModelSchema,
        RecurringTransactionModelSchema,
        SavingsGoalModelSchema,
        WeeklyChallengeModelSchema,
        DebtAccountModelSchema,
        DebtLedgerEntryModelSchema,
      ],
      directory: directory.path,
      name: 'piggyai',
      inspector: false,
    );
  }
}
