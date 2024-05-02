import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timebox/modules/features/today/models/today_issue_model.dart';
import 'package:timebox/modules/features/today/repositories/today_issue_repository.dart';
import 'package:timebox/modules/global_controllers/global_controller.dart';
import 'package:timebox/utils/services/hive_service.dart';

import '../../../../utils/services/dialog_service.dart';

class TodayController extends GetxController {
  static TodayController get to => Get.find();

  var id = 0.obs;
  var name = "".obs;

  var date = DateTime.now().obs;
  var isLoading = false.obs;
  var isLoadingLoad = false.obs;
  var dateName = DateFormat('dd MMMM', "id").format(DateTime.now()).obs;
  var listData = <ListElement?>[].obs;
  var listTodayTimeboxOverdue = <Timebox?>[].obs;
  var listTodayIssueOverdue = <Issue?>[].obs;
  var page = 0.obs;
  var tanggal = "".obs;
  var refreshController = RefreshController(initialRefresh: false);

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
      position: "today",
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
        position: "today",
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
      position: "today",
    );
  }

  Future<void> getTodayIssue({
    required int id,
    required int projectId,
    required String position,
  }) async {
    TodayIssueResponseModel response = await TodayIssueRepository.getIssue(
      id: id,
      projectId: projectId,
      position: position,
    );

    if (response.statusCode == 200) {
      listData.value = response.data!.list!;
      listTodayIssueOverdue.value = response.data!.overdueIssue!;
      listTodayTimeboxOverdue.value = response.data!.overdueTimebox!;

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
}
