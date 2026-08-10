import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('release artifact directory stays outside source control', () {
    final String gitignore = File('.gitignore').readAsStringSync();
    final String workflow = File(
      '.github/workflows/flutter-ci.yml',
    ).readAsStringSync();
    final ProcessResult tracked = Process.runSync('git', <String>[
      'ls-files',
      'dist/*',
    ]);

    expect(gitignore, contains('dist/'));
    expect(tracked.exitCode, 0);
    expect(tracked.stdout.toString().trim(), isEmpty);
    expect(workflow, contains("git ls-files 'dist/*'"));
    expect(
      workflow.indexOf('Verify generated sources are committed'),
      lessThan(workflow.indexOf('Package signed Android artifacts')),
    );
  });

  test('release packaging rejects a debug certificate', () {
    final String workflow = File(
      '.github/workflows/flutter-ci.yml',
    ).readAsStringSync();

    expect(workflow, contains("grep -qi 'Android Debug'"));
    expect(workflow, contains("grep -qi 'jar verified'"));
    expect(workflow, contains('apksigner'));
    expect(workflow, contains('jarsigner -verify'));
  });
}
