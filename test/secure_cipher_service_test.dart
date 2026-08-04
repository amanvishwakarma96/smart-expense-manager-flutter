import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_expense_manager/core/security/secure_cipher_service.dart';

void main() {
  test('sensitive values are encrypted before persistence', () async {
    final SecureCipherService cipher = SecureCipherService.forTesting(
      Uint8List.fromList(List<int>.generate(32, (int index) => index)),
    );

    const String clearText = 'A/c 7788 paid SWIGGY INR 1250';
    final String encrypted = await cipher.encrypt(clearText);

    expect(encrypted, isNot(clearText));
    expect(encrypted, isNot(contains('SWIGGY')));
    expect(await cipher.decrypt(encrypted), clearText);
  });

  test('same value receives a fresh nonce', () async {
    final SecureCipherService cipher = SecureCipherService.forTesting(
      Uint8List.fromList(List<int>.filled(32, 7)),
    );

    final String first = await cipher.encrypt('private');
    final String second = await cipher.encrypt('private');

    expect(first, isNot(second));
  });
}
