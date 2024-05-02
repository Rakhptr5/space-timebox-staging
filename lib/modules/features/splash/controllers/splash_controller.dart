import 'dart:async';
import 'package:get/get.dart';
import 'package:timebox/configs/routes/app_route.dart';
import 'package:timebox/utils/services/hive_service.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    authCheck();
  }

  Future<void> authCheck() async {
    if (HiveServices.box.get("isLogin") == true) {
      Timer(const Duration(seconds: 1), () {
        Get.offNamed(AppRoutes.homeRoute);
      });
    } else {
      Timer(const Duration(seconds: 1), () {
        Get.offNamed(AppRoutes.loginRoute);
      });
    }
  }
}
