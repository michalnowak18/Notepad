import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PasswordSecureStorage {
  static final _storage = FlutterSecureStorage();
  static const _keyPassword = 'password';

  static Future setPassword(String password) async => await _storage.write(key: _keyPassword, value: password);

  static Future<String?> getPassword() async => await _storage.read(key: _keyPassword);
}
