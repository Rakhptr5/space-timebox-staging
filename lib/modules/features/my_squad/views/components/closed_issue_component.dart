import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:timebox/modules/features/my_squad/models/my_squad_issues_space/my_squad_issues_space.dart';
import 'package:timebox/modules/features/my_squad/models/my_squad_timebox/my_squad_timebox.dart';
import 'package:timebox/modules/features/my_squad/views/components/title_list_squad_component.dart';

import '../../../../../configs/themes/app_colors.dart';
import '../../../../../constants/cores/dimension_constant.dart';
import '../../../../../shared/widgets/card_list_issue_widget.dart';
import '../../controllers/my_squad_controller.dart';
import 'card_list_squad_timebox_widget.dart';

class ClosedIssueComponent extends StatelessWidget {
  const ClosedIssueComponent({
    super.key,
    required this.controller,
    required this.fToast,
  });

  final MySquadController controller;
  final FToast fToast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<MySquadController>(
            init: controller,
            initState: (state) => controller,
            builder: (context) {
              return Column(
                children: [
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: controller.listMySquadTimebox.length,
                      itemBuilder: (context, parentIndex) {
                        var indexData =
                            controller.listMySquadTimebox[parentIndex];
                        return Column(
                          children: [
                            TitleListSquadComponent(
                              title: controller
                                  .getTitleWithDate(indexData.tanggal),
                              totalPoint: controller.getPoint(indexData),
                              totalIssue: controller.getTotalIssue(),
                              totalPointOverdue:
                                  '${controller.totalPoint.value}',
                              isClose: (num.tryParse(
                                      controller.getPoint(indexData))! <
                                  8.00),
                              isOverdue: controller.checkIsOverdue(indexData),
                            ),

                            /// Timebox Issues
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: DimensionConstant.pixel17),
                              itemCount: indexData.modelData?.length ?? 0,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var childData = indexData.modelData?[index] ??
                                    MySquadTimebox();
                                return CardListSquadTimeboxWidget(
                                  id: 0,
                                  userId: controller.id.value,
                                  assigneBy: 0,
                                  createdBy: childData.createdBy ?? 0,
                                  projectId: childData.mProjectId ?? 0,
                                  from: "today",
                                  name: childData.name ?? '-',
                                  description: childData.description ?? '',
                                  point: childData.point ?? "0.00",
                                  date: childData.duedate ?? '',
                                  status: childData.status ?? '0',
                                  statusDay: "1",
                                  pointName: "1:0",
                                  dateName: "No Date",
                                  projectName: childData.projectName ?? '-',
                                  repeat: "",
                                  assigneName: "assign",
                                  createdName: '${childData.createdBy}',
                                  assignePhoto: '',
                                  isAccept: "0",
                                  acceptanceDone: 1,
                                  acceptanceAll: 0,
                                  withProject: true,
                                  withPercentage: true,
                                  fToast: fToast,
                                  progressPercentage: childData.progress ?? 0,
                                  isOverdue:
                                      controller.checkIsOverdue(indexData),
                                  onTapDone: () =>
                                      controller.onTapChangeStatus(childData),
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

                            /// Space Issues
                            ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: DimensionConstant.pixel17),
                              shrinkWrap: true,
                              itemCount:
                                  indexData.modelDataIssueSpace?.length ?? 0,
                              itemBuilder: (context, index) {
                                var issue =
                                    indexData.modelDataIssueSpace?[index] ??
                                        MySquadIssuesSpace();
                                return CardListIssueWidget(
                                  // key: ValueKey("Issue$index"),
                                  from: "today",
                                  name: issue.name ?? "",
                                  point: issue.point.toString(),
                                  project: issue.projectName ?? "",
                                  date: "No Date",
                                  type: issue.type ?? "",
                                  dayType: "1",
                                  status: issue.mProjectStatus ?? "1",
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
                        );
                      }),
                ],
              );
            }),
      ],
    );
  }
}
