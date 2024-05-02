import 'package:flutter/material.dart';

import '../../../../../configs/themes/app_colors.dart';
import '../../../../../configs/themes/app_text_style.dart';
import '../../../../../constants/cores/dimension_constant.dart';

class TitleListSquadComponent extends StatelessWidget {
  const TitleListSquadComponent({
    super.key,
    required this.title,
    this.totalPoint,
    this.totalIssue,
    this.isOverdue = false,
    this.isClose = false,
    this.totalPointOverdue,
  })  : checkAtWidget = const SizedBox(),
        withCheckAt = false;

  const TitleListSquadComponent.checkedAt({
    super.key,
    required this.title,
    required this.checkAtWidget,
    this.totalPoint,
    this.totalIssue,
    this.isOverdue = false,
    this.totalPointOverdue,
    this.isClose = false,
  }) : withCheckAt = true;

  final String title;
  final String? totalPoint;
  final String? totalIssue;
  final String? totalPointOverdue;
  final bool withCheckAt;
  final bool isOverdue;

  final bool isClose;
  final Widget checkAtWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: DimensionConstant.pixel12,
            horizontal: DimensionConstant.pixel25,
          ).copyWith(
            top: DimensionConstant.pixel25,
          ),
          child: Row(
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyle.f15BlackTextW500.copyWith(
                  color: isOverdue
                      ? AppColors.blackText.withOpacity(0.5)
                      : AppColors.blackText,
                ),
              ),
              const SizedBox(
                width: DimensionConstant.pixel6,
              ),
              Visibility(
                visible: isOverdue,
                child: Text(
                  '• Overdue',
                  style: AppTextStyle.f12RedW500.copyWith(
                    color: AppColors.redColor.withOpacity(0.5),
                  ),
                ),
              ),
              const Spacer(),
              Visibility(
                visible: isClose,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DimensionConstant.pixel6,
                    vertical: DimensionConstant.pixel6,
                  ),
                  decoration: const BoxDecoration(
                      color: AppColors.redColor,
                      borderRadius: BorderRadius.all(
                          Radius.circular(DimensionConstant.pixel6))),
                  child: Text(
                    totalPointOverdue ?? "",
                    style: AppTextStyle.f12BlackTextW400.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),
              checkAtWidget,
              const SizedBox(
                width: DimensionConstant.pixel6,
              ),
              Visibility(
                replacement: Text(
                  totalIssue ?? '',
                  style: AppTextStyle.f12BlackTextW400.copyWith(
                    color: isOverdue
                        ? AppColors.blackText.withOpacity(0.5)
                        : AppColors.blackText,
                  ),
                ),
                visible: totalPoint != null && totalPoint != '',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${totalPoint ?? '0'}/8.00',
                      style: AppTextStyle.f12BlackTextW500.copyWith(
                        color: isOverdue
                            ? AppColors.blackText.withOpacity(0.5)
                            : isClose &&
                                    (double.parse(totalPoint.toString()) < 8.00)
                                ? AppColors.redColor
                                : title == "Today" &&
                                        (double.parse(totalPoint.toString()) <
                                            8.00)
                                    ? AppColors.redColor
                                    : AppColors.greenStatus,
                      ),
                    ),
                    Text(
                      totalIssue ?? '',
                      style: AppTextStyle.f9BlackTextW400.copyWith(
                        color: isOverdue
                            ? AppColors.blackText.withOpacity(0.5)
                            : AppColors.blackText,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 1,
          color: AppColors.greyDivider,
        ),
      ],
    );
  }
}
