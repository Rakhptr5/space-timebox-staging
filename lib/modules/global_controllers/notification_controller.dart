import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:timebox/modules/features/upcoming/controllers/upcoming_controller.dart';
import 'package:timebox/modules/global_controllers/list_issue_controller.dart';
import 'package:timebox/utils/services/notification_service.dart';

class NotificationController extends GetxController {
  static NotificationController get to => Get.find();

  void settingNotification({
    required dynamic userAuthId,
  }) async {
    await Future.delayed(
      const Duration(microseconds: 100),
      () => Get.put(UpcomingController()),
    );

    await UpcomingController.upcomingC.getTodayIssue(
      id: int.parse(userAuthId.toString()),
      projectId: 0,
      position: DateTime.now().toString(),
    );

    var newList = UpcomingController.upcomingC.listTimebox;

    if (newList != [] || newList.isNotEmpty) {
      for (var element in newList) {
        if (element?.date != "No Date") {
          var date = DateTime.parse(element?.date ?? DateTime.now().toString());
          var minDate = date.millisecondsSinceEpoch - 900000;
          var thisDate = DateTime.fromMillisecondsSinceEpoch(minDate);
          var body = ListIssueController.to.setDateName(
            dateName: element?.dateName ?? 'No Date',
            isOverdue: false,
            from: "",
          );

          if (!kIsWeb) {
            NotificationService.handleNotif(
              id: element?.id ?? 0,
              title: element?.name ?? "My Issue",
              body: body[0],
              startTime: DateTime.now(),
              finishTime: thisDate,
            );
          } else {
            NotificationService.handleNotifWeb(
              title: element?.name ?? "My Issue",
              body: body[0],
              startTime: DateTime.now(),
              finishTime: thisDate,
            );
          }
        }
      }
    }
  }
}
