import 'package:flutter/material.dart';
import 'package:timebox/constants/cores/assets_constant.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    analytics.logAppOpen();

    return Scaffold(
      appBar: null,
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Image.asset(
            AssetConstants.splashScreen,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
