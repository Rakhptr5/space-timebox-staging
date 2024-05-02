import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timebox/configs/routes/app_route.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';
import 'package:timebox/modules/features/home/controllers/home_controller.dart';
import 'package:timebox/modules/features/home/views/components/card_my_squad_item_widget.dart';

class ListMySquadComponent extends StatelessWidget {
  const ListMySquadComponent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => HomeController.homeC.listSquadModel.isNotEmpty
          ? ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: HomeController.homeC.listSquadModel.length,
              itemBuilder: (context, index) {
                var data = HomeController.homeC.listSquadModel[index];

                return CardMySquadItemWidget(
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.mySquadRoute,
                      arguments: [
                        data.nama ?? "",
                        data.id ?? 0,
                        data.humanisPositionName ?? "",
                        data.humanisFoto ?? "",
                        data.checkedAt ?? "",
                      ],
                    );
                  },
                  imageUrl: data.humanisFoto ?? '',
                  title: data.nama ?? '',
                  desc: data.humanisPositionName ?? '',
                  number: '${data.countIssue}',
                  checkedAt: data.checkedAt,
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(
                height: 1,
                color: AppColors.greyDivider,
              ),
            )
          : const SizedBox(
              height: DimensionConstant.pixel25,
            ),
    );
  }
}
