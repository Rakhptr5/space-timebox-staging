import 'package:flutter/material.dart';
import 'package:timebox/configs/themes/app_colors.dart';

final ThemeData appThemeData = ThemeData(
  primaryColor: AppColors.primaryColor,
  scaffoldBackgroundColor: AppColors.white,
  brightness: Brightness.light,
  fontFamily: 'Poppins',
  colorScheme: ColorScheme.fromSwatch(
    accentColor: AppColors.primaryColor,
  ),
  iconTheme: const IconThemeData(
    color: AppColors.primaryColor,
  ),
);
