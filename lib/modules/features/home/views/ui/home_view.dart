import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timebox/configs/routes/app_route.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/constants/cores/assets_constant.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';
import 'package:timebox/modules/features/home/controllers/home_controller.dart';
import 'package:timebox/modules/features/home/views/components/home_body_component.dart';
import 'package:timebox/modules/global_controllers/issue_controller.dart';
import 'package:timebox/shared/widgets/card_issue/card_issue_widget.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      analytics.setCurrentScreen(
        screenName: 'Home Screen',
        screenClassOverride: 'Web',
      );
    } else {
      if (Platform.isAndroid) {
        analytics.setCurrentScreen(
          screenName: 'Home Screen',
          screenClassOverride: 'Android',
        );
      } else if (Platform.isIOS) {
        analytics.setCurrentScreen(
          screenName: 'Home Screen',
          screenClassOverride: 'IOS',
        );
      } else if (Platform.isMacOS) {
        analytics.setCurrentScreen(
          screenName: 'Home Screen',
          screenClassOverride: 'MacOS',
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.bgColorGrey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primaryColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        elevation: 2,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
          ),
          child: Row(
            children: [
              Image.asset(
                AssetConstants.logoWhite,
                height: DimensionConstant.pixel25,
              ),
              const Spacer(),
              GestureDetector(
                child: Obx(
                  () => HomeController.homeC.photo.value.isEmpty
                      ? const SizedBox()
                      : CachedNetworkImage(
                          imageUrl: HomeController.homeC.photo.value,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => const SizedBox(
                            width: DimensionConstant.pixel35,
                            height: DimensionConstant.pixel35,
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => Container(
                            width: 35,
                            height: 35,
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                ),
                onTap: () {
                  Get.toNamed(AppRoutes.profileRoute);
                },
              ),
            ],
          ),
        ),
        actions: null,
        leading: null,
        centerTitle: false,
      ),
      resizeToAvoidBottomInset: false,
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        controller: HomeController.homeC.refreshController,
        onRefresh: HomeController.homeC.onRefresh,
        child: const HomeBodyComponent(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.bottomSheet(
            persistent: false,
            CardIssueWidget(
              from: 'home',
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
                top: Radius.circular(
                  DimensionConstant.pixel20,
                ),
              ),
            ),
            backgroundColor: Colors.white,
          ).whenComplete(
            () => IssueController.issueC.onBottomSheetClosed(
              from: "home",
            ),
          );
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
