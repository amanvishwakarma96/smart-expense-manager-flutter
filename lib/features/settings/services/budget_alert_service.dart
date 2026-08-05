import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/features/transactions/data/models/category_model.dart';
import 'package:smart_expense_manager/features/transactions/data/models/transaction_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';

class BudgetAlertService {
  BudgetAlertService({
    required Isar isar,
    FlutterSecureStorage storage = const FlutterSecureStorage(),
    FlutterLocalNotificationsPlugin? notifications,
  }) : _isar = isar,
       _storage = storage,
       _notifications = notifications ?? FlutterLocalNotificationsPlugin();

  static const String _enabledKey = 'piggyai.budget_alerts.enabled';
  static const String _thresholdKey = 'piggyai.budget_alerts.threshold';
  static const String _alertStatePrefix = 'piggyai.budget_alerts.state';
  static const int defaultThreshold = 80;
  static const List<int> supportedThresholds = <int>[50, 70, 80, 90];

  final Isar _isar;
  final FlutterSecureStorage _storage;
  final FlutterLocalNotificationsPlugin _notifications;
  bool _initialized = false;

  Future<bool> isEnabled() async {
    return await _storage.read(key: _enabledKey) == 'true';
  }

  Future<void> setEnabled(bool enabled) {
    return _storage.write(key: _enabledKey, value: enabled.toString());
  }

  Future<int> getThreshold() async {
    final int? stored = int.tryParse(
      await _storage.read(key: _thresholdKey) ?? '',
    );
    return supportedThresholds.contains(stored) ? stored! : defaultThreshold;
  }

  Future<void> setThreshold(int threshold) {
    if (!supportedThresholds.contains(threshold)) {
      throw ArgumentError.value(
        threshold,
        'threshold',
        'Unsupported budget alert threshold',
      );
    }
    return _storage.write(key: _thresholdKey, value: threshold.toString());
  }

  Future<bool> requestPermission() async {
    await _initialize();
    if (Platform.isAndroid) {
      return await _notifications
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission() ??
          false;
    }
    if (Platform.isIOS) {
      return await _notifications
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(alert: true, badge: false, sound: true) ??
          false;
    }
    return true;
  }

  Future<void> checkCategory(int? categoryId, {DateTime? now}) async {
    if (categoryId == null || !await isEnabled()) {
      return;
    }
    final CategoryModel? category = await _isar.categoryModels.get(categoryId);
    if (category == null || category.monthlyBudgetLimit <= 0) {
      return;
    }

    final DateTime current = now ?? DateTime.now();
    final List<TransactionModel> models = await _isar.transactionModels
        .where()
        .findAll();
    final double spent = models
        .where((TransactionModel item) {
          return item.categoryId == categoryId &&
              item.status == TransactionStatus.confirmed &&
              item.type == TransactionType.debit &&
              item.timestamp.year == current.year &&
              item.timestamp.month == current.month;
        })
        .fold(
          0,
          (double total, TransactionModel item) => total + item.amount,
        );
    final int percentage = (spent / category.monthlyBudgetLimit * 100).floor();
    final int threshold = await getThreshold();
    final int bucket = percentage >= 100
        ? 100
        : percentage >= threshold
        ? threshold
        : 0;
    if (bucket == 0) {
      return;
    }

    final String stateKey = '$_alertStatePrefix.'
        '${current.year}-${current.month}.$categoryId';
    final int previousBucket = int.tryParse(
          await _storage.read(key: stateKey) ?? '',
        ) ??
        0;
    if (previousBucket >= bucket) {
      return;
    }

    await _initialize();
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'piggyai_budget_alerts',
        'Budget alerts',
        channelDescription: 'Local category budget threshold alerts',
        importance: Importance.high,
        priority: Priority.high,
        visibility: NotificationVisibility.private,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: false,
        presentSound: true,
      ),
    );
    final String title = bucket >= 100
        ? '${category.name} budget reached'
        : '${category.name} budget warning';
    final String body = bucket >= 100
        ? 'This category has reached its monthly budget.'
        : 'This category has used at least $bucket% of its monthly budget.';
    await _notifications.show(
      id: categoryId * 1000 + bucket,
      title: title,
      body: body,
      notificationDetails: details,
      payload: 'budget:$categoryId',
    );
    await _storage.write(key: stateKey, value: bucket.toString());
  }

  Future<void> _initialize() async {
    if (_initialized) {
      return;
    }
    const InitializationSettings settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _notifications.initialize(settings: settings);
    _initialized = true;
  }
}
