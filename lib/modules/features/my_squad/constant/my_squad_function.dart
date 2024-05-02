import 'package:flutter/material.dart';
import 'package:timebox/configs/themes/app_colors.dart';

class MySquadFunction {
  static Color getColorPercentage({required int value}) {
    switch (value) {
      case 100:
        return AppColors.greenStatus;
      case 75:
        return AppColors.yellow;
      case 50:
        return AppColors.yellow;
      case 25:
        return AppColors.redColor;
      case 0:
        return AppColors.redColor;
      default:
        return AppColors.redColor;
    }
  }

  static Color getBackgroundColorTile(
      {required String from, required String status, required bool isOverdue}) {
    if (from == 'instruction') {
      return AppColors.white;
    } else {
      if (status == '1') {
        return AppColors.white;
      } else {
        if (isOverdue) {
          return AppColors.grey.withOpacity(0.02);
        }
        return AppColors.white;
      }
    }
  }
}
