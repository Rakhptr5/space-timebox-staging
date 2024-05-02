import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timebox/constants/cores/assets_constant.dart';
import '../../../../../configs/themes/app_colors.dart';
import '../../../../../configs/themes/app_text_style.dart';
import '../../../../../constants/cores/dimension_constant.dart';
import '../../controllers/my_squad_controller.dart';
import 'closed_issue_component.dart';
import 'instruction_issue_component.dart';
import 'open_issue_component.dart';

class MySquadNewComponent extends StatelessWidget {
  MySquadNewComponent({super.key});

  final controller = MySquadController.to;

  @override
  Widget build(BuildContext context) {
    FToast fToast = FToast();
    fToast.init(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          /// Top Name Widget
          Container(
            color: AppColors.whiteDarker05.withOpacity(0.5),
            padding: const EdgeInsets.symmetric(
              vertical: DimensionConstant.pixel15,
              horizontal: DimensionConstant.pixel25,
            ).copyWith(
              top: DimensionConstant.pixel24,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: controller.photo.value,
                  imageBuilder: (context, imageProvider) => Container(
                    width: DimensionConstant.pixel30,
                    height: DimensionConstant.pixel30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(controller.photo.value),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholder: (context, url) => const SizedBox(
                    width: DimensionConstant.pixel30,
                    height: DimensionConstant.pixel30,
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    size: DimensionConstant.pixel12,
                  ),
                ),
                const SizedBox(width: DimensionConstant.pixel12),
                Expanded(
                  child: Text(
                    controller.title.value,
                    style: AppTextStyle.f16BlackTextW500.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ),
                const SizedBox(width: DimensionConstant.pixel12),
                SizedBox(
                  width: DimensionConstant.pixel24,
                  height: DimensionConstant.pixel24,
                  child: FilledButton(
                    onPressed: () => controller.onRefresh(),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          DimensionConstant.pixel4,
                        ),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Padding(
                        padding:
                            const EdgeInsets.all(DimensionConstant.pixel22),
                        child: Image.asset(
                          AssetConstants.icRefresh,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 1,
            color: AppColors.greyDivider,
          ),

          /// closed
          ClosedIssueComponent(controller: controller, fToast: fToast),

          /// open issue
          OpenIssueComponent(controller: controller, fToast: fToast),

          /// instruction
          InstructionIssueComponent(controller: controller, fToast: fToast),

          /// spacing
          const SizedBox(
            height: DimensionConstant.pixel50,
          ),
        ],
      ),
    );
  }
}
