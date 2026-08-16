import 'package:hive/hive.dart';

class HealthProfileLocalDataSource {
  bool? getCachedHasHealthAccount() => _box.get("hasHealthAccount");

  Future<void> setHasHealthAccount(bool value) => _box.put("hasHealthAccount", value);

  Box get _box => Hive.box("user_data");
}