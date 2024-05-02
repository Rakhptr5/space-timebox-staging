import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/modules/features/instruction/controllers/instruction_controller.dart';
import 'package:timebox/shared/widgets/card_list_issue_widget.dart';
import 'package:timebox/shared/widgets/card_list_timebox_widget.dart';

class InstructionListComponent extends StatelessWidget {
  InstructionListComponent({super.key});

  final controller = InstructionController.to;

  @override
  Widget build(BuildContext context) {
    FToast fToast = FToast();
    fToast.init(context);

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: controller.listData.length,
      itemBuilder: (context, index) {
        var listData = controller.listData[index]!.data!;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 25,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          controller.isByProject.value
                              ? controller.listData[index]!.project == "0"
                                  ? "No Project"
                                  : controller.listData[index]!.project ?? ""
                              : controller.listData[index]!.tanggalName ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.f15BlackTextW500,
                        ),
                      ),
                      if (controller.listData[index]!.tanggalName !=
                              "No Date" &&
                          !controller.isByProject.value) ...[
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "${controller.listData[index]!.point!.pointDone ?? 0}/${controller.listData[index]!.point!.pointAll ?? 0}",
                              style: AppTextStyle.f12BlackTextW500,
                            ),
                            Text(
                              "${controller.listData[index]!.point!.issueCount ?? 0} Issues",
                              style: AppTextStyle.f9BlackTextW400,
                            )
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 25,
                  ),
                  child: Divider(
                    height: 1,
                    color: AppColors.greyDivider,
                  ),
                ),
              ],
            ),
            if (listData.timebox!.isNotEmpty == true) ...[
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 17),
                itemCount: listData.timebox!.length,
                shrinkWrap: true,
                itemBuilder: (context2, index2) {
                  var timebox = listData.timebox![index2];

                  return CardListTimeboxWidget(
                    key: ValueKey("Timebox$index$index2"),
                    id: timebox.id ?? 0,
                    userId: controller.id.value,
                    assigneBy: timebox.userAuthId ?? 0,
                    createdBy: timebox.createdBy ?? 0,
                    projectId: timebox.mProjectId ?? 0,
                    from: "instruction",
                    name: timebox.name ?? "",
                    description: timebox.description ?? "0",
                    point: timebox.point ?? "0.00",
                    date: timebox.date ?? "No Date",
                    status: timebox.statusText ?? "open",
                    statusDay: timebox.dayType ?? "0",
                    pointName: timebox.pointJam ?? "0",
                    dateName: timebox.dateName ?? "No Date",
                    projectName: timebox.project ?? "0",
                    repeat: timebox.typeRepetition ?? "",
                    assigneName: controller.name.value,
                    assignePhoto: controller.photo.value,
                    createdName: timebox.creatorName ?? "",
                    isAccept: timebox.isAccept ?? "0",
                    isSlide: (controller.id.value == timebox.createdBy!)
                        ? true
                        : false,
                    acceptanceDone: timebox.acceptanceDone ?? 0,
                    acceptanceAll: timebox.acceptanceAll ?? 0,
                    withProject: controller.isByProject.value ? false : true,
                    fToast: fToast,
                    instructionStatus: timebox.instructionStatus ?? "1",
                    isInstruction: timebox.isInstruction ?? false,
                  );
                },
                separatorBuilder: (context2, index2) {
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
            if (listData.issue!.isNotEmpty == true) ...[
              if (listData.timebox!.isNotEmpty == true) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Divider(
                    height: 1,
                    color: AppColors.greyDivider,
                  ),
                ),
              ],
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 17),
                itemCount: listData.issue!.length,
                shrinkWrap: true,
                itemBuilder: (context2, index2) {
                  var issue = listData.issue![index2];

                  return CardListIssueWidget(
                    key: ValueKey("Issue$index$index2"),
                    from: "instruction",
                    name: issue.name ?? "",
                    point: issue.point ?? "0",
                    project: issue.projectName ?? "0",
                    date: issue.duedate ?? "No Date",
                    type: issue.type ?? "0",
                    dayType: issue.dayType ?? "0",
                  );
                },
                separatorBuilder: (context3, index3) {
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
      },
    );
  }
}