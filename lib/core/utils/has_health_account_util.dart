import 'package:hive/hive.dart';

class HasHealthAccountUtil {
  HasHealthAccountUtil._();// private constructor  يمنع إنشاء غرض من هذا الصف

  static Future<bool> hasHealthAccount()async{
    final box = Hive.box("user_data");
    return box.get("hasHealthAccount") ?? false;
  }
}