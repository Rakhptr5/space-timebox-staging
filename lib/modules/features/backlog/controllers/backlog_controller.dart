import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timebox/modules/global_controllers/global_controller.dart';
import 'package:timebox/modules/global_modules/issue_model.dart';
import 'package:timebox/modules/global_repositories/issue_repository.dart';
import 'package:timebox/utils/services/dialog_service.dart';
import 'package:timebox/utils/services/hive_service.dart';

class BacklogController extends GetxController {
  static BacklogController get backlogC => Get.find();

  var id = 0.obs;
  var name = "".obs;

  var isLoading = false.obs;
  var listWaitingTimebox = <Timebox?>[].obs;
  var listWaitingIssue = <Issue?>[].obs;
  var countWaiting = "".obs;

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;

    if (!kIsWeb) {
      await GlobalController.to.checkConnection();
    }

    id.value = await HiveServices.box.get('id');
    name.value = await HiveServices.box.get('name');

    await getIssueWaiting(
      id: id.value,
      projectId: 0,
      section: "waiting",
    );
  }

  void onRefresh() async {
    isLoading.value = true;

    await Future.delayed(const Duration(milliseconds: 1000));
    if (!kIsWeb) {
      await GlobalController.to.checkConnection();
    }

    try {
      getIssueWaiting(
        id: id.value,
        projectId: 0,
        section: "waiting",
      );

      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
  }

  Future<void> onReload() async {
    await getIssueWaiting(
      id: id.value,
      projectId: 0,
      section: "waiting",
    );
  }

  Future<void> getIssueWaiting({
    required int id,
    required int projectId,
    required String section,
  }) async {
    IssueResponseModel response = await IssueRepository.getIssueBacklog(
      id: id,
      projectId: projectId,
      section: section,
    );

    if (response.statusCode == 200) {
      listWaitingTimebox.value = response.data!.timebox!;
      listWaitingIssue.value = response.data!.issue!;
      countWaiting.value =
          (response.data!.timebox!.length + response.data!.issue!.length)
              .toString();

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
