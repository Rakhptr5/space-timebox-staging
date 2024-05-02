import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/modules/global_controllers/issue_controller.dart';

class CardIssueAcceptanceComponent extends StatelessWidget {
  const CardIssueAcceptanceComponent({
    super.key,
    required this.name,
    required this.id,
    required this.timeboxId,
    required this.status,
    required this.controller,
    required this.readOnly,
    required this.vivibleButton,
    this.onTapUpdateAcceptance,
  });

  final int id;
  final int timeboxId;
  final String status;
  final TextEditingController controller;
  final String name;
  final bool readOnly, vivibleButton;
  final Function()? onTapUpdateAcceptance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: vivibleButton
              ? () {
                  onTapUpdateAcceptance;
                  IssueController.issueC.updateAcceptanceStatus(
                    id: id,
                    timeboxId: timeboxId,
                    status: (status == "1") ? "" : "1",
                  );
                }
              : null,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.greyDivider,
              ),
            ),
            child: (status == "1")
                ? null
                : const Icon(
                    Icons.check,
                    size: 18,
                    color: AppColors.grey,
                  ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextFormField(
            controller: controller,
            onFieldSubmitted: (status == "")
                ? null
                : (value) {
                    if (value.isEmpty || value == "") {
                      IssueController.issueC.deleteAsseptance(
                        id: id,
                        timeboxId: timeboxId,
                      );
                    } else {
                      IssueController.issueC.updateAcceptance(
                        id: id,
                        name: value,
                      );
                    }
                  },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                bottom: 10,
                top: 10,
              ),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.greyDivider,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: (status == "1" && readOnly == false)
                      ? AppColors.primaryColor
                      : AppColors.greyDivider,
                ),
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.greyDivider,
                ),
              ),
              isCollapsed: true,
            ),
            maxLines: 1,
            readOnly: (status == "1" && readOnly == false) ? false : true,
            style: AppTextStyle.f14BlackW400.copyWith(
              decoration: (status == "1")
                  ? TextDecoration.none
                  : TextDecoration.lineThrough,
            ),
          ),
        )
      ],
    );
  }
}

class CardIssueAddAcceptanceComponent extends StatelessWidget {
  CardIssueAddAcceptanceComponent({
    super.key,
    required this.id,
    this.onCreatedAcceptance,
  });

  final controller = IssueController.issueC;
  final focus = FocusNode();
  final autofocus = false.obs;
  final int id;
  final Function()? onCreatedAcceptance;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: () {
          FocusScope.of(context).requestFocus(focus);
          controller.isAcceptanceEdit.value = true;
          autofocus.value = true;
        },
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: const Icon(
                Icons.add,
                color: AppColors.blueUnderline,
                size: 21,
              ),
            ),
            const SizedBox(width: 8),
            (!controller.isAcceptanceEdit.value)
                ? const Text(
                    "Add Acceptances",
                    style: AppTextStyle.f14GreyTextW400,
                  )
                : Expanded(
                    child: TextFormField(
                      controller: controller.acceptanceCtrl,
                      onFieldSubmitted: (value) {
                        if (id == 0) {
                          controller.createTemptAcceptance(
                            timeboxId: 0,
                            name: value,
                          );
                        } else {
                          controller.createAcceptance(
                            timeboxId: controller.id.value,
                            name: value,
                          );
                        }
                        onCreatedAcceptance;
                        controller.acceptanceCtrl.clear();
                        autofocus.value = true;
                        FocusScope.of(context).requestFocus(focus);
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(
                          bottom: 10,
                          top: 10,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.greyDivider,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.primaryColor,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.greyDivider,
                          ),
                        ),
                        hintText: 'Add Acceptances',
                        hintStyle: AppTextStyle.f14GreyTextW400,
                        isCollapsed: true,
                      ),
                      autofocus: autofocus.value,
                      maxLines: 1,
                      focusNode: focus,
                      style: AppTextStyle.f14BlackW400,
                      readOnly: !controller.isAcceptanceEdit.value,
                      enabled: controller.isAcceptanceEdit.value,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
