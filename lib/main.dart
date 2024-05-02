import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timebox/configs/pages/app_page.dart';
import 'package:timebox/configs/routes/app_route.dart';
import 'package:timebox/configs/themes/app_theme.dart';
import 'package:timebox/constants/cores/hive_constant.dart';
import 'package:timebox/modules/global_binding/global_binding.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timebox/utils/services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(HiveConstant.db);
  await Hive.openBox(HiveConstant.url);

  /// firebase setting
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    /// Screen Util Init berdasarkan ukuran iphone xr
    return Container(
      color: AppColors.bgColorGrey,
      child: Center(
        child: Container(
          width: 500,
          height: double.infinity,
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: AppColors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 5), // changes position of shadow
              ),
            ],
          ),
          child: GetMaterialApp(
            title: 'Timebox Space',
            debugShowCheckedModeBanner: false,
            locale: const Locale('id'),
            fallbackLocale: const Locale('id'),
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('id'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            initialBinding: GlobalBinding(),
            initialRoute: AppRoutes.splashRoute,
            theme: appThemeData,
            defaultTransition: Transition.noTransition,
            getPages: AppPages.pages,
          ),
        ),
      ),
    );
  }
}
