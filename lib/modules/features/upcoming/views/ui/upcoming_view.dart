import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';
import 'package:timebox/modules/features/upcoming/controllers/upcoming_controller.dart';
import 'package:timebox/modules/features/upcoming/views/components/upcoming_date_component.dart';
import 'package:timebox/modules/features/upcoming/views/components/upcoming_list_component.dart';
import 'package:timebox/modules/global_controllers/issue_controller.dart';
import 'package:timebox/shared/customs/appbar_custom.dart';
import 'package:timebox/shared/widgets/card_issue/card_issue_widget.dart';
import 'package:timebox/shared/widgets/empty_data_component.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:timebox/shared/widgets/slim_card_list_timebox_shimmer_widget.dart';

class UpcomingView extends StatelessWidget {
  UpcomingView({super.key});
  final analytics = FirebaseAnalytics.instance;
  final controller = UpcomingController.upcomingC;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      analytics.setCurrentScreen(
        screenName: 'Calendar Screen',
        screenClassOverride: 'Web',
      );
    } else {
      if (Platform.isAndroid) {
        analytics.setCurrentScreen(
          screenName: 'Calendar Screen',
          screenClassOverride: 'Android',
        );
      } else if (Platform.isIOS) {
        analytics.setCurrentScreen(
          screenName: 'Calendar Screen',
          screenClassOverride: 'IOS',
        );
      } else if (Platform.isMacOS) {
        analytics.setCurrentScreen(
          screenName: 'Calendar Screen',
          screenClassOverride: 'MacOS',
        );
      }
    }

    return Obx(
      () => Scaffold(
        appBar: AppBarCustom(
          textAppBar: "Calendar",
          trailing: Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${controller.pointDone}/${controller.pointAll}",
                  style: AppTextStyle.f16WhiteW600,
                ),
                Text(
                  "${controller.issueCount.value} Issues",
                  style: AppTextStyle.f10WhiteW400,
                )
              ],
            ),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: SmartRefresher(
          controller: controller.refreshController,
          onRefresh: controller.onRefresh,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const UpcomingDateComponent(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 25,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.greyDivider,
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  "${controller.dateLabel.value}, ${controller.dateName.value}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.f15BlackTextW500,
                ),
              ),
              controller.isLoading.value == true
                  ? const Expanded(
                      child: SlimCardListTimeboxShimmerWidget(),
                    )
                  : controller.listTimebox.isNotEmpty ||
                          controller.listIssue.isNotEmpty
                      ? UpcomingListComponent()
                      : const Expanded(
                          child: EmptyDataComponent(),
                        )
            ],
          ),
        ),
        floatingActionButton: Visibility(
          visible: controller.onChangeDate(),
          child: FloatingActionButton(
            onPressed: () async {
              IssueController.issueC.chcekMonth(
                controller.date.value,
              );

              var value = controller.date.value;
              var dateName =
                  "${value.day} ${IssueController.issueC.monthShow.value} ${value.year}";

              await Get.bottomSheet(
                persistent: false,
                CardIssueWidget(
                  key: const ValueKey("upcomingCreate"),
                  from: 'upcoming',
                  id: 0,
                  name: "",
                  description: "",
                  date: DateTime(
                    value.year,
                    value.month,
                    value.day,
                  ),
                  dateName: dateName,
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
                  from: "upcoming",
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
      ),
    );
  }
}
