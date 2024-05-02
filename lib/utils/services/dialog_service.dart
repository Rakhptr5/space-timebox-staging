import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';
import 'package:timebox/shared/widgets/custom_panara_dialog.dart';

class DialogServices {
  static void generalSnackbar({
    required BuildContext context,
    required final String message,
    final String buttonText = 'Oke',
    final Function()? onTap,
    final PanaraDialogType? dialogType,
  }) {
    PanaraInfoDialog.show(
      context,
      message: message,
      buttonText: buttonText,
      onTapDismiss: onTap ??
          () {
            Get.back();
          },
      panaraDialogType: dialogType ?? PanaraDialogType.normal,
    );
  }

  static customGeneralDialog({
    required BuildContext context,
    required final String message,
    final String buttonText = 'Oke',
    final Function()? onTap,
    final PanaraDialogType? dialogType,
  }) {
    Color getColor() {
      return dialogType == PanaraDialogType.normal
          ? PanaraColors.normal
          : dialogType == PanaraDialogType.success
              ? PanaraColors.success
              : dialogType == PanaraDialogType.warning
                  ? PanaraColors.warning
                  : dialogType == PanaraDialogType.error
                      ? PanaraColors.error
                      : const Color(0xFF707070);
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => CustomPanaraDialog(
        message: message,
        buttonText: buttonText,
        panaraDialogType: dialogType ?? PanaraDialogType.normal,
        noImage: false,
        customButton: Material(
          color: getColor(),
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: onTap ??
                () {
                  Get.back();
                },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: DimensionConstant.pixel40,
              width: DimensionConstant.pixel100,
              decoration: BoxDecoration(
                border: Border.all(color: getColor()),
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
              ),
              alignment: Alignment.center,
              child: Text(
                buttonText,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: DimensionConstant.pixel18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static void loadingDialog({
    required Widget child,
  }) {
    Get.dialog(
      child,
      barrierDismissible: false,
    );
  }

  static void closeDialog() {
    Get.back();
  }
}
