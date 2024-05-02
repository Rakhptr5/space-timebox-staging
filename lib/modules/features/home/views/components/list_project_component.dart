import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timebox/configs/routes/app_route.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/modules/features/home/controllers/home_controller.dart';
import 'package:timebox/shared/customs/list_tile_custom.dart';

class ListProjectComponent extends StatelessWidget {
  const ListProjectComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeController.homeC.listProject.isNotEmpty == true
        ? ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: HomeController.homeC.listProject.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ListTileCustom(
                title: HomeController.homeC.listProject[index].name!,
                icon: const Icon(
                  Icons.group_outlined,
                ),
                trailing: Text(
                  "${HomeController.homeC.listProject[index].countTimebox!}",
                ),
                onTap: () {
                  Get.toNamed(
                    AppRoutes.projectRoute,
                    arguments: [
                      HomeController.homeC.listProject[index].name!,
                      HomeController.homeC.listProject[index].mProjectId!,
                    ],
                  );
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
              height: 1,
              color: AppColors.greyDivider,
            ),
          )
        : const SizedBox();
  }
}
