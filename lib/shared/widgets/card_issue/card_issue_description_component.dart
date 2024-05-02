import 'package:flutter/material.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/modules/global_controllers/issue_controller.dart';

class CardIssueDescriptionComponent extends StatelessWidget {
  CardIssueDescriptionComponent({
    super.key,
    required this.readOnly,
  });

  final bool readOnly;

  final controller = IssueController.issueC;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            readOnly: readOnly,
            focusNode: controller.descriptionFocusNode,
            controller: controller.descriptionTextController,
            style: AppTextStyle.f18GreyTextW400,
            decoration: const InputDecoration.collapsed(
              hintText: 'Description',
              hintStyle: AppTextStyle.f18GreyThroughW400,
            ),
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
        ),
      ],
    );
  }
}
