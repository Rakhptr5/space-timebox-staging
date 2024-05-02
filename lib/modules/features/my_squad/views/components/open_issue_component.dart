import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';
import 'package:timebox/modules/features/my_squad/views/components/title_list_squad_component.dart';
import 'package:timebox/shared/widgets/chip_checked_widget.dart';

import '../../../../../configs/themes/app_colors.dart';
import '../../../../../shared/widgets/card_list_issue_widget.dart';
import '../../controllers/my_squad_controller.dart';
import 'card_list_squad_timebox_widget.dart';

class OpenIssueComponent extends StatelessWidget {
  const OpenIssueComponent({
    super.key,
    required this.controller,
    required this.fToast,
  });

  final MySquadController controller;
  final FToast fToast;

  @override
  Widget build(BuildContext context) {
    RxBool isChecked = RxBool(controller.getIsAlreadyCheck());
    return Column(
      children: [
        Visibility(
          visible: controller.listTodayMySquadTimebox.isNotEmpty,
          replacement: Obx(
            () => TitleListSquadComponent.checkedAt(
              title: 'Today',
              totalPoint: (double.parse("0").toString()),
              totalIssue: '0 Issues',
              checkAtWidget: Visibility(
                visible: isChecked.value,
                child: ChipCheckedWidget(
                  checkedAt: controller.checkedAt.value,
                ),
              ),
            ),
          ),
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.listTodayMySquadTimebox.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                var indexData = controller.listTodayMySquadTimebox[index];
                return Column(
                  children: [
                    TitleListSquadComponent.checkedAt(
                      title: 'Today',
                      totalPoint: controller.getPoint(indexData),
                      totalIssue: controller.getTotalIssue(),
                      checkAtWidget: Obx(
                        () => Visibility(
                          visible: isChecked.value,
                          child: ChipCheckedWidget(
                            checkedAt: controller.checkedAt.value,
                          ),
                        ),
                      ),
                    ),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      itemCount: controller.listTodayMySquadTimebox != [] &&
                              controller.listTodayMySquadTimebox.isNotEmpty
                          ? controller.listTodayMySquadTimebox.first.modelData
                                  ?.length ??
                              0
                          : 0,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var indexData = controller
                            .listTodayMySquadTimebox.first.modelData?[index];

                        return CardListSquadTimeboxWidget(
                          id: indexData?.id ?? 0,
                          userId: controller.id.value,
                          assigneBy: 0,
                          createdBy: indexData?.createdBy ?? 0,
                          projectId: indexData?.mProjectId ?? 0,
                          from: "today",
                          name: indexData?.name ?? '-',
                          description: indexData?.description ?? '',
                          point: indexData?.point ?? '0.00',
                          date: indexData?.duedate ?? DateTime.now().toString(),
                          status: indexData?.status ?? '0',
                          statusDay: "1",
                          pointName: "2:0",
                          dateName: "No Date",
                          projectName: indexData?.projectName ?? '-',
                          repeat: "",
                          assigneName: "assign",
                          createdName: indexData?.creatorName ?? "-",
                          assignePhoto: '',
                          isAccept: "0",
                          acceptanceDone: 1,
                          acceptanceAll: 0,
                          withProject: true,
                          fToast: fToast,
                          progressPercentage: 0,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Divider(
                            height: 1,
                            color: AppColors.greyDivider,
                          ),
                        );
                      },
                    ),
                    if (controller.listTodayMySquadTimebox.isNotEmpty) ...[
                      if (controller.listTodayMySquadTimebox.first
                              .modelDataIssueSpace !=
                          []) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Divider(
                            height: 1,
                            color: AppColors.greyDivider,
                          ),
                        ),
                      ],
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        itemCount: indexData.modelDataIssueSpace?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          var issue = controller.listTodayMySquadTimebox.first
                              .modelDataIssueSpace?[index];

                          return CardListIssueWidget(
                            // key: ValueKey("Issue$index"),
                            from: "today",
                            name: issue?.name ?? "",
                            point: issue?.point.toString() ?? "0",
                            project: issue?.projectName ?? "",
                            date: "Today",
                            type: issue?.type ?? "",
                            dayType: "1",
                            status: issue?.mProjectStatus ?? "1",
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Divider(
                              height: 1,
                              color: AppColors.greyDivider,
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                );
              }),
        ),
        const SizedBox(
          height: DimensionConstant.pixel10,
        ),
        Obx(
          () => Visibility(
            visible: !controller.isButtonCheckDisable.value,
            child: ElevatedButton(
              onPressed: () {
                controller.onTapCheckIn();
                isChecked.value = !isChecked.value;
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: DimensionConstant.pixel19,
                ),
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    DimensionConstant.pixel8,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Check',
                    style: AppTextStyle.f14WhiteW400.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
