import 'package:flutter/material.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';

class ListTileCustom extends StatelessWidget {
  const ListTileCustom({
    super.key,
    this.icon = const SizedBox(),
    required this.title,
    this.trailing = const SizedBox(),
    this.onTap,
    this.isEnd = false,
  });

  final Widget? icon;
  final String title;
  final Widget? trailing;
  final void Function()? onTap;
  final bool isEnd;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DimensionConstant.pixel20,
          vertical: DimensionConstant.pixel20,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            icon!,
            const SizedBox(width: 20),
            Text(
              title,
              style: AppTextStyle.f16BlackW400,
            ),
            const Spacer(),
            trailing!,
          ],
        ),
      ),
    );
  }
}
