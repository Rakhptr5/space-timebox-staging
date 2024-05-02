import 'package:get/get.dart';
import 'package:timebox/modules/features/home/controllers/home_controller.dart';
import 'package:timebox/modules/features/upcoming/controllers/upcoming_controller.dart';

class UpcomingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UpcomingController());
    Get.put(HomeController());
  }
}
