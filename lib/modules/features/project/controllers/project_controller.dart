import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timebox/modules/features/project/models/list_issue_all_users_model.dart';
import 'package:timebox/modules/features/project/repositories/project_repository.dart';
import 'package:timebox/modules/global_controllers/global_controller.dart';
import 'package:timebox/utils/services/dialog_service.dart';
import 'package:timebox/utils/services/hive_service.dart';

class ProjectController extends GetxController {
  static ProjectController get projectC => Get.find();
  dynamic argumentData = Get.arguments;

  var isLoading = true.obs;
  var isMyIssue = true.obs;

  var id = 0.obs;
  var title = "".obs;
  var name = "".obs;
  var photo = "".obs;
  var projectId = 0.obs;

  var listData = RxList<Datum>();

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

    if (argumentData != null) {
      title.value = argumentData[0];
      projectId.value = argumentData[1];

      await HiveServices.box.put("projectTitle", argumentData[0]);
      await HiveServices.box.put("projectId", argumentData[1]);
    } else {
      title.value = await HiveServices.box.get("projectTitle");
      projectId.value = await HiveServices.box.get("projectId");
    }

    id.value = await HiveServices.box.get('id');
    name.value = await HiveServices.box.get("name");
    photo.value = await HiveServices.box.get("photo");

    if (await HiveServices.box.get("projectIsMyIssue") == null) {
      isMyIssue.value = true;
      await HiveServices.box.put("projectIsMyIssue", true);
    } else {
      if (await HiveServices.box.get("projectIsMyIssue") == false) {
        isMyIssue.value = false;
        await HiveServices.box.put("projectIsMyIssue", false);
      } else {
        isMyIssue.value = true;
        await HiveServices.box.put("projectIsMyIssue", true);
      }
    }

    await getAllIssueFromTimebox();

    isLoading.value = false;
  }

  void onRefresh() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!kIsWeb) {
      await GlobalController.to.checkConnection();
    }

    try {
      await getAllIssueFromTimebox();

      isLoading.value = false;
      refreshController.refreshCompleted();
    } catch (e) {
      isLoading.value = false;
      refreshController.refreshFailed();
    }
  }

  Future<void> onReload() async {
    await getAllIssueFromTimebox();
  }

  Future<void> getAllIssueFromTimebox() async {
    var response = await ProjectRepository.getAllIssueFromTimebox(
      mProjectId: '${projectId.value}',
      userAuthId: '$id',
      isMyIssue: isMyIssue.value,
    );

    if (response.statusCode == 200) {
      listData.value = response.data!;
    } else {
      DialogServices.generalSnackbar(
        context: Get.context!,
        message: response.message ?? '',
        dialogType: PanaraDialogType.warning,
      );
    }
  }
}
