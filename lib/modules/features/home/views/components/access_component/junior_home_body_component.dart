import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:get/get.dart';
import 'package:timebox/configs/themes/app_colors.dart';

import '../../../controllers/home_controller.dart';
import '../card_parent_home_body_component_widget.dart';
import '../custom_tab_bar_home_body_component_widget.dart';
import '../list_project_component.dart';
import '../list_project_shimmer_component.dart';

class JuniorHomeBodyComponent extends StatelessWidget {
  const JuniorHomeBodyComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CardParentHomeBodyComponentWidget.single(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomTabBarHomeBodyComponentWidget.single(
                title: 'My Project',
                isActive: HomeController.homeC.selectedTab.value == 1,
                onTap: () => HomeController.homeC.onTapMyProject(),
              ),
            ],
          ),
          Container(
            color: AppColors.white,
            child: Obx(
              () => Conditional.single(
                context: context,
                conditionBuilder: (context) =>
                    HomeController.homeC.isLoading.value,
                widgetBuilder: (context) => const ListProjectSimmerComponent(),
                fallbackBuilder: (context) => const ListProjectComponent(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
