import 'package:hive_flutter/hive_flutter.dart';
import 'package:timebox/constants/cores/api_constant.dart';
import 'package:timebox/constants/cores/hive_constant.dart';

class UrlHiveService {
  UrlHiveService._();
  static final box = Hive.box(HiveConstant.url);

  static Future<void> setUrl(String url) async {
    await box.put('url', url);
  }

  static String getBaseUrl() {
    if (box.get('url') == null || box.get('url') == '') {
      return ApiConstant.apiBaseUrl;
    } else {
      return box.get('url');
    }
  }
}
