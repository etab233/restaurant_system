import 'package:hive/hive.dart';

class HealthProfileLocalDataSource {
  Box get _box => Hive.box("user_data");

  bool getCachedHasHealthAccount() => _box.get("hasHealthAccount") ?? false;

  Future<void> setHasHealthAccount(bool value) => _box.put("hasHealthAccount", value);

}