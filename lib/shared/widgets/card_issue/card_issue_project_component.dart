import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/modules/features/home/models/home_model.dart';
import 'package:timebox/modules/features/home/models/squad_res/squad_model.dart';
import 'package:timebox/modules/features/home/models/squad_res/squad_new.dart';
import 'package:timebox/modules/global_controllers/global_controller.dart';
import 'package:timebox/modules/global_controllers/issue_controller.dart';
import 'package:timebox/utils/services/api_service.dart';
import 'package:timebox/utils/services/dialog_service.dart';
import 'package:timebox/utils/services/hive_service.dart';

class CardIssueProjectComponent extends StatefulWidget {
  const CardIssueProjectComponent({
    super.key,
    required this.enabled,
  });

  final bool enabled;

  @override
  State<CardIssueProjectComponent> createState() =>
      _CardIssueProjectComponentState();
}

class _CardIssueProjectComponentState extends State<CardIssueProjectComponent> {
  Rx<List<Project>> dataList = Rx([]);
  RxList<Project> dataListProjectAssign = RxList([]);
  bool isAlready = false;

  bool loadingProjectAssignee = false;

  void getProjectList({bool? force}) async {
    if (!isAlready || force == true) {
      String id = HiveServices.box.get('id').toString();

      final Dio dio = ApiServices.dioCall(
        baseUrl: GlobalController.getGlobalBaseUrl,
      );

      String url = "api/v1/mobile/timebox-home?user_auth_id=";
      var response = await dio.get(url + id);
      var models = Project.fromJsonList(
        response.data['data']['project'],
      );

      setState(() {
        isAlready = true;
        dataList.value = models;
      });
    }
  }

  Future<bool> filterAssignee({required String projectId}) async {
    final Dio dio = ApiServices.dioCall(
      baseUrl: GlobalController.getGlobalBaseUrl,
    );

    String urlSquad = "api/v2/timebox-project";

    var response = await dio.get(
      urlSquad,
      queryParameters: {
        'm_project_id': projectId == '0' ? null : projectId,
        'nama': '',
        'page': 1,
      },
    );

    var models = SquadModelNew.fromJson(response.data["data"]);
    var selectedAssignee = controller.assigneName.value.trim();
    if (models.data != null) {
      SquadNew? selectedAssigneExist = models.data?.firstWhereOrNull(
        (element) => element.namaUser == selectedAssignee,
      );

      if (selectedAssigneExist == null) {
        controller.isLoading.value = true;
        if (controller.isLoading.value) {
          showDialog(
            barrierDismissible: false,
            context: Get.context!,
            builder: (context) {
              return const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(),
                  )
                ],
              );
            },
          );
        }

        await Future.delayed(const Duration(seconds: 1));
        controller.isLoading.value = false;
        Get.back();

        DialogServices.generalSnackbar(
          context: Get.context!,
          message: '$selectedAssignee tidak masuk ke projek ini',
          dialogType: PanaraDialogType.warning,
          onTap: () {
            Get.back();
          },
        );
        return false;
      }

      return true;
    }

    return false;
  }

  final controller = IssueController.issueC;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(
        () => controller.isLoading.value == true
            ? const Center(
                child: SizedBox(),
              )
            : InkWell(
                hoverColor: Colors.transparent,
                onTap: () async {
                  if (widget.enabled) {
                    getProjectList(force: true);
                    Project? data = await showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isDismissible: true,
                      isScrollControlled: true,
                      builder: (context) => Obx(
                        () => dataListProjectAssign.isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: ListProjectBottomSheet(
                                    dataList: dataListProjectAssign),
                              )
                            : Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: ListProjectBottomSheet(
                                    dataList: dataList.value),
                              ),
                      ),
                    );

                    if (controller.assigneName.trim().isNotEmpty ||
                        controller.authId.value != 0) {
                      if (data?.mProjectId.toString() != "0" &&
                          data?.mProjectId.toString() != null) {
                        if (!await filterAssignee(
                          projectId: data?.mProjectId.toString() ?? "0",
                        )) {
                          data = Project(
                            name: '',
                            countTimebox: 0,
                            mProjectId: 0,
                          );
                        }
                      }
                    }

                    if (data != null) {
                      controller.onChangeProject(data);
                      controller.nameFocusNode.requestFocus();
                    }
                  }
                },
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: const Icon(
                        Icons.home_repair_service_outlined,
                        color: AppColors.greyText,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.projectName.value == "0"
                            ? 'Select Project'
                            : controller.projectName.value,
                        style: controller.projectName.value == "0"
                            ? AppTextStyle.f11GreyTextW400
                            : AppTextStyle.f11BlackW400,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.enabled)
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: const Icon(
                          Icons.arrow_drop_down_outlined,
                          color: AppColors.greyText,
                          size: 20,
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}

class ListProjectBottomSheet extends StatefulWidget {
  const ListProjectBottomSheet({
    super.key,
    required this.dataList,
  });

  final List<Project> dataList;

  @override
  State<ListProjectBottomSheet> createState() => _ListProjectBottomSheetState();
}

class _ListProjectBottomSheetState extends State<ListProjectBottomSheet> {
  Rx<List<Project>> dataList = Rx([]);
  RxString search = ''.obs;
  bool isDefine = false;

  void searchImply(String search) {
    dataList.value = widget.dataList
        .where((element) => element.name!.isCaseInsensitiveContains(search))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (!isDefine) {
      dataList.value = widget.dataList;
    }
    return Container(
      width: double.infinity,
      height: MediaQuery.sizeOf(context).height * (1 / 2.2),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.only(
        top: 25,
        right: 25,
        left: 25,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 57,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: Text(
              'Select project',
              textAlign: TextAlign.left,
              style: AppTextStyle.f18BlackW400.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            style: AppTextStyle.f14BlackTextW400,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(12),
              hintText: 'Search My Project...',
              hintStyle: AppTextStyle.f14GreyTextW400,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: AppColors.greyBorder,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  color: AppColors.grey,
                  width: 1,
                ),
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.greyBorder,
                size: 18,
              ),
            ),
            onChanged: (value) {
              searchImply(value);
            },
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Obx(
                () => ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 25),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: index == 0,
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () => Get.back(
                                  result: Project(
                                    name: '',
                                    countTimebox: 0,
                                    mProjectId: 0,
                                  ),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.all(12),
                                  child: const Text(
                                    'Unassigned',
                                    style: AppTextStyle.f14BlackTextW500,
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 1,
                                color: AppColors.greyDivider,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.back(result: dataList.value[index]);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              dataList.value[index].name.toString(),
                              style: AppTextStyle.f14BlackTextW400,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    color: AppColors.greyDivider,
                  ),
                  itemCount: dataList.value.length,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
