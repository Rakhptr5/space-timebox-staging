import 'package:get/get.dart';
import 'package:timebox/modules/features/home/controllers/home_controller.dart';
import 'package:timebox/modules/features/today/controllers/today_controller.dart';

class TodayBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TodayController());
    Get.put(HomeController());
  }
}
