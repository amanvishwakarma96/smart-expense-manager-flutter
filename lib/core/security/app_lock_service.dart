import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class AppLockService {
  AppLockService({
    this._storage = const FlutterSecureStorage(),
    LocalAuthentication? localAuthentication,
  }) : _localAuthentication = localAuthentication ?? LocalAuthentication();

  static const String _enabledKey = 'piggyai.biometric_lock.enabled';

  final FlutterSecureStorage _storage;
  final LocalAuthentication _localAuthentication;

  Future<bool> isEnabled() async {
    return await _storage.read(key: _enabledKey) == 'true';
  }

  Future<void> setEnabled(bool enabled) {
    return _storage.write(key: _enabledKey, value: enabled.toString());
  }

  Future<bool> authenticate() async {
    if (!await _localAuthentication.isDeviceSupported()) {
      return false;
    }
    return _localAuthentication.authenticate(
      localizedReason: 'Unlock your private PiggyAI expenses',
      biometricOnly: false,
      persistAcrossBackgrounding: true,
    );
  }
}
