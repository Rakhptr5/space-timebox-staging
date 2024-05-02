import 'package:flutter/material.dart';

import '../../../../../configs/themes/app_colors.dart';
import '../../../../../configs/themes/app_text_style.dart';
import '../../../../../constants/cores/dimension_constant.dart';

class CustomTabBarHomeBodyComponentWidget extends StatelessWidget {
  const CustomTabBarHomeBodyComponentWidget({
    super.key,
    required this.title,
    this.isActive = false,
    this.onTap,
  }) : isSingle = false;

  const CustomTabBarHomeBodyComponentWidget.single({
    super.key,
    required this.title,
    this.isActive = false,
    this.onTap,
  }) : isSingle = true;

  final String title;
  final bool isActive;
  final Function()? onTap;
  final bool isSingle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          left: isSingle ? DimensionConstant.pixel15 : 0,
          bottom: DimensionConstant.pixel15,
          top: DimensionConstant.pixel15,
        ),
        decoration: BoxDecoration(
          border: isSingle
              ? null
              : Border(
                  bottom: BorderSide(
                    width: DimensionConstant.pixel1,
                    color: isActive
                        ? AppColors.primaryColorLight
                        : AppColors.greyDivider,
                  ),
                ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: isSingle
              ? AppTextStyle.f16WhiteW500
              : isActive
                  ? AppTextStyle.f16PrimaryLightW500
                  : AppTextStyle.f16GreyDividerDarkerW400,
        ),
      ),
    );
  }
}
