import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';

class ListProjectSimmerComponent extends StatelessWidget {
  const ListProjectSimmerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 5,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: AppColors.grey,
          highlightColor: AppColors.primaryColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: DimensionConstant.pixel20,
                  vertical: DimensionConstant.pixel5,
                ),
                title: Container(
                  height: DimensionConstant.pixel12,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(
                      DimensionConstant.double0Dot5,
                    ),
                    borderRadius: BorderRadius.circular(
                      DimensionConstant.double10Dot0,
                    ),
                  ),
                ),
                leading: Container(
                  height: DimensionConstant.pixel15,
                  width: DimensionConstant.pixel15,
                  margin: const EdgeInsets.only(
                    left: DimensionConstant.pixel5,
                    top: DimensionConstant.pixel5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      DimensionConstant.double10Dot0,
                    ),
                    color: AppColors.grey.withOpacity(
                      DimensionConstant.double0Dot5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, __) => const Divider(
        height: DimensionConstant.pixel1,
      ),
    );
  }
}
