import 'package:flutter/material.dart';

import '../../../../../configs/themes/app_colors.dart';
import '../../../../../constants/cores/dimension_constant.dart';

class CardParentHomeBodyComponentWidget extends StatelessWidget {
  const CardParentHomeBodyComponentWidget({
    super.key,
    required this.child,
  }) : singleTitle = false;

  const CardParentHomeBodyComponentWidget.single({
    super.key,
    required this.child,
  }) : singleTitle = true;

  final Widget child;
  final bool singleTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: singleTitle ? AppColors.primaryColor : AppColors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 3),
            blurRadius: 5,
            color: Colors.grey.withOpacity(0.3),
          ),
        ],
      ),
      margin: const EdgeInsets.all(
        DimensionConstant.pixel25,
      ).copyWith(
        top: 0,
      ),
      child: child,
    );
  }
}
