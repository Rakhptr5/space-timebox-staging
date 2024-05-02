import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timebox/modules/features/instruction/controllers/instruction_controller.dart';
import 'package:timebox/modules/features/instruction/views/components/instruction_list_component.dart';
import 'package:timebox/shared/customs/appbar_custom.dart';
import 'package:timebox/shared/widgets/card_list_timebox_shimmer_widget.dart';
import 'package:timebox/shared/widgets/empty_data_component.dart';
import 'package:timebox/utils/services/hive_service.dart';

class InstructionView extends StatelessWidget {
  InstructionView({super.key});

  final analytics = FirebaseAnalytics.instance;
  final controller = InstructionController.to;

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
        appBar: AppBarCustom(
          textAppBar: 'Instruction',
          trailing: IconButton(
            tooltip: (controller.isByProject.value)
                ? "Fillter By Date"
                : " Fillter By Project",
            onPressed: () async {
              if (controller.isByProject.value) {
                controller.isByProject.value = false;
                await HiveServices.box.put("instructionIsByProject", false);
                controller.onRefresh();
              } else {
                controller.isByProject.value = true;
                await HiveServices.box.put("instructionIsByProject", true);
                controller.onRefresh();
              }
            },
            padding: const EdgeInsets.only(right: 25),
            icon: Icon(
              (controller.isByProject.value)
                  ? Icons.calendar_month_rounded
                  : Icons.account_balance_rounded,
            ),
          ),
        ),
        body: SmartRefresher(
          enablePullDown: true,
          controller: controller.refreshController,
          onRefresh: controller.onRefresh,
          child: controller.isLoading.value == true
              ? const CardListTimeboxShimmerWidget(from: "instruction")
              : controller.listData.isNotEmpty
                  ? InstructionListComponent()
                  : const EmptyDataComponent(),
        ),
      ),
    );
  }
}
