import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/constants/cores/assets_constant.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';
import 'package:timebox/modules/global_controllers/issue_controller.dart';
import 'package:timebox/modules/global_controllers/list_issue_controller.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CardListTimeboxWidget extends StatelessWidget {
  CardListTimeboxWidget({
    super.key,
    required this.id,
    this.userId = 0,
    required this.projectId,
    this.assigneBy = 0,
    this.createdBy = 0,
    required this.from,
    required this.name,
    required this.description,
    required this.point,
    required this.date,
    required this.status,
    required this.statusDay,
    required this.pointName,
    required this.dateName,
    required this.projectName,
    this.isOverdue = false,
    this.isSlide = true,
    this.isAccept = "0",
    required this.repeat,
    this.createdName = "",
    this.assigneName = "",
    this.assignePhoto = "",
    required this.acceptanceDone,
    required this.acceptanceAll,
    this.withProject = true,
    required this.fToast,
    this.assignToName = "",
    required this.isInstruction,
    required this.instructionStatus,
  });

  final int id;
  final int userId;
  final int projectId;
  final int assigneBy;
  final int createdBy;

  final String from;

  final String name;
  final String description;
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
  final bool isInstruction;
  final String instructionStatus;

  final String assigneName;
  final String createdName;
  final String assignePhoto;
  final String assignToName;

  final int acceptanceDone;
  final int acceptanceAll;

  final bool withProject;

  final FToast fToast;

  final controller = IssueController.issueC;
  final controllerList = ListIssueController.to;

  @override
  Widget build(BuildContext context) {
    var dayColor = controllerList.setDayColor(
      status: statusDay,
      date: dateName == "No Date" ? DateTime.now() : DateTime.parse(date),
    );

    var dateShow = controllerList.setDateName(
      dateName: dateName,
      isOverdue: isOverdue,
      from: from,
    );

    return Slidable(
      endActionPane: (isSlide)
          ? ActionPane(
              motion: const StretchMotion(),
              children: [
                if (isAccept == "1") ...[
                  SlidableAction(
                    onPressed: (context) => controllerList.onTapReject(
                      id: id,
                      from: from,
                    ),
                    icon: Icons.undo_outlined,
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.yellow,
                  ),
                ],
                SlidableAction(
                  onPressed: (context) => controllerList.onTapDelete(
                    id: id,
                    from: from,
                    fToast: fToast,
                  ),
                  icon: Icons.delete,
                  backgroundColor: AppColors.redColor,
                ),
              ],
            )
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            alignment: Alignment.centerLeft,
            color: isInstruction
                ? AppColors.grey
                : (isAccept == "1")
                    ? AppColors.primaryColorLight
                    : AppColors.grey,
            disabledColor: AppColors.greyDisabled,
            iconSize: 24,
            icon: from == 'instruction'
                ? status == 'open' && isAccept == '0'
                    ? const Icon(
                        Icons.circle_outlined,
                        size: DimensionConstant.pixel28,
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          color: AppColors.greyIconCheck,
                          shape: BoxShape.circle,
                        ),
                        width: DimensionConstant.pixel24,
                        height: DimensionConstant.pixel24,
                        padding: const EdgeInsets.all(
                          DimensionConstant.pixel2,
                        ),
                        alignment: Alignment.center,
                        child: const FittedBox(
                          fit: BoxFit.cover,
                          child: Icon(
                            Icons.check_rounded,
                            color: AppColors.white,
                          ),
                        ),
                      )
                : Icon(
                    (status == "open")
                        ? Icons.circle_outlined
                        : Icons.check_circle_outline,
                  ),
            onPressed: isInstruction
                ? status == 'open' && isAccept == '1'
                    ? () => controllerList.onTapUpdate(
                          id: id,
                          userId: userId,
                          assigneBy: assigneBy,
                          createdBy: createdBy,
                          from: from,
                          status: status,
                          repeat: repeat,
                          isAccept: isAccept,
                          isSlide: isSlide,
                        )
                    : null
                : from != 'instruction'
                    ? (!isSlide && userId != assigneBy)
                        ? null
                        : (createdBy != userId && isAccept == "1")
                            ? null
                            : () => controllerList.onTapUpdate(
                                  id: id,
                                  userId: userId,
                                  assigneBy: assigneBy,
                                  createdBy: createdBy,
                                  from: from,
                                  status: status,
                                  repeat: repeat,
                                  isAccept: isAccept,
                                  isSlide: isSlide,
                                )
                    : assigneBy == userId && isAccept != '1'
                        ? () async {
                            await IssueController.issueC.updateIsAccept(
                              id: id,
                              from: from,
                              isAccept: isAccept == "0" ? "1" : "0",
                            );
                          }
                        : null,
          ),
          Expanded(
            child: InkWell(
              hoverColor: Colors.transparent,
              onTap: status == "open"
                  ? () => controllerList.onTapListTimebox(
                        id: id,
                        userId: userId,
                        projectId: projectId,
                        assigneBy: assigneBy,
                        createdBy: createdBy,
                        from: from,
                        name: name,
                        description: description,
                        point: point,
                        date: date,
                        status: status,
                        statusDay: statusDay,
                        pointName: pointName,
                        dateName: dateShow[1],
                        projectName: projectName,
                        isOverdue: isOverdue,
                        isSlide: isSlide,
                        isAccept: isAccept,
                        repeat: repeat,
                        assigneName: assignToName.trim().isNotEmpty
                            ? assignToName
                            : assigneName,
                        createdName: createdName,
                        assignePhoto: assignePhoto,
                        acceptanceDone: acceptanceDone,
                      )
                  : null,
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
                              color: AppColors.blackText,
                              fontWeight: FontWeight.w400,
                              decoration: status == "open" && isAccept == "0"
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                        if (point == "0.00" &&
                            dateShow[0] == "No Date" &&
                            withProject &&
                            projectName != "0" &&
                            acceptanceAll == 0 &&
                            assignToName.trim().isEmpty) ...[
                          const SizedBox(width: 4),
                          Text(
                            projectName,
                            style: const TextStyle(
                              letterSpacing: 0,
                              color: AppColors.greyText,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.group_outlined,
                            size: 12,
                          ),
                        ],
                        const SizedBox(width: 8),
                      ],
                    ),

                    /// Description
                    if (description != "0") ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 0,
                                color: AppColors.greyText,
                                fontWeight: FontWeight.w400,
                                decoration: status == "open"
                                    ? TextDecoration.none
                                    : TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],

                    /// Calendar, Point, Repeat & Project
                    if (point != "0.00" ||
                        dateShow[0] != "No Date" ||
                        repeat.isNotEmpty ||
                        acceptanceAll != 0 ||
                        assignToName.trim().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          if (acceptanceAll != 0) ...[
                            Image.asset(
                              AssetConstants.icAcceptance,
                              height: 12,
                              width: 12,
                              color: AppColors.greyText,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "$acceptanceDone/$acceptanceAll",
                              style: const TextStyle(
                                letterSpacing: 0,
                                fontSize: 12,
                                color: AppColors.greyText,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          if (dateShow[0] != "No Date") ...[
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 12,
                              color: dayColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dateShow[0],
                              style: TextStyle(
                                letterSpacing: 0,
                                fontSize: 12,
                                color: dayColor,
                              ),
                            ),
                            if (repeat.isNotEmpty) ...[
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.repeat_outlined,
                                size: 12,
                                color: AppColors.greyText,
                              ),
                            ],
                            const SizedBox(width: 12),
                          ],
                          if (point != "0.00") ...[
                            const Icon(
                              Icons.share_arrival_time_outlined,
                              size: 12,
                              color: AppColors.greyText,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              point.replaceAll(".00", ""),
                              style: const TextStyle(
                                letterSpacing: 0,
                                color: AppColors.greyText,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],

                          /// Assignee Name
                          if (assignToName.trim().isNotEmpty) ...[
                            Expanded(
                              flex: 10,
                              child: Text(
                                '@$assignToName',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  letterSpacing: 0,
                                  color: AppColors.greyText,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                          const Spacer(),
                          if (withProject == true && projectName != "0") ...[
                            Text(
                              projectName,
                              style: const TextStyle(
                                letterSpacing: 0,
                                color: AppColors.greyText,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.group_outlined,
                              size: 12,
                            ),
                          ],
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
