import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';

class SlimCardListTimeboxShimmerWidget extends StatelessWidget {
  const SlimCardListTimeboxShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 10,
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
                  horizontal: DimensionConstant.pixel10,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: DimensionConstant.pixel8,
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
                    const SizedBox(
                      height: DimensionConstant.pixel5,
                    ),
                    Container(
                      height: DimensionConstant.pixel8,
                      width: DimensionConstant.pixel30,
                      decoration: BoxDecoration(
                        color: AppColors.grey.withOpacity(
                          DimensionConstant.double0Dot5,
                        ),
                        borderRadius: BorderRadius.circular(
                          DimensionConstant.double10Dot0,
                        ),
                      ),
                    ),
                  ],
                ),
                leading: Container(
                  margin: const EdgeInsets.only(
                    left: DimensionConstant.pixel15,
                  ),
                  height: DimensionConstant.pixel12,
                  width: DimensionConstant.pixel12,
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
              index == 9
                  ? const SizedBox()
                  : const Divider(
                      height: DimensionConstant.pixel1,
                    ),
            ],
          ),
        );
      },
    );
  }
}
