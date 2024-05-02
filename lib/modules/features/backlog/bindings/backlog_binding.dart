import 'package:get/get.dart';
import 'package:timebox/modules/features/backlog/controllers/backlog_controller.dart';
import 'package:timebox/modules/features/home/controllers/home_controller.dart';

class BacklogBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BacklogController());
    Get.put(HomeController());
  }
}
