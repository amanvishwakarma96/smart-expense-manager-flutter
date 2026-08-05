import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

class BackupPasswordException implements Exception {
  const BackupPasswordException();

  @override
  String toString() => 'The backup password is incorrect or the file is damaged.';
}

class EncryptedBackupCodec {
  EncryptedBackupCodec({int iterations = defaultIterations})
    : this._(iterations);

  EncryptedBackupCodec._(this._iterations);

  static const String format = 'piggyai-encrypted-backup';
  static const int version = 1;
  static const int defaultIterations = 210000;

  final int _iterations;
  final AesGcm _cipher = AesGcm.with256bits();

  Future<Uint8List> encrypt({
    required Map<String, Object?> payload,
    required String password,
  }) async {
    _validatePassword(password);
    final List<int> salt = SecretKeyData.random(length: 16).bytes;
    final SecretKey key = await _deriveKey(password: password, salt: salt);
    final List<int> nonce = _cipher.newNonce();
    final SecretBox box = await _cipher.encrypt(
      utf8.encode(jsonEncode(payload)),
      secretKey: key,
      nonce: nonce,
    );

    final Map<String, Object?> envelope = <String, Object?>{
      'format': format,
      'version': version,
      'kdf': 'pbkdf2-hmac-sha256',
      'iterations': _iterations,
      'salt': base64Encode(salt),
      'nonce': base64Encode(nonce),
      'cipherText': base64Encode(box.cipherText),
      'mac': base64Encode(box.mac.bytes),
    };
    return Uint8List.fromList(utf8.encode(jsonEncode(envelope)));
  }

  Future<Map<String, Object?>> decrypt({
    required Uint8List encryptedBytes,
    required String password,
  }) async {
    _validatePassword(password);
    try {
      final Object? decoded = jsonDecode(utf8.decode(encryptedBytes));
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Invalid backup envelope');
      }
      if (decoded['format'] != format || decoded['version'] != version) {
        throw const FormatException('Unsupported backup format');
      }

      final int iterations = decoded['iterations'] as int? ?? _iterations;
      if (iterations < 100000 || iterations > 1000000) {
        throw const FormatException('Invalid backup key settings');
      }
      final List<int> salt = base64Decode(decoded['salt'] as String);
      final List<int> nonce = base64Decode(decoded['nonce'] as String);
      final List<int> cipherText = base64Decode(
        decoded['cipherText'] as String,
      );
      final List<int> mac = base64Decode(decoded['mac'] as String);
      final SecretKey key = await _deriveKey(
        password: password,
        salt: salt,
        iterations: iterations,
      );
      final List<int> clearBytes = await _cipher.decrypt(
        SecretBox(cipherText, nonce: nonce, mac: Mac(mac)),
        secretKey: key,
      );
      final Object? payload = jsonDecode(utf8.decode(clearBytes));
      if (payload is! Map<String, dynamic>) {
        throw const FormatException('Invalid backup payload');
      }
      return payload.cast<String, Object?>();
    } on SecretBoxAuthenticationError {
      throw const BackupPasswordException();
    } on FormatException {
      rethrow;
    } on Object {
      throw const FormatException('Invalid or damaged PiggyAI backup');
    }
  }

  Future<SecretKey> _deriveKey({
    required String password,
    required List<int> salt,
    int? iterations,
  }) {
    final Pbkdf2 algorithm = Pbkdf2(
      macAlgorithm: Hmac.sha256(),
      iterations: iterations ?? _iterations,
      bits: 256,
    );
    return algorithm.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );
  }

  void _validatePassword(String password) {
    if (password.length < 8) {
      throw ArgumentError.value(
        password.length,
        'password.length',
        'Use at least 8 characters',
      );
    }
  }
}
