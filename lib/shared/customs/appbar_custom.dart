import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timebox/configs/routes/app_route.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  final String? textAppBar;
  final double height;
  final bool withButton;
  final Widget? trailing;
  final Widget? customTitle;

  const AppBarCustom({
    super.key,
    this.textAppBar,
    this.height = kToolbarHeight,
    this.withButton = true,
    this.trailing = const SizedBox(),
    this.customTitle,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(DimensionConstant.pixel20),
        ),
      ),
      elevation: 2,
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => Get.offAllNamed(AppRoutes.homeRoute),
            padding: const EdgeInsets.only(
              left: 25,
              right: 8,
            ),
            icon: const Icon(
              Icons.arrow_back_ios_outlined,
              color: AppColors.white,
              size: DimensionConstant.pixel24,
            ),
          ),
          customTitle ??
              Expanded(
                child: Text(
                  textAppBar!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.f18WhiteW500,
                  textAlign: TextAlign.left,
                ),
              ),
          const SizedBox(width: DimensionConstant.pixel25),
          trailing!,
        ],
      ),
      centerTitle: false,
    );
  }
}
