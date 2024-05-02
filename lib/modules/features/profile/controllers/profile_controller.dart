import 'package:flutter/foundation.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:timebox/configs/routes/app_route.dart';
import 'package:timebox/modules/global_controllers/global_controller.dart';
import 'package:timebox/utils/services/hive_service.dart';
import 'package:timebox/utils/services/notification_service.dart';

class ProfileController extends GetxController {
  static ProfileController get profileC => Get.find();
  var name = "".obs;
  var photo = "".obs;
  var position = "".obs;
  var atasan = "".obs;
  var id = 0.obs;
  @override
  void onInit() async {
    id.value = await HiveServices.box.get('id');
    photo.value = await HiveServices.box.get("photo");
    name.value = await HiveServices.box.get("name");
    position.value = await HiveServices.box.get("position");
    atasan.value = await HiveServices.box.get("atasan");

    super.onInit();
  }

  void logout() async {
    await HiveServices.deleteAuth();
    if (!kIsWeb) {
      if (GlobalController.to.appBadgeSupported.value == "Supported") {
        FlutterAppBadger.removeBadge();
      }
    }

    NotificationService.cancelTimerNotifaction();
    Get.offAllNamed(AppRoutes.loginRoute);
  }
}
