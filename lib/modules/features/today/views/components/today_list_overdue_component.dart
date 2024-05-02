import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/modules/features/today/controllers/today_controller.dart';
import 'package:timebox/modules/global_controllers/issue_controller.dart';
import 'package:timebox/shared/widgets/card_list_issue_widget.dart';
import 'package:timebox/shared/widgets/card_list_timebox_widget.dart';

class TodayListOverdueComponent extends StatelessWidget {
  TodayListOverdueComponent({super.key});

  final controller = TodayController.to;
  final controllerIssue = IssueController.issueC;

  @override
  Widget build(BuildContext context) {
    FToast fToast = FToast();
    fToast.init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (controller.listTodayTimeboxOverdue.isNotEmpty == true ||
            controller.listTodayIssueOverdue.isNotEmpty == true) ...[
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 25,
            ),
            child: Text(
              "Overdue",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.f15BlackTextW500,
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

        /// Timebox
        if (controller.listTodayTimeboxOverdue.isNotEmpty == true) ...[
          ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 17),
              itemCount: controller.listTodayTimeboxOverdue.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                var timebox = controller.listTodayTimeboxOverdue[index]!;

                return CardListTimeboxWidget(
                  key: ValueKey("OverdueTimebox$index"),
                  id: timebox.id ?? 0,
                  userId: controller.id.value,
                  assigneBy: timebox.userAuthId ?? 0,
                  createdBy: timebox.createdBy ?? 0,
                  projectId: timebox.mProjectId ?? 0,
                  from: "today",
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
                  createdName: timebox.creatorName ?? "",
                  isAccept: timebox.isAccept ?? "0",
                  isSlide: (controller.id.value == timebox.createdBy!)
                      ? true
                      : false,
                  isOverdue: true,
                  acceptanceDone: timebox.acceptanceDone ?? 0,
                  acceptanceAll: timebox.acceptanceAll ?? 0,
                  fToast: fToast,
                  assignToName: timebox.assigneName ?? "",
                  assignePhoto: timebox.assignePhoto ?? "",
                  instructionStatus: timebox.instructionStatus ?? "1",
                  isInstruction: timebox.isInstruction ?? false,
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
              })
        ],

        /// Space Issue
        if (controller.listTodayIssueOverdue.isNotEmpty == true) ...[
          if (controller.listTodayTimeboxOverdue.isNotEmpty == true) ...[
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
            itemCount: controller.listTodayIssueOverdue.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              var issue = TodayController.to.listTodayIssueOverdue[index]!;

              return CardListIssueWidget(
                key: ValueKey("overdueIssue$index"),
                from: "today",
                name: issue.name ?? "",
                point: issue.point ?? "0",
                project: issue.projectName ?? "0",
                date: issue.duedate ?? "No Date",
                type: issue.type ?? "0",
                dayType: issue.dayType ?? "0",
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
          )
        ],
      ],
    );
  }
}
