import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/features/settings/services/budget_alert_service.dart';

void main() {
  group('BudgetAlertService alert buckets', () {
    test('does not alert before the configured threshold', () {
      expect(
        BudgetAlertService.alertBucketForPercentage(
          percentage: 79,
          threshold: 80,
        ),
        0,
      );
    });

    test('alerts at the configured threshold', () {
      expect(
        BudgetAlertService.alertBucketForPercentage(
          percentage: 80,
          threshold: 80,
        ),
        80,
      );
    });

    test('uses a distinct over-budget bucket', () {
      expect(
        BudgetAlertService.alertBucketForPercentage(
          percentage: 118,
          threshold: 80,
        ),
        100,
      );
    });
  });
}
