import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:isar_community/isar.dart';
import 'package:smart_expense_manager/features/debts/data/models/debt_account_model.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class DebtReminderService {
  DebtReminderService({
    required Isar isar,
    FlutterLocalNotificationsPlugin? notifications,
  }) : this._(isar, notifications ?? FlutterLocalNotificationsPlugin());

  DebtReminderService._(this._isar, this._notifications);

  static const List<int> supportedLeadDays = <int>[1, 3, 7];
  static const int _notificationIdBase = 820000;

  final Isar _isar;
  final FlutterLocalNotificationsPlugin _notifications;
  bool _initialized = false;

  static int notificationIdFor(int debtId) => _notificationIdBase + debtId;

  static DateTime preferredReminderTime({
    required DateTime dueAt,
    required int daysBefore,
  }) {
    if (!supportedLeadDays.contains(daysBefore)) {
      throw ArgumentError.value(daysBefore, 'daysBefore', 'Unsupported lead time');
    }
    return DateTime(dueAt.year, dueAt.month, dueAt.day, 9).subtract(
      Duration(days: daysBefore),
    );
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
    final List<DebtAccountModel> accounts = await _isar.debtAccountModels
        .where()
        .findAll();
    for (final DebtAccountModel account in accounts) {
      await _syncModel(account, now: now);
    }
  }

  Future<void> syncAccount(int id, {DateTime? now}) async {
    final DebtAccountModel? model = await _isar.debtAccountModels.get(id);
    if (model == null) {
      await cancelForAccount(id);
      return;
    }
    await _syncModel(model, now: now);
  }

  Future<void> cancelForAccount(int id) async {
    await _initialize();
    await _notifications.cancel(id: notificationIdFor(id));
  }

  Future<void> _syncModel(DebtAccountModel model, {DateTime? now}) async {
    await cancelForAccount(model.id);
    final DateTime? dueDate = model.dueDate;
    if (model.isArchived ||
        !model.reminderEnabled ||
        dueDate == null ||
        !supportedLeadDays.contains(model.reminderDaysBefore)) {
      return;
    }
    final DateTime? scheduled = scheduleTime(
      dueAt: dueDate,
      daysBefore: model.reminderDaysBefore,
      now: now ?? DateTime.now(),
    );
    if (scheduled == null) {
      return;
    }

    await _initialize();
    const NotificationDetails details = NotificationDetails(
      android: AndroidNotificationDetails(
        'piggyai_debt_reminders',
        'Debt and loan reminders',
        channelDescription: 'Private reminders for local debt and loan due dates',
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
      title: 'Debt or loan due date coming up',
      body: 'Open PiggyAI to review a private local balance.',
      scheduledDate: tz.TZDateTime.from(scheduled, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'debt:${model.id}',
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
