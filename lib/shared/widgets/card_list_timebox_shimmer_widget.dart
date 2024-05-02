import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';

class CardListTimeboxShimmerWidget extends StatelessWidget {
  const CardListTimeboxShimmerWidget({
    super.key,
    this.from = "all",
  });

  final String from;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 5,
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 1);
      },
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: AppColors.grey,
          highlightColor: AppColors.primaryColor,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: DimensionConstant.pixel20,
              vertical: DimensionConstant.pixel10,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: DimensionConstant.pixel10,
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
                  height: DimensionConstant.pixel10,
                ),
                Container(
                  height: DimensionConstant.pixel8,
                  width: DimensionConstant.pixel100,
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
              height: DimensionConstant.pixel12,
              width: DimensionConstant.pixel12,
              margin: const EdgeInsets.only(
                left: DimensionConstant.pixel10,
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
        );
      },
    );
  }
}
