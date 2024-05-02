import 'package:hive_flutter/hive_flutter.dart';
import 'package:timebox/constants/cores/hive_constant.dart';
import 'package:timebox/modules/features/login/models/login_model.dart';

class HiveServices {
  HiveServices._();
  static final box = Hive.box(HiveConstant.db);

  static Future<void> setAuth(Data serverSelected) async {
    await box.put("id", serverSelected.user!.id);
    await box.put("name", serverSelected.user!.nama);
    await box.put("photo", serverSelected.user!.humanisFoto);
    await box.put("position", serverSelected.user!.jabatan);
    await box.put("level_jabatan", serverSelected.user!.levelJabatan);
    await box.put("atasan", serverSelected.user!.atasan);
    await box.put("isLogin", true);
  }

  static Future deleteAuth() async {
    box.clear();
    box.put("isLogin", false);
    return true;
  }

  static Future setHomeTab({
    required bool isMyproject,
  }) async {
    await box.put('isMyProject', isMyproject);
  }

  static bool? getHomeTab() {
    return box.get('isMyProject');
  }
}
