import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timebox/modules/features/instruction/repositories/instruction_repository.dart';
import 'package:timebox/modules/features/my_squad/models/list_my_squad_model.dart';
import 'package:timebox/modules/global_controllers/global_controller.dart';
import 'package:timebox/utils/services/dialog_service.dart';
import 'package:timebox/utils/services/hive_service.dart';

class InstructionController extends GetxController {
  static InstructionController get to => Get.find();

  var isLoading = true.obs;
  var isByProject = false.obs;

  var id = 0.obs;
  var name = "".obs;
  var photo = "".obs;

  var listData = <MySquadInstruction?>[].obs;
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
    photo.value = await HiveServices.box.get("photo");

    if (await HiveServices.box.get("instructionIsByProject") == null) {
      isByProject.value = true;
      await HiveServices.box.put("instructionIsByProject", true);
    } else {
      if (await HiveServices.box.get("instructionIsByProject") == false) {
        isByProject.value = false;
        await HiveServices.box.put("instructionIsByProject", false);
      } else {
        isByProject.value = true;
        await HiveServices.box.put("instructionIsByProject", true);
      }
    }

    await getData();

    isLoading.value = false;
  }

  void onRefresh() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!kIsWeb) {
      await GlobalController.to.checkConnection();
    }

    try {
      await getData();

      isLoading.value = false;
      refreshController.refreshCompleted();
    } catch (e) {
      isLoading.value = false;
      refreshController.refreshFailed();
    }
  }

  Future<void> onReload() async {
    await getData();
  }

  Future<void> getData() async {
    if (!isByProject.value) {
      ListMySquadModel response = await InstructionRepository.getDataDate(
        userAuthId: id.value.toString(),
        status: "1",
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
    } else {
      ListMySquadModel response = await InstructionRepository.getDataProject(
        userAuthId: id.value.toString(),
        status: "1",
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
}
