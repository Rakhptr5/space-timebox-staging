import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:flutter_conditional_rendering/conditional_switch.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';
import '../card_parent_home_body_component_widget.dart';
import '../custom_tab_bar_home_body_component_widget.dart';
import '../list_my_squad_component.dart';
import '../list_project_component.dart';
import '../list_project_shimmer_component.dart';

class LeadHomeBodyComponent extends StatelessWidget {
  const LeadHomeBodyComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        return HomeController.homeC.onPanUpdate(details);
      },
      child: CardParentHomeBodyComponentWidget(
        child: Obx(
          () => Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: CustomTabBarHomeBodyComponentWidget(
                      title: 'My Squad',
                      isActive: HomeController.homeC.selectedTab.value == 0,
                      onTap: () => HomeController.homeC.onTapMySquad(),
                    ),
                  ),
                  Expanded(
                    child: CustomTabBarHomeBodyComponentWidget(
                      title: 'My Project',
                      isActive: HomeController.homeC.selectedTab.value == 1,
                      onTap: () => HomeController.homeC.onTapMyProject(),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onPanUpdate: (details) =>
                    HomeController.homeC.onPanUpdate(details),
                child: ConditionalSwitch.single(
                  context: context,
                  valueBuilder: (context) =>
                      HomeController.homeC.selectedTab.value,
                  caseBuilders: {
                    0: (context) => Conditional.single(
                          context: context,
                          conditionBuilder: (context) =>
                              HomeController.homeC.isLoading.value,
                          widgetBuilder: (context) =>
                              const ListProjectSimmerComponent(),
                          fallbackBuilder: (context) =>
                              const ListMySquadComponent(),
                        ),
                    1: (context) => Conditional.single(
                          context: context,
                          conditionBuilder: (context) =>
                              HomeController.homeC.isLoading.value,
                          widgetBuilder: (context) =>
                              const ListProjectSimmerComponent(),
                          fallbackBuilder: (context) =>
                              const ListProjectComponent(),
                        ),
                  },
                  fallbackBuilder: (context) => const SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
