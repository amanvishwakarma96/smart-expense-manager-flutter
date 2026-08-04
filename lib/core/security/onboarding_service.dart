import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OnboardingService {
  OnboardingService({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) : this._(storage);

  OnboardingService._(this._storage);

  static const String _completedKey = 'piggyai.onboarding.completed';

  final FlutterSecureStorage _storage;

  Future<bool> isCompleted() async {
    return await _storage.read(key: _completedKey) == 'true';
  }

  Future<void> markCompleted() {
    return _storage.write(key: _completedKey, value: 'true');
  }

  Future<void> reset() {
    return _storage.delete(key: _completedKey);
  }
}
