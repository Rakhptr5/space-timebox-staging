import 'package:flutter/material.dart';

import '../../configs/themes/app_colors.dart';
import '../../configs/themes/app_text_style.dart';
import '../../constants/cores/dimension_constant.dart';

class ChipCheckedWidget extends StatelessWidget {
  const ChipCheckedWidget({
    super.key,
    required this.checkedAt,
  });

  final String? checkedAt;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DimensionConstant.pixel90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          DimensionConstant.pixel18,
        ),
        color: AppColors.greenStatus.withOpacity(0.6),
        shape: BoxShape.rectangle,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: DimensionConstant.pixel17,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: DimensionConstant.pixel4,
        horizontal: DimensionConstant.pixel4,
      ),
      child: Text(
        'Checked - ${checkedAt ?? ''}',
        style: AppTextStyle.f9WhiteTextW500,
        textAlign: TextAlign.center,
      ),
    );
  }
}
