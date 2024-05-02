import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/modules/features/project/controllers/project_controller.dart';
import 'package:timebox/modules/features/project/views/components/project_title_component.dart';
import 'package:timebox/shared/widgets/card_list_issue_widget.dart';
import 'package:timebox/shared/widgets/card_list_timebox_widget.dart';

class ProjectListComponent extends StatelessWidget {
  ProjectListComponent({super.key});
  final controller = ProjectController.projectC;

  @override
  Widget build(BuildContext context) {
    FToast fToast = FToast();
    fToast.init(context);

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: controller.listData.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ProjectTitleComponent(
              title: controller.listData[index].namaUser ?? '',
              imageUrl: controller.listData[index].humanisFoto ?? '',
              pointNum: '${controller.listData[index].countPoint ?? 0}',
              issueNum: '${controller.listData[index].countIssues ?? 0}',
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Divider(
                height: 1,
                color: AppColors.greyDivider,
              ),
            ),

            /// Timebox
            if (controller.listData[index].timebox!.isNotEmpty) ...[
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 17),
                shrinkWrap: true,
                itemCount: controller.listData[index].timebox!.length,
                itemBuilder: (context2, index2) {
                  var timebox = controller.listData[index].timebox![index2];

                  return CardListTimeboxWidget(
                    key: ValueKey("Timebox$index$index2"),
                    id: timebox.id ?? 0,
                    userId: controller.id.value,
                    assigneBy: timebox.userAuthId ?? 0,
                    createdBy: timebox.createdBy ?? 0,
                    projectId: timebox.mProjectId ?? 0,
                    from: "project",
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
                    assigneName: controller.listData[index].namaUser ?? "",
                    createdName: timebox.creatorName ?? "",
                    assignePhoto: controller.listData[index].humanisFoto ?? '',
                    isAccept: timebox.isAccept ?? "0",
                    isSlide: (controller.id.value == timebox.createdBy!)
                        ? true
                        : false,
                    acceptanceDone: timebox.acceptanceDone ?? 0,
                    acceptanceAll: timebox.acceptanceAll ?? 0,
                    withProject: false,
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

            /// Issue
            if (controller.listData[index].issues!.isNotEmpty) ...[
              if (controller.listData[index].timebox!.isNotEmpty) ...[
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
                shrinkWrap: true,
                itemCount: controller.listData[index].issues!.length,
                itemBuilder: (context2, index2) {
                  var issue = controller.listData[index].issues![index2];

                  return CardListIssueWidget(
                    key: ValueKey("Issue$index"),
                    from: "project",
                    name: issue.name ?? "",
                    point: issue.point ?? "0",
                    project: issue.projectName ?? "0",
                    date: issue.duedate ?? "No Date",
                    type: issue.type ?? "0",
                    dayType: issue.dayType ?? "0",
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
          ],
        );
      },
    );
  }
}
