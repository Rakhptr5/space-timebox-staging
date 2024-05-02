import 'package:flutter/material.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';

class IconIssueWidget extends StatelessWidget {
  final String from;
  final String status;
  final bool isOverdue;

  const IconIssueWidget({
    required this.from,
    required this.status,
    required this.isOverdue,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
}
