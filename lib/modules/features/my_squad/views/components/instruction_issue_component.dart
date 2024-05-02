import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';
import 'package:timebox/modules/features/my_squad/views/components/title_list_squad_component.dart';
import '../../../../../configs/themes/app_colors.dart';
import '../../controllers/my_squad_controller.dart';
import 'card_list_squad_timebox_widget.dart';

class InstructionIssueComponent extends StatelessWidget {
  const InstructionIssueComponent({
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
        TitleListSquadComponent(
          title: 'Instruction',
          totalIssue: controller.getTotalInstructionIssue(),
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 17),
          itemCount: controller.listInstructionMySquad.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            var timeboxData =
                controller.listInstructionMySquad[index].data?.timebox ?? [];
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: timeboxData.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                var timeboxIndex = timeboxData[index];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CardListSquadTimeboxWidget(
                      id: timeboxIndex.id ?? 0,
                      userId: controller.id.value,
                      userAuthId: controller.authId.value,
                      assigneBy: 0,
                      createdBy: timeboxIndex.createdBy ?? 0,
                      projectId: timeboxIndex.mProjectId ?? 0,
                      from: "instruction",
                      name: timeboxIndex.name ?? '',
                      description: timeboxIndex.description,
                      point: timeboxIndex.point ?? '0',
                      date: timeboxIndex.date ?? 'No Date',
                      status: timeboxIndex.statusText ?? '',
                      statusDay: timeboxIndex.dayType ?? '0',
                      pointName: timeboxIndex.pointJam ?? '0:0',
                      dateName: timeboxIndex.dateName ?? '0',
                      projectName: timeboxIndex.project ?? '',
                      repeat: timeboxIndex.typeRepetition ?? '',
                      assigneName: "assign",
                      createdName: timeboxIndex.creatorName ?? '',
                      assignePhoto: '',
                      isAccept: timeboxIndex.isAccept ?? '1',
                      acceptanceDone: timeboxIndex.acceptanceDone ?? 0,
                      acceptanceAll: timeboxIndex.acceptanceAll ?? 0,
                      progressPercentage: 0,
                      withProject: true,
                      fToast: fToast,
                      onTapUpdateAcceptanceStatus: () => controller.onReload(),
                      onCreatedAcceptance: () => controller.onReload(),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: DimensionConstant.pixel8),
                      child: Divider(
                        height: 1,
                        color: AppColors.greyDivider,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}
