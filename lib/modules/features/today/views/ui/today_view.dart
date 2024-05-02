import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';
import 'package:timebox/modules/features/today/controllers/today_controller.dart';
import 'package:timebox/modules/features/today/views/components/today_list_component.dart';
import 'package:timebox/modules/features/today/views/components/today_list_overdue_component.dart';
import 'package:timebox/shared/widgets/slim_card_list_timebox_shimmer_widget.dart';
import 'package:timebox/modules/global_controllers/issue_controller.dart';
import 'package:timebox/shared/widgets/card_issue/card_issue_widget.dart';
import 'package:timebox/shared/customs/appbar_custom.dart';
import 'package:timebox/shared/widgets/empty_data_component.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class TodayView extends StatelessWidget {
  TodayView({super.key});

  final analytics = FirebaseAnalytics.instance;
  final controller = TodayController.to;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      analytics.setCurrentScreen(
        screenName: 'Scheduled Screen',
        screenClassOverride: 'Web',
      );
    } else {
      if (Platform.isAndroid) {
        analytics.setCurrentScreen(
          screenName: 'Scheduled Screen',
          screenClassOverride: 'Android',
        );
      } else if (Platform.isIOS) {
        analytics.setCurrentScreen(
          screenName: 'Scheduled Screen',
          screenClassOverride: 'IOS',
        );
      } else if (Platform.isMacOS) {
        analytics.setCurrentScreen(
          screenName: 'Scheduled Screen',
          screenClassOverride: 'MacOS',
        );
      }
    }

    return Obx(
      () => Scaffold(
        appBar: const AppBarCustom(
          textAppBar: "Scheduled",
        ),
        resizeToAvoidBottomInset: false,
        body: SmartRefresher(
          enablePullDown: true,
          controller: controller.refreshController,
          onRefresh: controller.onRefresh,
          child: controller.isLoading.value == true
              ? const SlimCardListTimeboxShimmerWidget()
              : controller.listData.isNotEmpty ||
                      controller.listTodayIssueOverdue.isNotEmpty ||
                      controller.listTodayTimeboxOverdue.isNotEmpty
                  ? SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TodayListOverdueComponent(),
                          if (controller.listData.isNotEmpty) ...[
                            TodayListComponent(),
                          ],
                        ],
                      ),
                    )
                  : const EmptyDataComponent(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.bottomSheet(
              persistent: false,
              CardIssueWidget(
                key: const ValueKey("todayCreate"),
                from: 'today',
                id: 0,
                name: "",
                description: "",
                date: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
                dateName: "Today",
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
            ).whenComplete(
              () => IssueController.issueC.onBottomSheetClosed(
                from: "today",
              ),
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
