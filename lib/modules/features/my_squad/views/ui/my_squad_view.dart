import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';
import 'package:timebox/modules/features/my_squad/controllers/my_squad_controller.dart';
import 'package:timebox/modules/features/my_squad/views/components/my_squad_new_component.dart';
import 'package:timebox/shared/customs/appbar_custom.dart';
import 'package:timebox/shared/widgets/card_issue/card_issue_widget.dart';
import 'package:timebox/shared/widgets/card_list_timebox_shimmer_widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:timebox/shared/widgets/empty_data_component.dart';

class MySquadView extends StatelessWidget {
  MySquadView({super.key});
  final analytics = FirebaseAnalytics.instance;
  final controller = MySquadController.to;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      analytics.setCurrentScreen(
        screenName: 'My Squad Screen',
        screenClassOverride: 'Web',
      );
    } else {
      if (Platform.isAndroid) {
        analytics.setCurrentScreen(
          screenName: 'My Squad Screen',
          screenClassOverride: 'Android',
        );
      } else if (Platform.isIOS) {
        analytics.setCurrentScreen(
          screenName: 'My Squad Screen',
          screenClassOverride: 'IOS',
        );
      } else if (Platform.isMacOS) {
        analytics.setCurrentScreen(
          screenName: 'My Squad Screen',
          screenClassOverride: 'MacOS',
        );
      }
    }

    return Obx(
      () => Scaffold(
        appBar: const AppBarCustom(
          customTitle: Expanded(
            child: Text(
              'Daily Check',
              style: AppTextStyle.f18WhiteW500,
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          controller: controller.refreshController,
          onRefresh: controller.onRefresh,
          child: controller.isLoading.value == true
              ? const CardListTimeboxShimmerWidget(from: "mySquad")
              : controller.checkDataIsNotEmpty()
                  ? MySquadNewComponent()
                  : const EmptyDataComponent(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.bottomSheet(
              persistent: false,
              CardIssueWidget(
                onSuccesSaveData: () => controller.onReload(),
                key: const ValueKey("mySquadCreate"),
                authId: controller.authId.value,
                assigneName: controller.title.value,
                assignePhoto: controller.photo.value,
                from: 'mySquad',
                id: 0,
                name: "",
                description: "",
                date: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
                dateName: "No Date",
                pointJam: "0:0",
                projectId: 0,
                projectName: "0",
                repeat: "",
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(DimensionConstant.pixel20),
                ),
              ),
              backgroundColor: Colors.white,
            );
          },
          backgroundColor: AppColors.primaryColor,
          child: const Icon(
            Icons.add,
            size: 24,
          ),
        ),
      ),
    );
  }
}
