import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PasswordSecureStorage {
  static final _storage = FlutterSecureStorage();
  static const _keyPassword = 'password';
  static const _keyFailedAttempts = 'failed_attempts';

  static Future setPassword(String password) async => await _storage.write(key: _keyPassword, value: password);

  static Future<String?> getPassword() async => await _storage.read(key: _keyPassword);

  static Future setFailedAttempts(int val) async =>
      await _storage.write(key: _keyFailedAttempts, value: val.toString());

  static Future<int> getFailedAttempts() async {
    String? val = await _storage.read(key: _keyFailedAttempts);
    if (val == null) {
      return 0;
    }
    return int.parse(val);
  }
}
