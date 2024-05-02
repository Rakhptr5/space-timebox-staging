import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timebox/modules/global_controllers/global_controller.dart';
import 'package:timebox/modules/global_modules/issue_model.dart';
import 'package:timebox/modules/global_repositories/issue_repository.dart';
import 'package:timebox/utils/services/hive_service.dart';

import '../../../../utils/services/dialog_service.dart';

class UpcomingController extends GetxController {
  static UpcomingController get upcomingC => Get.find();

  var id = 0.obs;
  var name = "".obs;

  var isLoading = false.obs;
  var isCollapse = false.obs;
  var date = DateTime.now().obs;
  var dateLabel = "Today".obs;
  var dateName = DateFormat('dd MMMM', "id").format(DateTime.now()).obs;
  var isDeleted = false.obs;
  var listTimebox = <Timebox?>[].obs;
  var listIssue = <Issue?>[].obs;
  var pointDone = "".obs;
  var pointAll = "".obs;
  var issueCount = "".obs;

  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;

    if (!kIsWeb) {
      await GlobalController.to.checkConnection();
    }

    id.value = await HiveServices.box.get('id');
    name.value = await HiveServices.box.get('name');

    getTodayIssue(
      id: id.value,
      projectId: 0,
      position: date.value.toString(),
    );
  }

  void onRefresh() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!kIsWeb) {
      await GlobalController.to.checkConnection();
    }

    try {
      getTodayIssue(
        id: id.value,
        projectId: 0,
        position: date.value.toString(),
      );

      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
  }

  Future<void> onReload() async {
    await getTodayIssue(
      id: id.value,
      projectId: 0,
      position: date.value.toString(),
    );
  }

  Future<void> getTodayIssue({
    required int id,
    required int projectId,
    required String position,
  }) async {
    IssueResponseModel response = await IssueRepository.getIssue(
      id: id,
      projectId: projectId,
      position: position,
    );

    if (response.statusCode == 200) {
      listTimebox.value = response.data!.timebox!;
      listIssue.value = response.data!.issue!;
      pointDone.value = response.data!.point!.pointDone!;
      pointAll.value = response.data!.point!.pointAll!;
      issueCount.value = response.data!.point!.issueCount!;

      isLoading.value = false;
    } else {
      DialogServices.generalSnackbar(
        context: Get.context!,
        message: response.message ?? '',
        dialogType: PanaraDialogType.warning,
      );
      isLoading.value = false;
    }
  }

  bool onChangeDate() {
    final dateNow = DateTime.now();

    ///dateNow is equal date.value
    if (dateNow.day.isEqual(date.value.day)) {
      return true;
    } else {
      /// compare date from dateTime.Now
      if (dateNow.compareTo(date.value) < 0) {
        ///dateNow is before date.value
        return true;
      } else if (dateNow.compareTo(date.value) > 0) {
        ///dateNow is after date.value
        return false;
      } else {
        return false;
      }
    }
  }

  void selectedDay(day) {
    date.value = day;
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    var yesterday = DateTime(now.year, now.month, now.day - 1);
    var tomorrow = DateTime(now.year, now.month, now.day + 1);
    var aDate = DateTime(day.year, day.month, day.day);

    if (aDate == today) {
      dateLabel.value = "Today";
    } else if (aDate == yesterday) {
      dateLabel.value = "Yesterday";
    } else if (aDate == tomorrow) {
      dateLabel.value = "Tomorrow";
    } else {
      dateLabel.value = DateFormat('EEEE', "id").format(day);
    }

    dateName.value = DateFormat('dd MMMM', "id").format(day);
    isLoading.value = true;
    getTodayIssue(
      id: id.value,
      projectId: 0,
      position: day.toString(),
    );
  }

  void setCollapse(value) {
    if (value == false) {
      isCollapse.value = true;
    } else {
      isCollapse.value = false;
    }
  }
}
