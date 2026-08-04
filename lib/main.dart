import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/app.dart';
import 'package:smart_expense_manager/core/database/app_database.dart';
import 'package:smart_expense_manager/core/providers/app_providers.dart';
import 'package:smart_expense_manager/core/security/app_lock_service.dart';
import 'package:smart_expense_manager/core/security/secure_cipher_service.dart';
import 'package:smart_expense_manager/features/sms_engine/services/sms_engine_coordinator.dart';
import 'package:smart_expense_manager/features/transactions/data/repositories/category_repository.dart';
import 'package:smart_expense_manager/features/transactions/data/repositories/merchant_rule_repository.dart';
import 'package:smart_expense_manager/features/transactions/data/repositories/transaction_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  final Isar isar = await AppDatabase.open();
  final SecureCipherService cipher = await SecureCipherService.create();
  final CategoryRepository categories = CategoryRepository(isar);
  await categories.seedDefaults();

  final TransactionRepository transactions = TransactionRepository(isar, cipher);
  final SmsEngineCoordinator smsEngine = SmsEngineCoordinator(
    transactionRepository: transactions,
    merchantRuleRepository: MerchantRuleRepository(isar),
  );
  unawaited(smsEngine.drainNativeQueue());

  final bool lockEnabled = await AppLockService().isEnabled();
  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
        cipherProvider.overrideWithValue(cipher),
      ],
      child: PiggyAiApp(lockEnabled: lockEnabled),
    ),
  );
}
