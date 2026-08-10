import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('release artifact directory stays outside source control', () {
    final String gitignore = File('.gitignore').readAsStringSync();
    final String workflow = File(
      '.github/workflows/flutter-ci.yml',
    ).readAsStringSync();

    expect(gitignore, contains('dist/'));
    expect(
      workflow.indexOf('Verify generated sources are committed'),
      lessThan(workflow.indexOf('Package signed Android artifacts')),
    );
  });
}
