import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:get/get.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/constants/cores/api_constant.dart';
import 'package:timebox/shared/widgets/radio_button_url_component.dart';
import 'package:timebox/utils/services/url_hive_service.dart';

class GlobalController extends GetxController {
  static GlobalController get to => Get.find();

  var appBadgeSupported = "".obs;
  var isConnect = true.obs;
  var urlOption = [
    ApiConstant.apiBaseUrl,
    ApiConstant.apiBaseUrlStaging,
  ];
  var urlTitle = [
    'Production',
    'Staging',
  ];

  static String _globalBaseUrl = '';

  static set setGlobalBaseUrl(String val) {
    _globalBaseUrl = val;
    UrlHiveService.setUrl(val);
  }

  static String get getGlobalBaseUrl {
    if (_globalBaseUrl == '') {
      return UrlHiveService.getBaseUrl();
    }

    return _globalBaseUrl;
  }

  void initPlatformState() async {
    try {
      bool res = await FlutterAppBadger.isAppBadgeSupported();
      if (res) {
        appBadgeSupported.value = 'Supported';
      } else {
        appBadgeSupported.value = 'Not supported';
      }
    } on PlatformException {
      appBadgeSupported.value = 'Failed to get badge support.';
    }
  }

  Future<void> checkConnection() async {
    try {
      final result = await InternetAddress.lookup('venturo.id');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnect.value = true;
      }
    } on SocketException catch (_) {
      isConnect.value = false;
    }
  }

  void changeBaseUrlBottomsheet() async {
    await showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'Ganti Base Url',
                  style: AppTextStyle.f20BlackTextW700,
                ),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => RadioButtonUrlComponent(
                title: urlTitle[index],
                url: urlOption[index],
                selected: getGlobalBaseUrl == urlOption[index],
                onTap: () {
                  setGlobalBaseUrl = urlOption[index];
                  Get.back();
                },
              ),
              separatorBuilder: (context, index) => const SizedBox(
                height: 20,
              ),
              itemCount: urlOption.length,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onInit() async {
    if (!kIsWeb) {
      initPlatformState();
    }

    super.onInit();
  }
}
