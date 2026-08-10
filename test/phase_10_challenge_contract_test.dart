import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('new challenge editor initializes without a prior challenge', () {
    final String ui = File(
      'lib/features/challenges/presentation/weekly_money_challenge_card.dart',
    ).readAsStringSync();
    final String domain = File(
      'lib/features/challenges/domain/weekly_challenge.dart',
    ).readAsStringSync();

    expect(ui, contains('widget.challenge?.targetDays ?? 0'));
    expect(ui, isNot(contains('widget.challenge!.targetDays')));
    expect(domain, contains('item.countsAsSpending'));
    expect(domain, isNot(contains('return item.isDebit &&')));
  });
}
