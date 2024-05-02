import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timebox/configs/routes/app_route.dart';
import 'package:timebox/modules/features/home/models/home_model.dart';
import 'package:timebox/modules/features/home/models/squad_model/squad_model.dart';
import 'package:timebox/modules/features/home/repositories/home_repository.dart';
import 'package:timebox/modules/global_controllers/global_controller.dart';
import 'package:timebox/utils/services/dialog_service.dart';
import 'package:timebox/utils/services/hive_service.dart';
import 'package:timebox/utils/services/notification_service.dart';

class HomeController extends GetxController {
  static HomeController get homeC => Get.find();

  RxInt selectedTab = RxInt(0);
  var isLoading = true.obs;
  var name = "".obs;
  var photo = "".obs;
  var id = 0.obs;
  var levelJabatan = "".obs;
  var countProject = 0.obs;
  var countBacklog = "".obs;
  var countToday = "".obs;
  var countInstraction = "".obs;

  var listProject = RxList<Project>([]);
  var listSquadModel = RxList<SquadModel>([]);
  var refreshController = RefreshController(initialRefresh: false);
  var listProjectIds = RxList<String>([]);
  var listProjectString = RxString("");

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;

    if (!kIsWeb) {
      await GlobalController.to.checkConnection();
    } else {
      NotificationService.requestPermissionWeb();
    }

    id.value = await HiveServices.box.get('id');
    photo.value = await HiveServices.box.get("photo");
    name.value = await HiveServices.box.get("name");
    levelJabatan.value = await HiveServices.box.get("level_jabatan");

    selectedTab.value = (HiveServices.getHomeTab() ?? false) ? 1 : 0;

    await getData();
    if (levelJabatan.value == "supervisor" ||
        levelJabatan.value == "managerial") {
      await getAllMySquad();
    }

    isLoading.value = false;
  }

  @override
  void onReady() {
    super.onReady();
    authCheck();
  }

  Future<void> authCheck() async {
    if (HiveServices.box.get("isLogin") != true) {
      Timer(const Duration(seconds: 1), () {
        Get.offNamed(AppRoutes.loginRoute);
      });
    }
  }

  void onPanUpdate(DragUpdateDetails update) {
    if (update.delta.dx < 0) {
      onTapMyProject();
    }

    if (update.delta.dx > 0) {
      onTapMySquad();
    }
  }

  void onTapMyProject() async {
    selectedTab.value = 1;
    await HiveServices.setHomeTab(isMyproject: true);
  }

  void onTapMySquad() async {
    selectedTab.value = 0;
    await HiveServices.setHomeTab(isMyproject: false);
  }

  void onRefresh() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!kIsWeb) {
      await GlobalController.to.checkConnection();
    }

    try {
      getData();
      if (levelJabatan.value == "supervisor" ||
          levelJabatan.value == "managerial") {
        getAllMySquad();
      }
      refreshController.refreshCompleted();
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      refreshController.refreshFailed();
    }
  }

  onReload() async {
    getData();
    if (levelJabatan.value == "supervisor" ||
        levelJabatan.value == "managerial") {
      getAllMySquad();
    }
  }

  Future<void> getData() async {
    HomeResponseModel response = await HomeRepository.getData(
      id: id.value,
    );
    if (response.statusCode == 200) {
      countBacklog.value = response.data!.count!.backlog ?? "";
      countToday.value = response.data!.count!.today ?? "";
      countInstraction.value = response.data!.count!.instruction ?? "";

      listProject.value = response.data!.project!;

      if (listProject.isNotEmpty) {
        for (var project in listProject) {
          listProjectIds.add("${project.mProjectId}");
        }

        ///ex [1, 2, 3, 4, 5]
        var projectIdsString = listProjectIds.toList().toString();

        ///ex 1, 2, 3, 4, 5
        var projectIdsStringRemovedCurlyBracket =
            projectIdsString.replaceAll(RegExp(r'[\[\]]'), '');

        ///ex 1,2,3,4,5
        listProjectString.value =
            projectIdsStringRemovedCurlyBracket.replaceAll(' ', '');
      }

      if (!kIsWeb) {
        if (GlobalController.to.appBadgeSupported.value == "Supported") {
          if (countToday.value.isEmpty) {
            FlutterAppBadger.removeBadge();
          } else {
            FlutterAppBadger.updateBadgeCount(int.parse(countToday.value));
          }
        }
      }
    } else {
      DialogServices.generalSnackbar(
        context: Get.context!,
        message: response.message ?? '',
        dialogType: PanaraDialogType.warning,
      );
    }
  }

  Future<void> getAllMySquad() async {
    var res = await HomeRepository.getAllSquadModel(
      userId: id.value.toString(),
    );

    if (res.statusCode != 200) {
      log(res.message.toString());
      return;
    }

    var data = res.data;
    if (data != null || data != []) {
      listSquadModel.value = data!;
    }

    if (data == null || data == []) {
      log(data.toString());
    }
  }
}
