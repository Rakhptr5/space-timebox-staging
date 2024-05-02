import 'package:get/get.dart';
import 'package:timebox/modules/features/home/controllers/home_controller.dart';
import 'package:timebox/modules/features/my_squad/controllers/my_squad_controller.dart';

import '../../today/controllers/today_controller.dart';

class MySquadBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MySquadController());
    Get.put(TodayController());
    Get.put(HomeController());
  }
}
