import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/constants/cores/assets_constant.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';
import 'package:timebox/modules/features/instruction/controllers/instruction_controller.dart';
import 'package:timebox/modules/features/my_squad/constant/my_squad_function.dart';
import 'package:timebox/modules/features/my_squad/controllers/my_squad_controller.dart';
import 'package:timebox/modules/global_controllers/issue_controller.dart';
import 'package:timebox/modules/global_controllers/list_issue_controller.dart';

class CardListSquadTimeboxWidget extends StatelessWidget {
  CardListSquadTimeboxWidget({
    super.key,
    required this.id,
    this.userId = 0,
    this.userAuthId,
    required this.projectId,
    this.assigneBy = 0,
    this.createdBy = 0,
    required this.from,
    required this.name,
    this.description,
    required this.point,
    required this.date,
    required this.status,
    required this.statusDay,
    required this.pointName,
    required this.dateName,
    required this.projectName,
    this.isOverdue = false,
    this.isSlide = false,
    this.isAccept = "0",
    required this.repeat,
    this.createdName = "",
    this.assigneName = "",
    this.assignePhoto = "",
    required this.acceptanceDone,
    required this.acceptanceAll,
    this.withProject = true,
    this.withPercentage = false,
    required this.fToast,
    required this.progressPercentage,
    this.onTapPercentage,
    this.onTapDone,
    this.onTapUpdateAcceptanceStatus,
    this.onCreatedAcceptance,
  });

  final int id;
  final int userId;
  final int? userAuthId;
  final int projectId;
  final int assigneBy;
  final int createdBy;

  final String from;

  final String name;
  final String? description;
  final String point;
  final String date;

  final String status;
  final String statusDay;

  final String pointName;
  final String dateName;
  final String projectName;

  final bool isOverdue;
  final bool isSlide;
  final String isAccept;
  final String repeat;

  final String assigneName;
  final String createdName;
  final String assignePhoto;

  final int acceptanceDone;
  final int acceptanceAll;

  final bool withProject;
  final bool withPercentage;
  final FToast fToast;

  final controller = IssueController.issueC;
  final controllerList = ListIssueController.to;
  final int progressPercentage;
  final Function(int val)? onTapPercentage;
  final Function()? onTapDone;
  final Function()? onTapUpdateAcceptanceStatus;
  final Function()? onCreatedAcceptance;

  @override
  Widget build(BuildContext context) {
    Get.put(InstructionController());
    var dayColor = controllerList.setDayColor(
      status: statusDay,
      date: dateName == "No Date" ? DateTime.now() : DateTime.parse(date),
    );

    var dateShow = dateName != "No Date"
        ? DateFormat('hh.mm').format(DateTime.parse(date))
        : "";

    Widget getIcon() {
      if (from == 'instruction') {
        if (status != 'open') {
          return Container(
            decoration: BoxDecoration(
              color: isOverdue
                  ? AppColors.greyIconCheck.withOpacity(0.5)
                  : AppColors.greyIconCheck,
              shape: BoxShape.circle,
            ),
            width: DimensionConstant.pixel24,
            height: DimensionConstant.pixel24,
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Icon(
                Icons.check_rounded,
                color: isOverdue
                    ? AppColors.white.withOpacity(0.5)
                    : AppColors.white,
              ),
            ),
          );
        } else {
          return const Icon(
            Icons.circle_outlined,
            size: DimensionConstant.pixel28,
          );
        }
      } else {
        if (status == '1') {
          return const Icon(
            Icons.circle_outlined,
            size: DimensionConstant.pixel28,
          );
        } else if (status == '0') {
          return Container(
            width: DimensionConstant.pixel24,
            height: DimensionConstant.pixel24,
            decoration: BoxDecoration(
              color: AppColors.grey.withOpacity(0.5),
              shape: BoxShape.circle,
              border: Border.all(
                color: isOverdue
                    ? AppColors.greyText.withOpacity(0.5)
                    : AppColors.greyText,
                width: 2,
              ),
            ),
          );
        } else {
          return Container(
            decoration: BoxDecoration(
              color: isOverdue
                  ? AppColors.greyIconCheck.withOpacity(0.5)
                  : AppColors.greyIconCheck,
              shape: BoxShape.circle,
            ),
            width: DimensionConstant.pixel24,
            height: DimensionConstant.pixel24,
            padding: const EdgeInsets.all(
              DimensionConstant.pixel2,
            ),
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Icon(
                Icons.check_rounded,
                color: isOverdue
                    ? AppColors.white.withOpacity(0.5)
                    : AppColors.white,
              ),
            ),
          );
        }
      }
    }

    TextDecoration getDecoration() {
      if (from == 'instruction') {
        if (isAccept == '1') {
          return TextDecoration.lineThrough;
        } else {
          return TextDecoration.none;
        }
      } else {
        return TextDecoration.none;
      }
    }

    ActionPane? getActionPane() {
      if (from == 'instruction') {
        if (status == 'open') {
          return ActionPane(
            motion: const StretchMotion(),
            children: [
              if (isAccept == "1") ...[
                SlidableAction(
                  onPressed: (context) async {
                    await controllerList.onTapReject(
                      id: id,
                      from: 'mySquad',
                    );
                    await MySquadController.to.onReload();
                  },
                  icon: Icons.undo_outlined,
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.yellow,
                ),
              ],
              SlidableAction(
                onPressed: (context) async {
                  controllerList.onTapDelete(
                    id: id,
                    from: 'mySquad',
                    fToast: fToast,
                  );
                  await MySquadController.to.onReload();
                },
                icon: Icons.delete,
                backgroundColor: AppColors.redColor,
              ),
            ],
          );
        } else {
          return null;
        }
      } else {
        return null;
      }
    }

    return Container(
      color: MySquadFunction.getBackgroundColorTile(
        from: from,
        status: status,
        isOverdue: isOverdue,
      ),
      child: Slidable(
        endActionPane: getActionPane(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Material(
                type: MaterialType.transparency,
                child: IconButton(
                  padding:
                      const EdgeInsets.only(left: DimensionConstant.pixel5),
                  alignment: Alignment.centerLeft,
                  color: isOverdue
                      ? AppColors.grey.withOpacity(0.5)
                      : AppColors.grey,
                  disabledColor: AppColors.greyDisabled,
                  splashRadius: 25,
                  icon: getIcon(),
                  onPressed: from == 'instruction'
                      ? status == 'open' && isAccept == '1'
                          ? () async {
                              await IssueController.issueC.updateIssue(
                                id: id,
                                from: 'mySquad',
                                status: status == "open" ? "0" : "1",
                                repeat: repeat,
                              );
                              await MySquadController.to.onReload();
                            }
                          : null
                      : status != '1' && !isOverdue
                          ? onTapDone
                          : null,
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                hoverColor: Colors.transparent,
                onTap: () {
                  controllerList.onTapListTimebox(
                    onTapUpdateAcceptanceStatus: onTapUpdateAcceptanceStatus,
                    onCreatedAcceptance: onCreatedAcceptance,
                    id: id,
                    userId: userId,
                    userAuthId: userAuthId,
                    projectId: projectId,
                    assigneBy: assigneBy,
                    createdBy: createdBy,
                    from: from == 'instruction' ? 'mySquad_instruction' : from,
                    name: name,
                    description: description ?? '0',
                    point: point,
                    date: date,
                    status: status,
                    statusDay: statusDay,
                    pointName: pointName,
                    dateName: dateShow,
                    projectName: projectName,
                    isOverdue: isOverdue,

                    /// use as read only too
                    /// is from 'instruction', then check if createdBy Id equal to userAuthId(id)
                    isSlide: from == 'instruction'
                        ? createdBy == userId
                            ? true
                            : false
                        : false,
                    isAccept: isAccept,
                    repeat: repeat,
                    assigneName: assigneName,
                    createdName: createdName,
                    assignePhoto: assignePhoto,
                    acceptanceDone: acceptanceDone,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      /// Title
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 0,
                                color: isOverdue
                                    ? AppColors.blackText.withOpacity(0.5)
                                    : AppColors.blackText,
                                fontWeight: FontWeight.w400,
                                decoration: getDecoration(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),

                      /// Description
                      if (description != '' && description != '0') ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                description ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 0,
                                  color: isOverdue
                                      ? AppColors.greyText.withOpacity(0.5)
                                      : AppColors.greyText,
                                  fontWeight: FontWeight.w400,
                                  decoration: getDecoration(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ],

                      /// Calendar, Point, Repeat & Project also percentage
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (acceptanceAll != 0) ...[
                            Image.asset(
                              AssetConstants.icAcceptance,
                              height: 12,
                              width: 12,
                              color: isOverdue
                                  ? AppColors.greyText.withOpacity(0.5)
                                  : AppColors.greyText,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "$acceptanceDone/$acceptanceAll",
                              style: TextStyle(
                                letterSpacing: 0,
                                fontSize: 12,
                                color: isOverdue
                                    ? AppColors.greyText.withOpacity(0.5)
                                    : AppColors.greyText,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          if (dateName != "No Date") ...[
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 12,
                              color: isOverdue
                                  ? dayColor.withOpacity(0.5)
                                  : dayColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              from == 'instruction' ? dateName : dateShow,
                              style: TextStyle(
                                letterSpacing: 0,
                                fontSize: 12,
                                color: isOverdue
                                    ? dayColor.withOpacity(0.5)
                                    : dayColor,
                              ),
                            ),
                            if (repeat.isNotEmpty) ...[
                              const SizedBox(width: 4),
                              Icon(
                                Icons.repeat_outlined,
                                size: 12,
                                color: isOverdue
                                    ? AppColors.greyText.withOpacity(0.5)
                                    : AppColors.greyText,
                              ),
                            ],
                            const SizedBox(width: 12),
                          ],
                          Icon(
                            Icons.share_arrival_time_outlined,
                            size: 12,
                            color: isOverdue
                                ? AppColors.greyText.withOpacity(0.5)
                                : AppColors.greyText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            point.replaceAll(".00", ""),
                            style: TextStyle(
                              letterSpacing: 0,
                              color: isOverdue
                                  ? AppColors.greyText.withOpacity(0.5)
                                  : AppColors.greyText,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          if (withProject == true && projectName != "0") ...[
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: DimensionConstant.pixel100,
                                minWidth: DimensionConstant.pixel20,
                              ),
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Opacity(
                                      opacity: isOverdue ? 0.5 : 1.0,
                                      child: const Icon(
                                        Icons.group_outlined,
                                        size: DimensionConstant.pixel20,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      projectName,
                                      maxLines: 2,
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.right,
                                      style: AppTextStyle.f14BlackTextW400
                                          .copyWith(
                                        color: isOverdue
                                            ? AppColors.blackText
                                                .withOpacity(0.5)
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
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
