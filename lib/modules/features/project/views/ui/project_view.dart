import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';
import 'package:timebox/modules/features/project/controllers/project_controller.dart';
import 'package:timebox/modules/features/project/views/components/project_list_component.dart';
import 'package:timebox/modules/global_controllers/issue_controller.dart';
import 'package:timebox/shared/customs/appbar_custom.dart';
import 'package:timebox/shared/widgets/card_issue/card_issue_widget.dart';
import 'package:timebox/shared/widgets/card_list_timebox_shimmer_widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:timebox/shared/widgets/empty_data_component.dart';
import 'package:timebox/utils/services/hive_service.dart';

class ProjectView extends StatelessWidget {
  ProjectView({super.key});
  final analytics = FirebaseAnalytics.instance;
  final controller = ProjectController.projectC;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      analytics.setCurrentScreen(
        screenName: 'Project Screen',
        screenClassOverride: 'Web',
      );
    } else {
      if (Platform.isAndroid) {
        analytics.setCurrentScreen(
          screenName: 'Project Screen',
          screenClassOverride: 'Android',
        );
      } else if (Platform.isIOS) {
        analytics.setCurrentScreen(
          screenName: 'Project Screen',
          screenClassOverride: 'IOS',
        );
      } else if (Platform.isMacOS) {
        analytics.setCurrentScreen(
          screenName: 'Project Screen',
          screenClassOverride: 'MacOS',
        );
      }
    }

    return Obx(
      () => Scaffold(
        appBar: AppBarCustom(
          textAppBar: controller.title.value,
          trailing: IconButton(
            tooltip:
                (controller.isMyIssue.value) ? "All Issue" : "Only My Issue",
            onPressed: () async {
              if (controller.isMyIssue.value) {
                controller.isMyIssue.value = false;
                await HiveServices.box.put("projectIsMyIssue", false);
                controller.onRefresh();
              } else {
                controller.isMyIssue.value = true;
                await HiveServices.box.put("projectIsMyIssue", true);
                controller.onRefresh();
              }
            },
            padding: const EdgeInsets.only(right: 25),
            icon: Icon(
              (!controller.isMyIssue.value)
                  ? Icons.account_circle_rounded
                  : Icons.supervisor_account_rounded,
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
              ? const CardListTimeboxShimmerWidget(from: "project")
              : controller.listData.isNotEmpty
                  ? SingleChildScrollView(
                      child: ProjectListComponent(),
                    )
                  : const EmptyDataComponent(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.bottomSheet(
              persistent: false,
              CardIssueWidget(
                key: const ValueKey("projectCreate"),
                from: 'project',
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
                projectId: controller.projectId.value,
                projectName: controller.title.value,
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
                from: "project",
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
