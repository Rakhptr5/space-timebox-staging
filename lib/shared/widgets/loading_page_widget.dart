import 'package:flutter/material.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';

class LoadingPageWidget extends StatelessWidget {
  const LoadingPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: DimensionConstant.pixel5,
        color: AppColors.primaryColor,
      ),
    );
  }
}
