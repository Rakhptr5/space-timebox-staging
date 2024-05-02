import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:timebox/configs/routes/app_route.dart';
import 'package:timebox/modules/features/login/models/login_model.dart';
import 'package:timebox/modules/features/login/repositories/login_repository.dart';
import 'package:timebox/modules/global_controllers/notification_controller.dart';
import 'package:timebox/utils/services/dialog_service.dart';
import 'package:timebox/utils/services/hive_service.dart';

class LoginController extends GetxController {
  static LoginController get loginC => Get.find();

  var isHidePassword = true.obs;
  RxBool isLoading = RxBool(false);

  ///[errorText, validationText] for check error text
  var errorText = "".obs;
  var validationText = "".obs;
  var isConnect = false.obs;

  ///Login fuction
  Future<void> login(String email, String password) async {
    ///reset error text dan restart loading
    isLoading.value = true;
    errorText.value = "";
    DialogServices.loadingDialog(
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );

    LoginResponseModel response = await LoginRepository.login(email, password);

    ///response.status == 200 (success)
    DialogServices.closeDialog();
    if (response.statusCode == 200) {
      await HiveServices.setAuth(response.data!);
      hideLoading();

      NotificationController.to.settingNotification(
        userAuthId: HiveServices.box.get('id').toString(),
      );

      Get.offAllNamed(AppRoutes.homeRoute);
    } else {
      DialogServices.customGeneralDialog(
        context: Get.context!,
        message: response.message ?? '',
        dialogType: PanaraDialogType.error,
      );
    }
  }

  ///Hide Loading
  void hideLoading() {
    Get.close(1);
    isLoading.value = false;
  }
}
