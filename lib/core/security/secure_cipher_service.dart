import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureCipherService {
  SecureCipherService._(this._secretKey);

  static const String _storageKey = 'piggyai.aes256.key';
  static const int _nonceLength = 12;
  static const int _macLength = 16;

  final SecretKey _secretKey;
  final AesGcm _algorithm = AesGcm.with256bits();

  static Future<SecureCipherService> create({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) async {
    final String? existing = await storage.read(key: _storageKey);
    if (existing != null && existing.isNotEmpty) {
      return SecureCipherService._(SecretKey(base64Decode(existing)));
    }

    final AesGcm algorithm = AesGcm.with256bits();
    final SecretKey key = await algorithm.newSecretKey();
    final List<int> keyBytes = await key.extractBytes();
    await storage.write(key: _storageKey, value: base64Encode(keyBytes));
    return SecureCipherService._(key);
  }

  factory SecureCipherService.forTesting(Uint8List keyBytes) {
    if (keyBytes.length != 32) {
      throw ArgumentError.value(
        keyBytes.length,
        'keyBytes.length',
        'Must be 32',
      );
    }
    return SecureCipherService._(SecretKey(keyBytes));
  }

  Future<String> encrypt(String plainText) async {
    if (plainText.isEmpty) {
      return '';
    }
    final List<int> nonce = _algorithm.newNonce();
    final SecretBox box = await _algorithm.encrypt(
      utf8.encode(plainText),
      secretKey: _secretKey,
      nonce: nonce,
    );
    return base64Encode(<int>[...nonce, ...box.cipherText, ...box.mac.bytes]);
  }

  Future<String> decrypt(String cipherText) async {
    if (cipherText.isEmpty) {
      return '';
    }
    final Uint8List payload = base64Decode(cipherText);
    if (payload.length <= _nonceLength + _macLength) {
      throw const FormatException('Invalid encrypted payload');
    }
    final List<int> nonce = payload.sublist(0, _nonceLength);
    final List<int> mac = payload.sublist(payload.length - _macLength);
    final List<int> encrypted = payload.sublist(
      _nonceLength,
      payload.length - _macLength,
    );
    final List<int> clearBytes = await _algorithm.decrypt(
      SecretBox(encrypted, nonce: nonce, mac: Mac(mac)),
      secretKey: _secretKey,
    );
    return utf8.decode(clearBytes);
  }

  static Future<void> deleteInstallationKey({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) {
    return storage.delete(key: _storageKey);
  }
}
