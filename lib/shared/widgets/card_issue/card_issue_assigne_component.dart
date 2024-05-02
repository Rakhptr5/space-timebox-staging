import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';
import 'package:timebox/modules/features/home/controllers/home_controller.dart';
import 'package:timebox/modules/global_controllers/issue_controller.dart';
import 'package:timebox/utils/services/dialog_service.dart';

import '../../../modules/features/home/models/squad_res/squad_model.dart';
import '../../../modules/features/home/models/squad_res/squad_new.dart';
import '../../../modules/global_controllers/global_controller.dart';
import '../../../utils/services/api_service.dart';

class CardIssueAssigneComponent extends StatefulWidget {
  const CardIssueAssigneComponent({
    super.key,
    required this.enabled,
  });

  final bool enabled;

  @override
  State<CardIssueAssigneComponent> createState() =>
      _CardIssueAssigneComponentState();
}

class _CardIssueAssigneComponentState extends State<CardIssueAssigneComponent> {
  Rx<List<SquadNew>> dataList = Rx([]);
  bool isAlready = false;
  final controller = IssueController.issueC;

  void getAssignList({bool? force}) async {
    if (!isAlready || force == true) {
      String id = controller.projectId.value.toString();

      final Dio dio = ApiServices.dioCall(
        baseUrl: GlobalController.getGlobalBaseUrl,
      );

      String urlSquad = "api/v2/timebox-project";

      var projectIdString = "";
      if (Get.isRegistered<HomeController>()) {
        projectIdString = HomeController.homeC.listProjectString.value;
      }

      var response = await dio.get(
        urlSquad,
        queryParameters: {
          'm_project_id': id == '0' ? null : id,
          'nama': '',
          'page': 1,
          if (projectIdString.isNotEmpty && id == '0')
            "all_project": projectIdString,
        },
      );

      var models = SquadModelNew.fromJson(response.data["data"]);

      setState(() {
        isAlready = true;
        dataList.value = models.data!;

        /// add dataList here
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value == true
          ? const SizedBox()
          : Expanded(
              child: InkWell(
                hoverColor: Colors.transparent,
                onTap: () async {
                  if (widget.enabled) {
                    getAssignList(force: true);
                    SquadNew? data = await showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      useSafeArea: true,
                      isScrollControlled: true,
                      isDismissible: true,
                      builder: (context) => Obx(
                        () => Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child:
                              AssignListBottomsheet(dataList: dataList.value),
                        ),
                      ),
                    );

                    if (data != null) {
                      controller.onChangeAssigne(data);
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
                      child: controller.assigneName.value.isEmpty
                          ? const Icon(
                              Icons.people_alt_outlined,
                              size: 20,
                              color: AppColors.greyText,
                            )
                          : CachedNetworkImage(
                              imageUrl: controller.assignePhoto.value,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 20,
                                height: 20,
                                padding: const EdgeInsets.all(5),
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 20,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        controller.assigneName.value.isEmpty
                            ? 'Select Assignee'
                            : controller.assigneName.value,
                        style: controller.assigneName.value.isEmpty
                            ? AppTextStyle.f12GreyThroughW400
                            : AppTextStyle.f12BlackTextW400,
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

class AssignListBottomsheet extends StatefulWidget {
  const AssignListBottomsheet({
    super.key,
    required this.dataList,
  });

  final List<SquadNew> dataList;
  @override
  State<AssignListBottomsheet> createState() => _AssignListBottomsheetState();
}

class _AssignListBottomsheetState extends State<AssignListBottomsheet> {
  Rx<List<SquadNew>> dataList = Rx([]);
  RxString search = ''.obs;
  bool isDefine = false;
  final controller = IssueController.issueC;

  void searchImply({String? name}) async {
    String id = controller.projectId.value.toString();

    final Dio dio = ApiServices.dioCall(
      baseUrl: GlobalController.getGlobalBaseUrl,
    );

    String urlSquad = "api/v2/timebox-project";

    var projectIdString = "";
    if (Get.isRegistered<HomeController>()) {
      projectIdString = HomeController.homeC.listProjectString.value;
    }

    var response = await dio.get(
      urlSquad,
      queryParameters: {
        'm_project_id': id == '0' ? null : id,
        'nama': name,
        'page': 1,
        if (projectIdString.isNotEmpty && id == '0')
          "all_project": projectIdString,
      },
    );

    var models = SquadModelNew.fromJson(response.data["data"]);

    setState(() {
      dataList.value = models.data!;
      isDefine = true;

      /// add dataList here
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!isDefine) {
      dataList.value = widget.dataList;
    }
    return Obx(
      () => controller.isLoading.value == true
          ? const SizedBox()
          : Container(
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
                      'Select Assignee',
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
                      hintText: 'Search My Squad...',
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
                      searchImply(name: value);
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
                              children: [
                                Visibility(
                                  visible: index == 0,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () => Get.back(
                                          result: SquadNew(
                                            namaUser: '',
                                            userAuthId: 0,
                                            humanisFoto: '',
                                          ),
                                        ),
                                        child: Container(
                                          width: double.infinity,
                                          margin: const EdgeInsets.all(12),
                                          child: Row(
                                            children: [
                                              Container(
                                                width:
                                                    DimensionConstant.pixel24,
                                                height:
                                                    DimensionConstant.pixel24,
                                                margin: const EdgeInsets.only(
                                                  right:
                                                      DimensionConstant.pixel12,
                                                ),
                                                alignment: Alignment.center,
                                                decoration: const BoxDecoration(
                                                  color: AppColors.primaryColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Text(
                                                  '-',
                                                  style:
                                                      AppTextStyle.f21WhiteW600,
                                                ),
                                              ),
                                              const Expanded(
                                                child: Text(
                                                  'Unassigned',
                                                  style: AppTextStyle
                                                      .f14BlackTextW500,
                                                ),
                                              ),
                                            ],
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
                                    if (!(dataList.value[index].haveProject ??
                                        false)) {
                                      DialogServices.generalSnackbar(
                                        context: context,
                                        message:
                                            'Assignee belum masuk ke projek manapun',
                                        dialogType: PanaraDialogType.warning,
                                      );

                                      return;
                                    }

                                    Get.back(result: dataList.value[index]);
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: dataList
                                              .value[index].humanisFoto
                                              .toString(),
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              const SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            width: 24,
                                            height: 24,
                                            padding: const EdgeInsets.all(5),
                                            decoration: const BoxDecoration(
                                              color: AppColors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.person,
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            dataList.value[index].namaUser
                                                .toString(),
                                            style:
                                                AppTextStyle.f14BlackTextW500,
                                          ),
                                        ),
                                      ],
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
            ),
    );
  }
}
