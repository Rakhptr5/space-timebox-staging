import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/modules/global_controllers/issue_controller.dart';
import 'package:timebox/shared/customs/time_picker_custom.dart';
import 'package:timebox/shared/widgets/card_issue/card_issue_acceptance_component.dart';
import 'package:timebox/shared/widgets/card_issue/card_issue_assigne_component.dart';
import 'package:timebox/shared/widgets/card_issue/card_issue_date_component.dart';
import 'package:timebox/shared/widgets/card_issue/card_issue_description_component.dart';
import 'package:timebox/shared/widgets/card_issue/card_issue_name_component.dart';
import 'package:timebox/shared/widgets/card_issue/card_issue_project_component.dart';

class CardIssueWidget extends StatelessWidget {
  const CardIssueWidget({
    super.key,
    required this.from,
    required this.id,
    this.assigneName = "",
    required this.name,
    required this.description,
    required this.date,
    required this.dateName,
    required this.pointJam,
    required this.projectId,
    required this.projectName,
    required this.repeat,
    this.createdName = "",
    this.readOnly = false,
    this.assignePhoto = "",
    this.acceptanceDone = 0,
    this.authId = 0,
    this.myId = 0,
    this.createdBy = 0,
    this.userAuthId,
    this.onTapUpdateAcceptanceStatus,
    this.onCreatedAcceptance,
    this.onSuccesSaveData,
    this.isEdit = false,
  });

  final int id;
  final String from;
  final int? userAuthId;
  final int authId, myId, createdBy, projectId;
  final DateTime date;
  final String name, description, dateName, projectName, createdName;
  final String assigneName, assignePhoto;
  final String pointJam;
  final String repeat;
  final bool readOnly;
  final bool isEdit;
  final int acceptanceDone;
  final Function()? onTapUpdateAcceptanceStatus;
  final Function()? onCreatedAcceptance;
  final Function()? onSuccesSaveData;

  @override
  Widget build(BuildContext context) {
    var controller = IssueController.issueC;

    /// Setting toast
    FToast fToast = FToast();
    fToast.init(context);

    controller.acceptanceDone.value = acceptanceDone;

    /// Setting open card
    if (controller.isFrist.value == false) {
      /// Setting project id, id and frist open
      controller.isFrist.value = true;
      controller.id.value = id;
      controller.projectId.value = projectId;
      controller.projectName.value = projectName;
      controller.authId.value = authId;
      controller.assigneName.value = assigneName;
      controller.assignePhoto.value = assignePhoto;
      controller.acceptanceDone.value = acceptanceDone;

      /// Setting point
      var point = pointJam.split(":");
      if (point[1] == "0") {
        controller.pointName.value = point[0];
      } else {
        controller.pointName.value = "${point[0]}.${point[1]}";
      }

      controller.pointHour.value = point[0];
      controller.pointMinute.value = point[1];

      /// Setting repeat
      controller.repeatName.value = repeat == "" ? "No Repeat" : repeat;

      /// Setting date & hour
      controller.date.value = date;
      controller.dateName.value = dateName;
      if (id != 0) {
        if (dateName != "No Date") {
          if (date.hour == 0 && date.minute == 0) {
            controller.hourName.value = "Setting Jam";
          } else {
            controller.hourName.value = "${date.hour}:${date.minute}";
          }
        }
      }

      /// Setting text Controller
      controller.nameTextController.text = name;
      controller.descriptionTextController.text = description;
    }

    if (from == "project" || from == "mySquad") {
      controller.showAssignee.value = true;
    }

    if (id != 0) {
      controller.getAcceptance(
        id: id,
      );
    }

    DateTime? loginClickTime;
    DateTime dateTime = DateTime.now();

    bool isRedundentClick() {
      if (loginClickTime == null) {
        loginClickTime = dateTime;
        return false;
      }

      if (dateTime.difference(loginClickTime!).inSeconds < 10) {
        // set this difference time in seconds
        return true;
      }

      loginClickTime = dateTime;
      return false;
    }

    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// Name
              CardIssueNameComponent(
                from: from,
                readOnly: readOnly,
                onSuccess: onSuccesSaveData,
                isEdit: isEdit,
                onError: () {},
              ),
              const SizedBox(height: 15),

              /// Description
              CardIssueDescriptionComponent(
                readOnly: readOnly,
              ),
              const SizedBox(height: 15),

              /// Date & Point
              controller.isLoading.value
                  ? const SizedBox()
                  : Row(
                      children: [
                        CupertinoButton(
                          minSize: 35,
                          color: AppColors.bgColorGrey,
                          padding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 15,
                          ),
                          onPressed: (readOnly)
                              ? null
                              : () {
                                  controller.nameFocusNode.unfocus();
                                  IssueController.issueC.descriptionFocusNode
                                      .unfocus();

                                  Get.bottomSheet(
                                    ignoreSafeArea: true,
                                    isScrollControlled: true,
                                    persistent: false,
                                    enableDrag: false,
                                    CardIssueDateComponent(),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(
                                          20,
                                        ),
                                      ),
                                    ),
                                    backgroundColor: Colors.white,
                                  );
                                },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.insert_invitation_outlined,
                                size: 15,
                                color: AppColors.greyText,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                controller.dateName.value,
                                style: AppTextStyle.f12GreyTextW400,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CupertinoButton(
                          minSize: 35,
                          color: AppColors.bgColorGrey,
                          padding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 15,
                          ),
                          onPressed: (readOnly)
                              ? null
                              : () {
                                  controller.nameFocusNode.unfocus();
                                  IssueController.issueC.descriptionFocusNode
                                      .unfocus();

                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (_) => Container(
                                      padding: const EdgeInsets.all(
                                        10,
                                      ),
                                      margin: EdgeInsets.zero,
                                      height: 350,
                                      decoration: const BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(
                                            20,
                                          ),
                                          topLeft: Radius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TimePickerCustom(
                                              key: const ValueKey("hour"),
                                              isHour: true,
                                              initial: int.parse(
                                                IssueController
                                                    .issueC.pointHour.value,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: TimePickerCustom(
                                              key: const ValueKey("minute"),
                                              isHour: false,
                                              initial: int.parse(
                                                controller.pointMinute.value,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.share_arrival_time_outlined,
                                size: 15,
                                color: AppColors.greyText,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                controller.pointName.value,
                                style: AppTextStyle.f12GreyTextW400,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CupertinoButton(
                          minSize: 35,
                          color: AppColors.bgColorGrey,
                          padding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 10,
                          ),
                          onPressed: (readOnly)
                              ? null
                              : () {
                                  const List<String> listRepeat = <String>[
                                    '-',
                                    'daily',
                                    'weekly',
                                  ];

                                  int initial = 0;
                                  if (IssueController.issueC.repeatName.value ==
                                      "daily") {
                                    initial = 1;
                                  } else if (IssueController
                                          .issueC.repeatName.value ==
                                      "weekly") {
                                    initial = 2;
                                  }

                                  showCupertinoModalPopup(
                                    context: context,
                                    builder: (_) => Container(
                                      padding: const EdgeInsets.all(
                                        10,
                                      ),
                                      margin: EdgeInsets.zero,
                                      height: 350,
                                      decoration: const BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(
                                            20,
                                          ),
                                          topLeft: Radius.circular(
                                            20,
                                          ),
                                        ),
                                      ),
                                      child: CupertinoPicker(
                                        magnification: 1.22,
                                        squeeze: 1.2,
                                        useMagnifier: true,
                                        itemExtent: 32,
                                        onSelectedItemChanged:
                                            (int selectedItem) {
                                          if (selectedItem == 1) {
                                            controller.repeatName.value =
                                                "daily";
                                          } else if (selectedItem == 2) {
                                            IssueController.issueC.repeatName
                                                .value = "weekly";
                                          } else {
                                            IssueController.issueC.repeatName
                                                .value = "No Repeat";
                                          }
                                        },
                                        scrollController:
                                            FixedExtentScrollController(
                                          initialItem: initial,
                                        ),
                                        children: List<Widget>.generate(
                                          listRepeat.length,
                                          (int index) {
                                            return Center(
                                              child: Text(
                                                listRepeat[index],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.repeat_outlined,
                                color: AppColors.greyText,
                                size: 15,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                controller.repeatName.value,
                                style: AppTextStyle.f15GreyTextW400,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

              const SizedBox(height: 15),
              const Divider(
                height: 1,
                color: AppColors.greyDivider,
              ),
              const SizedBox(height: 15),

              /// Acceptance
              // if (id != 0) ...[
              // ],

              controller.isAcceptenceLoading.value
                  ? const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Title Acceptances
                        if (!readOnly && id != 0) ...[
                          SizedBox(
                            width: double.infinity,
                            child: controller.listAcceptance.isEmpty
                                ? Text(
                                    'Acceptances',
                                    style: AppTextStyle.f13GreyTextW400
                                        .copyWith(fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.left,
                                  )
                                : Text(
                                    'Acceptances ${controller.acceptanceDone.value}/${controller.listAcceptance.length}',
                                    style: AppTextStyle.f13GreyTextW400
                                        .copyWith(fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.left,
                                  ),
                          ),
                        ] else ...[
                          controller.listAcceptance.isEmpty
                              ? const SizedBox()
                              : Text(
                                  'Acceptances ${controller.acceptanceDone.value}/${controller.listAcceptance.length}',
                                  style: AppTextStyle.f13GreyTextW400
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                        ],

                        /// List Acceptance
                        if (id == 0) ...[
                          controller.temptListAcceptance.isEmpty
                              ? const SizedBox()
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  itemCount:
                                      controller.temptListAcceptance.length,
                                  itemBuilder: (context, index) {
                                    return CardIssueAcceptanceComponent(
                                      id: controller
                                              .temptListAcceptance[index]?.id ??
                                          0,
                                      timeboxId: id,
                                      status: controller
                                              .temptListAcceptance[index]
                                              ?.status ??
                                          '0',
                                      name: controller
                                              .temptListAcceptance[index]
                                              ?.name ??
                                          '',
                                      readOnly: readOnly,
                                      vivibleButton:
                                          (authId != myId && createdBy != myId)
                                              ? false
                                              : true,
                                      controller: TextEditingController(
                                        text: controller
                                                .temptListAcceptance[index]
                                                ?.name ??
                                            '',
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 15);
                                  },
                                ),
                        ] else ...[
                          controller.listAcceptance.isEmpty
                              ? const SizedBox()
                              : ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  itemCount: controller.listAcceptance.length,
                                  itemBuilder: (context, index) {
                                    return CardIssueAcceptanceComponent(
                                      onTapUpdateAcceptance:
                                          onTapUpdateAcceptanceStatus,
                                      id: controller.listAcceptance[index]!.id!,
                                      timeboxId: id,
                                      status: controller
                                          .listAcceptance[index]!.status!,
                                      name: controller
                                          .listAcceptance[index]!.name!,
                                      readOnly: readOnly,
                                      vivibleButton:
                                          (authId != myId && createdBy != myId)
                                              ? false
                                              : true,
                                      controller: TextEditingController(
                                        text: controller
                                            .listAcceptance[index]!.name!,
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(height: 15);
                                  },
                                ),
                        ],

                        /// Add Acceptance
                        if (readOnly == false) ...[
                          controller.listAcceptance.isEmpty
                              ? const SizedBox(height: 15)
                              : const SizedBox(),
                          CardIssueAddAcceptanceComponent(
                            id: id,
                            onCreatedAcceptance: onCreatedAcceptance,
                          ),
                        ]
                      ],
                    ),
              readOnly ? const SizedBox() : const SizedBox(height: 15),

              //Save
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CardIssueProjectComponent(
                        enabled: (readOnly == true)
                            ? false
                            : (from == "project")
                                ? false
                                : true,
                      ),
                      if (from != "mySquad_instruction") ...[
                        const SizedBox(width: 20),
                        CardIssueAssigneComponent(
                          enabled: (readOnly == true)
                              ? false
                              : (from == "mySquad")
                                  ? false
                                  : true,
                        ),
                        const SizedBox(width: 20),
                      ] else ...[
                        const Spacer(),
                        const SizedBox(width: 20),
                      ],
                      CupertinoButton(
                        minSize: 35,
                        color: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 10,
                        ),
                        onPressed: (readOnly)
                            ? null
                            : () {
                                dateTime = DateTime.now();
                                if (isRedundentClick()) {
                                  return;
                                }
                                dateTime = DateTime.now();
                                controller.descriptionFocusNode.unfocus();
                                controller.saveData(
                                  onSuccess: () => onSuccesSaveData,
                                  id: controller.id.value,
                                  projectId: controller.projectId.value,
                                  userId: from == "mySquad_instruction"
                                      ? userAuthId
                                      : myId,
                                  name: IssueController
                                      .issueC.nameTextController.text,
                                  description: IssueController
                                      .issueC.descriptionTextController.text,
                                  date: controller.date.value,
                                  dateName: controller.dateName.value,
                                  from: from,
                                  point:
                                      "${controller.pointHour.value}:${controller.pointMinute.value}",
                                  repeat: controller.repeatName.value,
                                  fToast: fToast,
                                );
                              },
                        child: const Icon(
                          Icons.send_sharp,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  if (readOnly) ...[
                    const SizedBox(height: 15),
                    Text(
                      "Creator : $createdName",
                      style: AppTextStyle.f12GreyW400,
                    )
                  ],
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
