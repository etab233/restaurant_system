import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage _secureStorage;
  AuthLocalDataSource({FlutterSecureStorage? secureStorage})
    : _secureStorage =
          secureStorage ??
          const FlutterSecureStorage(aOptions: AndroidOptions());

  Box get _box => Hive.box("user_data");

  Future<void> saveSession({
    required String token,
    required Map<String, dynamic> userData,
  }) async {
    await _secureStorage.write(key: "token", value: token);
    await _box.put("userData", userData);
  }

  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: "token", value: token);
  }

  Future<void> clearSession() async {
    await _secureStorage.delete(key: "token");
    await _box.delete("userData");
  }

  Future<String?> getToken() => _secureStorage.read(key: "token");

  Map<String, dynamic>? getUserData() {
    final raw = _box.get("userData");

    if (raw == null) return null;
    return Map<String, dynamic>.from(raw);
  }
}
