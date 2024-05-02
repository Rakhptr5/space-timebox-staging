import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

///
/// From PanaraInfoDialogWidge;
///
class CustomPanaraDialog extends StatelessWidget {
  final String? title;
  final String message;
  final String? imagePath;
  final String buttonText;
  final VoidCallback? onTapDismiss;
  final PanaraDialogType panaraDialogType;
  final Color? color;
  final Color? textColor;
  final Color? buttonTextColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Widget? customButton;

  final bool noImage;
  const CustomPanaraDialog({
    Key? key,
    this.title,
    required this.message,
    required this.buttonText,
    this.onTapDismiss,
    required this.panaraDialogType,
    this.textColor = const Color(0xFF707070),
    this.color = const Color(0xFF179DFF),
    this.buttonTextColor,
    this.imagePath,
    this.padding = const EdgeInsets.all(24),
    this.margin = const EdgeInsets.all(24),
    this.customButton,
    required this.noImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color getColor() {
      return panaraDialogType == PanaraDialogType.normal
          ? PanaraColors.normal
          : panaraDialogType == PanaraDialogType.success
              ? PanaraColors.success
              : panaraDialogType == PanaraDialogType.warning
                  ? PanaraColors.warning
                  : panaraDialogType == PanaraDialogType.error
                      ? PanaraColors.error
                      : const Color(0xFF707070);
    }

    return Align(
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 340,
          ),
          margin: margin ?? const EdgeInsets.all(24),
          padding: padding ?? const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!noImage)
                Image.asset(
                  imagePath ?? 'assets/info.png',
                  package: imagePath != null ? null : 'panara_dialogs',
                  width: 84,
                  height: 84,
                  color: imagePath != null
                      ? null
                      : (panaraDialogType == PanaraDialogType.normal
                          ? PanaraColors.normal
                          : panaraDialogType == PanaraDialogType.success
                              ? PanaraColors.success
                              : panaraDialogType == PanaraDialogType.warning
                                  ? PanaraColors.warning
                                  : panaraDialogType == PanaraDialogType.error
                                      ? PanaraColors.error
                                      : color),
                ),
              if (!noImage)
                const SizedBox(
                  height: 24,
                ),
              if (title != null)
                Text(
                  title ?? "",
                  style: TextStyle(
                    fontSize: 24,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              if (title != null)
                const SizedBox(
                  height: 5,
                ),
              Text(
                message,
                style: TextStyle(
                  color: textColor,
                  height: 1.5,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              customButton ??
                  Material(
                    color: getColor(),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: onTapDismiss,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 50,
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
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: buttonTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
