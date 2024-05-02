import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timebox/configs/routes/app_route.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';
import 'package:timebox/modules/features/profile/controllers/profile_controller.dart';
import 'package:timebox/modules/features/profile/views/components/profile_name_component.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:timebox/shared/customs/appbar_custom.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      analytics.setCurrentScreen(
        screenName: 'Profile Screen',
        screenClassOverride: 'Web',
      );
    } else {
      if (Platform.isAndroid) {
        analytics.setCurrentScreen(
          screenName: 'Profile Screen',
          screenClassOverride: 'Android',
        );
      } else if (Platform.isIOS) {
        analytics.setCurrentScreen(
          screenName: 'Profile Screen',
          screenClassOverride: 'IOS',
        );
      } else if (Platform.isMacOS) {
        analytics.setCurrentScreen(
          screenName: 'Profile Screen',
          screenClassOverride: 'MacOS',
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.bgColorGrey,
      appBar: const AppBarCustom(
        textAppBar: 'Profil',
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          vertical: DimensionConstant.pixel26,
          horizontal: DimensionConstant.pixel29,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const ProfileNameComponent(),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: DimensionConstant.pixel44,
              child: SizedBox(
                width: double.infinity,
                height: DimensionConstant.pixel44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        DimensionConstant.pixel10,
                      ),
                    ),
                  ),
                  onPressed: () {
                    ProfileController.profileC.logout();
                    Get.offAndToNamed(AppRoutes.loginRoute);
                  },
                  child: const Text(
                    'Keluar',
                    style: AppTextStyle.f15WhiteW600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: DimensionConstant.pixel74),
          ],
        ),
      ),
    );
  }
}
