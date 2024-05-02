import 'package:get/get.dart';
import 'package:timebox/modules/global_controllers/global_controller.dart';
import 'package:timebox/modules/global_controllers/issue_controller.dart';
import 'package:timebox/modules/global_controllers/list_issue_controller.dart';
import 'package:timebox/modules/global_controllers/notification_controller.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GlobalController());
    Get.put(IssueController());
    Get.put(ListIssueController());
    Get.put(NotificationController());
  }
}
