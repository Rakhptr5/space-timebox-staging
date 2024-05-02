import 'package:get/get.dart';
import 'package:timebox/modules/features/home/controllers/home_controller.dart';
import 'package:timebox/modules/features/project/controllers/project_controller.dart';

class ProjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProjectController());
    Get.put(HomeController());
  }
}
