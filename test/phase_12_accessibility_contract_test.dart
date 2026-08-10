import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('shared loading states expose live-region semantics', () {
    final String source = File(
      'lib/core/widgets/app_state_view.dart',
    ).readAsStringSync();

    expect(source, contains('liveRegion: true'));
    expect(source, contains('semanticsLabel: label'));
    expect(source, contains("label: const Text('Try again')"));
  });

  test('playful motion respects the platform reduce-motion preference', () {
    final String source = File(
      'lib/core/widgets/playful_empty_state.dart',
    ).readAsStringSync();

    expect(source, contains('disableAnimations'));
    expect(source, contains('if (!reduceMotion)'));
    expect(source, contains('ExcludeSemantics'));
  });

  test('theme keeps primary touch targets at least 48 logical pixels', () {
    final String source = File(
      'lib/core/theme/app_theme.dart',
    ).readAsStringSync();

    expect(source, contains('MaterialTapTargetSize.padded'));
    expect(source, contains('Size.square(48)'));
    expect(source, contains('Size(48, 48)'));
  });

  test(
    'app shell remains scrollable and expands navigation for large text',
    () {
      final String source = File('lib/app.dart').readAsStringSync();

      expect(source, contains('AppLoadingState'));
      expect(source, contains('SingleChildScrollView'));
      expect(source, contains('MediaQuery.textScalerOf(context)'));
      expect(source, contains('height: navigationHeight'));
    },
  );
}
