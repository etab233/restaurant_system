import 'package:shared_preferences/shared_preferences.dart';

class HasHealthAccountUtil {
  HasHealthAccountUtil._();// private constructor  يمنع إنشاء غرض من هذا الصف

  static Future<bool> hasHealthAccount()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("hasHealthAccount") ?? false;
  }
}