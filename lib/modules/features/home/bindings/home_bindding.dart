import 'package:get/instance_manager.dart';
import 'package:timebox/modules/features/home/controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}
