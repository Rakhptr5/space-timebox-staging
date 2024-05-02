import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/modules/features/upcoming/controllers/upcoming_controller.dart';
import 'package:timebox/shared/widgets/card_list_issue_widget.dart';
import 'package:timebox/shared/widgets/card_list_timebox_widget.dart';

class UpcomingListComponent extends StatelessWidget {
  UpcomingListComponent({super.key});
  final controller = UpcomingController.upcomingC;

  @override
  Widget build(BuildContext context) {
    FToast fToast = FToast();
    fToast.init(context);

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (controller.listTimebox.isNotEmpty) ...[
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 17),
                itemCount: controller.listTimebox.length,
                itemBuilder: (context, index) {
                  var timebox = controller.listTimebox[index]!;

                  return CardListTimeboxWidget(
                    key: ValueKey("Timebox$index"),
                    id: timebox.id ?? 0,
                    userId: controller.id.value,
                    assigneBy: timebox.userAuthId ?? 0,
                    createdBy: timebox.createdBy ?? 0,
                    projectId: timebox.mProjectId ?? 0,
                    from: "upcoming",
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
                    acceptanceDone: timebox.acceptanceDone ?? 0,
                    acceptanceAll: timebox.acceptanceAll ?? 0,
                    fToast: fToast,
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
                },
              ),
            ],
            if (controller.listIssue.isNotEmpty) ...[
              if (controller.listTimebox.isNotEmpty) ...[
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
                itemCount: controller.listIssue.length,
                itemBuilder: (BuildContext context, int index) {
                  var issue = controller.listIssue[index]!;

                  return CardListIssueWidget(
                    key: ValueKey("Issue$index"),
                    from: "upcoming",
                    name: issue.name ?? "",
                    point: issue.point ?? "0",
                    project: issue.projectName ?? "0",
                    date: issue.duedate ?? "No Date",
                    type: issue.type ?? "0",
                    dayType: issue.dayType ?? "0",
                    status: issue.mProjectStatus ?? "1",
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
        ),
      ),
    );
  }
}