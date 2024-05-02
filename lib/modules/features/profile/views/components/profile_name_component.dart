import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';
import 'package:timebox/modules/features/profile/controllers/profile_controller.dart';

class ProfileNameComponent extends StatelessWidget {
  const ProfileNameComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => ProfileController.profileC.photo.value.isEmpty
              ? const CircularProgressIndicator()
              : CachedNetworkImage(
                  imageUrl: ProfileController.profileC.photo.value,
                  imageBuilder: (context, imageProvider) => Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.white,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => const SizedBox(),
                  errorWidget: (context, url, error) => Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 100,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
        ),
        const SizedBox(
          height: DimensionConstant.pixel23,
        ),
        Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                ProfileController.profileC.name.value,
                style: AppTextStyle.f21PrimaryW700,
              ),
              const SizedBox(
                height: DimensionConstant.pixel5,
              ),
              Text(
                ProfileController.profileC.position.value,
                style: AppTextStyle.f15BlackTextW600,
              ),
              const SizedBox(
                height: DimensionConstant.pixel5,
              ),
              ProfileController.profileC.atasan.value.isEmpty
                  ? const SizedBox()
                  : Text(
                      '${ProfileController.profileC.atasan.value} (atasan langsung)',
                      style: AppTextStyle.f15GreyTextW400,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
