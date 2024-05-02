import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/constants/cores/assets_constant.dart';

class CardListIssueWidget extends StatelessWidget {
  const CardListIssueWidget({
    super.key,
    required this.from,
    required this.name,
    required this.point,
    required this.date,
    required this.type,
    required this.dayType,
    required this.project,
    this.bgColorStatus,
    this.status,
  });

  final String from;
  final String name;
  final String point;
  final String date;
  final String type;
  final String dayType;
  final String project;
  final Color? bgColorStatus;
  final String? status;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          alignment: Alignment.centerLeft,
          color: AppColors.grey,
          icon: type == "1"
              ? SvgPicture.asset(
                  AssetConstants.icImprove,
                  height: 24,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                )
              : SvgPicture.asset(
                  AssetConstants.icBug,
                  height: 24,
                  fit: BoxFit.contain,
                ),
          onPressed: null,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Column(
              children: [
                /// Title
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          letterSpacing: 0,
                          color: AppColors.blackText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    if (from != "project" &&
                        date == "No Date" &&
                        point == "0" &&
                        project != "0" &&
                        status == "No Date") ...[
                      const SizedBox(width: 4),
                      Text(
                        project,
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

                /// Calendar, Point, Repeat & Project

                Row(
                  children: [
                    // if (point != "0" || date != "No Date") ...[
                    const SizedBox(height: 4),
                    if (date != "No Date") ...[
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: dayType == "0"
                            ? AppColors.redColor
                            : dayType == "1"
                                ? AppColors.green
                                : dayType == "2"
                                    ? Colors.purple
                                    : AppColors.greyText,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: TextStyle(
                          letterSpacing: 0,
                          fontSize: 12,
                          color: dayType == "0"
                              ? AppColors.redColor
                              : dayType == "1"
                                  ? AppColors.green
                                  : dayType == "2"
                                      ? Colors.purple
                                      : AppColors.greyText,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    // if (point != "0") ...[
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
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 3),
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3)),
                        color: status == "1" || status == "2"
                            ? AppColors.grey
                            : status == "3" || status == "4" || status == "5"
                                ? AppColors.blueStatus
                                : status == "6" || status == "7"
                                    ? AppColors.greenStatus.withOpacity(0.6)
                                    : AppColors.greyText,
                      ),
                      child: Text(
                        status == "1"
                            ? "To Do"
                            : status == "2"
                                ? "In Progress"
                                : status == "3"
                                    ? "Code Review"
                                    : status == "4"
                                        ? "Testing"
                                        : status == "5"
                                            ? "Done"
                                            : status == "6"
                                                ? "Release"
                                                : status == "7"
                                                    ? "Closed"
                                                    : "",
                        style: const TextStyle(
                          letterSpacing: 0,
                          color: AppColors.white,
                          fontSize: 8,
                        ),
                      ),
                    ),

                    if (project != "0" && from != "project") ...[
                      Text(
                        project,
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
            ),
          ),
        ),
      ],
    );
  }
}
