import 'package:flutter/material.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/configs/themes/app_text_style.dart';

class RadioButtonUrlComponent extends StatelessWidget {
  const RadioButtonUrlComponent({
    super.key,
    required this.url,
    required this.title,
    required this.selected,
    this.onTap,
  });

  final String title, url;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyle.f15BlackTextW600,
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: selected ? AppColors.grey : AppColors.white,
              border: Border.all(
                color: AppColors.black,
              ),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
