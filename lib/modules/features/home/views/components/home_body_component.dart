import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:get/get.dart';
import 'package:timebox/configs/routes/app_route.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/constants/cores/assets_constant.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';
import 'package:timebox/modules/features/home/controllers/home_controller.dart';
import 'package:timebox/modules/features/home/views/components/access_component/junior_home_body_component.dart';
import 'package:timebox/shared/customs/list_tile_custom.dart';

import 'access_component/lead_home_body_component_widget.dart';

class HomeBodyComponent extends StatelessWidget {
  const HomeBodyComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 3),
                    blurRadius: 5,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ],
              ),
              margin: const EdgeInsets.all(
                DimensionConstant.pixel25,
              ),
              child: Column(
                children: [
                  ListTileCustom(
                    title: "Waiting List",
                    icon: const Icon(
                      Icons.inbox_outlined,
                      size: 24,
                    ),
                    trailing: Text(
                      HomeController.homeC.countBacklog.value,
                      style: AppTextStyle.f14BlackTextW400,
                    ),
                    onTap: () {
                      Get.toNamed(AppRoutes.backlogRoute);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: AppColors.greyDivider,
                  ),
                  ListTileCustom(
                    title: "Scheduled",
                    icon: const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.green,
                      size: 24,
                    ),
                    trailing: Text(
                      HomeController.homeC.countToday.value,
                      style: AppTextStyle.f14BlackTextW400,
                    ),
                    onTap: () {
                      Get.toNamed(AppRoutes.todayRoute);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: AppColors.greyDivider,
                  ),
                  ListTileCustom(
                    title: "Calendar",
                    icon: const Icon(
                      Icons.calendar_month_outlined,
                      color: Colors.purple,
                      size: 24,
                    ),
                    onTap: () {
                      Get.toNamed(AppRoutes.upcomingRoute);
                    },
                  ),
                  const Divider(
                    height: 1,
                    color: AppColors.greyDivider,
                  ),
                  ListTileCustom(
                    title: "Instruction",
                    icon: Image.asset(
                      AssetConstants.icInstruction,
                      width: 24,
                      height: 24,
                    ),
                    trailing: Text(
                      HomeController.homeC.countInstraction.value,
                      style: AppTextStyle.f14BlackTextW400,
                    ),
                    onTap: () {
                      Get.toNamed(AppRoutes.instruction);
                    },
                  ),
                ],
              ),
            ),

            /// TabBar
            ConditionalSwitch.single(
              context: context,
              valueBuilder: (context) =>
                  HomeController.homeC.levelJabatan.value,
              caseBuilders: {
                "staff": (context) => const JuniorHomeBodyComponent(),
                "supervisor": (context) => const LeadHomeBodyComponent(),
                "managerial": (context) => const LeadHomeBodyComponent(),
              },
              fallbackBuilder: (context) => const JuniorHomeBodyComponent(),
            ),
          ],
        ),
      ),
    );
  }
}
