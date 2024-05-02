import 'package:get/get.dart';
import 'package:timebox/modules/features/login/controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}
