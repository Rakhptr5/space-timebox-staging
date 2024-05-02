import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';
import 'package:timebox/modules/features/backlog/controllers/backlog_controller.dart';
import 'package:timebox/modules/features/backlog/views/components/backlog_list_component.dart';
import 'package:timebox/modules/global_controllers/issue_controller.dart';
import 'package:timebox/shared/widgets/card_issue/card_issue_widget.dart';
import 'package:timebox/shared/customs/appbar_custom.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:timebox/shared/widgets/card_list_timebox_shimmer_widget.dart';
import 'package:timebox/shared/widgets/empty_data_component.dart';

class BacklogView extends StatelessWidget {
  BacklogView({super.key});
  final analytics = FirebaseAnalytics.instance;
  final controller = BacklogController.backlogC;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      analytics.setCurrentScreen(
        screenName: 'Waiting List Screen',
        screenClassOverride: 'Web',
      );
    } else {
      if (Platform.isAndroid) {
        analytics.setCurrentScreen(
          screenName: 'Waiting List Screen',
          screenClassOverride: 'Android',
        );
      } else if (Platform.isIOS) {
        analytics.setCurrentScreen(
          screenName: 'Waiting List Screen',
          screenClassOverride: 'IOS',
        );
      } else if (Platform.isMacOS) {
        analytics.setCurrentScreen(
          screenName: 'Waiting List Screen',
          screenClassOverride: 'MacOS',
        );
      }
    }

    return Obx(
      () => Scaffold(
        appBar: const AppBarCustom(textAppBar: 'Waiting List'),
        resizeToAvoidBottomInset: false,
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          controller: controller.refreshController,
          onRefresh: controller.onRefresh,
          child: controller.isLoading.value == true
              ? const CardListTimeboxShimmerWidget(from: "backlog")
              : controller.listWaitingIssue.isNotEmpty ||
                      controller.listWaitingTimebox.isNotEmpty
                  ? SingleChildScrollView(
                      child: BacklogListComponent(),
                    )
                  : const EmptyDataComponent(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.bottomSheet(
              persistent: false,
              CardIssueWidget(
                key: const ValueKey("waitingCreate"),
                from: 'waiting',
                id: 0,
                authId: controller.id.value,
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
            ).whenComplete(
              () => IssueController.issueC.onBottomSheetClosed(
                from: "waiting",
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
