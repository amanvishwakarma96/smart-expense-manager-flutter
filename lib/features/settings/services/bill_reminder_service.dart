import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/features/transactions/data/models/recurring_transaction_model.dart';
import 'package:smart_expense_manager/features/transactions/domain/expense_transaction.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class BillReminderService {
  BillReminderService({
    required Isar isar,
    FlutterLocalNotificationsPlugin? notifications,
  }) : this._(isar, notifications ?? FlutterLocalNotificationsPlugin());

  BillReminderService._(this._isar, this._notifications);

  static const List<int> supportedLeadDays = <int>[0, 1, 3, 7];
  static const int _notificationIdBase = 700000;

  final Isar _isar;
  final FlutterLocalNotificationsPlugin _notifications;
  bool _initialized = false;

  static int notificationIdFor(int recurringId) {
    return _notificationIdBase + recurringId;
  }

  static DateTime preferredReminderTime({
    required DateTime dueAt,
    required int daysBefore,
  }) {
    if (!supportedLeadDays.contains(daysBefore)) {
      throw ArgumentError.value(
        daysBefore,
        'daysBefore',
        'Unsupported reminder lead time',
      );
    }
    return DateTime(
      dueAt.year,
      dueAt.month,
      dueAt.day,
      9,
    ).subtract(Duration(days: daysBefore));
  }

  static DateTime? scheduleTime({
    required DateTime dueAt,
    required int daysBefore,
    required DateTime now,
  }) {
    if (!dueAt.isAfter(now)) {
      return null;
    }
    final DateTime preferred = preferredReminderTime(
      dueAt: dueAt,
      daysBefore: daysBefore,
    );
    return preferred.isAfter(now)
        ? preferred
        : now.add(const Duration(minutes: 1));
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

  Future<void> syncAll({DateTime? now}) async {
    final List<RecurringTransactionModel> models = await _isar
        .recurringTransactionModels
        .where()
        .findAll();
    for (final RecurringTransactionModel model in models) {
      await _syncModel(model, now: now);
    }
  }

  Future<void> syncTemplate(int id, {DateTime? now}) async {
    final RecurringTransactionModel? model = await _isar
        .recurringTransactionModels
        .get(id);
    if (model == null) {
      await cancelForTemplate(id);
      return;
    }
    await _syncModel(model, now: now);
  }

  Future<void> cancelForTemplate(int id) async {
    await _initialize();
    await _notifications.cancel(id: notificationIdFor(id));
  }

  Future<void> _syncModel(
    RecurringTransactionModel model, {
    DateTime? now,
  }) async {
    await cancelForTemplate(model.id);
    if (!model.isActive ||
        !model.reminderEnabled ||
        model.type != TransactionType.debit ||
        !supportedLeadDays.contains(model.reminderDaysBefore)) {
      return;
    }

    final DateTime? scheduled = scheduleTime(
      dueAt: model.nextDueAt,
      daysBefore: model.reminderDaysBefore,
      now: now ?? DateTime.now(),
    );
    if (scheduled == null) {
      return;
    }

    await _initialize();
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'piggyai_bill_reminders',
        'Bill reminders',
        channelDescription: 'Private reminders for scheduled local payments',
        importance: Importance.high,
        priority: Priority.high,
        visibility: NotificationVisibility.private,
        category: AndroidNotificationCategory.reminder,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: false,
        presentSound: true,
      ),
    );
    await _notifications.zonedSchedule(
      id: notificationIdFor(model.id),
      title: 'Scheduled payment coming up',
      body: 'Open PiggyAI to review an upcoming local payment.',
      scheduledDate: tz.TZDateTime.from(scheduled, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'bill:${model.id}',
    );
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
    tz_data.initializeTimeZones();
    try {
      final TimezoneInfo current = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(current.identifier));
    } on Object {
      tz.setLocalLocation(tz.UTC);
    }
    _initialized = true;
  }
}
