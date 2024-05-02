import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/constants/cores/assets_constant.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';
import 'package:timebox/modules/features/login/controllers/login_controller.dart';
import 'package:timebox/modules/features/login/views/components/form_login_component.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:timebox/modules/global_controllers/global_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final analytics = FirebaseAnalytics.instance;
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      analytics.setCurrentScreen(
        screenName: 'Sign In Screen',
        screenClassOverride: 'Web',
      );
    } else {
      if (Platform.isAndroid) {
        analytics.setCurrentScreen(
          screenName: 'Sign In Screen',
          screenClassOverride: 'Android',
        );
      } else if (Platform.isIOS) {
        analytics.setCurrentScreen(
          screenName: 'Sign In Screen',
          screenClassOverride: 'IOS',
        );
      } else if (Platform.isMacOS) {
        analytics.setCurrentScreen(
          screenName: 'Sign In Screen',
          screenClassOverride: 'MacOS',
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DimensionConstant.pixel25,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onDoubleTap: () {
                GlobalController.to.changeBaseUrlBottomsheet();
              },
              child: Image.asset(
                AssetConstants.icLogo,
                height: DimensionConstant.pixel115,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: DimensionConstant.pixel35),
            const Text(
              'Masuk untuk melanjutkan!',
              style: AppTextStyle.f22BlackW600,
            ),
            const SizedBox(height: DimensionConstant.pixel35),
            Form(
              key: formKey,
              child: FormLoginComponent(
                emailC: emailC,
                passwordC: passwordC,
                onFieldSubmitted: (val) {
                  validateForm(context);
                },
              ),
            ),
            const SizedBox(height: DimensionConstant.pixel35),
            SizedBox(
              width: double.infinity,
              height: DimensionConstant.pixel44,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      DimensionConstant.pixel20,
                    ),
                  ),
                ),
                onPressed: () {
                  validateForm(context);
                },
                child: const Text(
                  'Masuk',
                  style: AppTextStyle.f13WhiteW600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void validateForm(BuildContext context) {
    if (formKey.currentState!.validate()) {
      var email = emailC.text.trim();
      var password = passwordC.text.trim();

      LoginController.loginC.login(email, password);
    }
  }
}
