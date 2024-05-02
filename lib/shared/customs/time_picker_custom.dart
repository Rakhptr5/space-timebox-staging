import 'package:flutter/cupertino.dart';
import 'package:timebox/modules/global_controllers/issue_controller.dart';

class TimePickerCustom extends StatelessWidget {
  const TimePickerCustom({
    super.key,
    required this.isHour,
    required this.initial,
  });

  final bool isHour;
  final int initial;

  @override
  Widget build(BuildContext context) {
    List<String> array;
    int initialHourse = 0;

    if (isHour) {
      array = <String>[
        '-',
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
      ];
      initialHourse = initial;
    } else {
      if (initial == 15) {
        initialHourse = 1;
      } else if (initial == 30) {
        initialHourse = 2;
      } else if (initial == 45) {
        initialHourse = 3;
      } else {
        initialHourse = 0;
      }

      array = <String>[
        '-',
        '15',
        '30',
        '45',
      ];
    }

    return CupertinoPicker(
      magnification: 1.22,
      squeeze: 1.2,
      useMagnifier: true,
      itemExtent: 32,
      onSelectedItemChanged: (int selectedItem) {
        if (isHour) {
          IssueController.issueC.pointHour.value = selectedItem.toString();
        } else {
          if (selectedItem == 1) {
            selectedItem = 15;
          } else if (selectedItem == 2) {
            selectedItem = 30;
          } else if (selectedItem == 3) {
            selectedItem = 45;
          }

          if (IssueController.issueC.pointHour.value != "8") {
            IssueController.issueC.pointMinute.value = selectedItem.toString();
          } else {
            IssueController.issueC.pointMinute.value = "0";
          }
        }

        if (IssueController.issueC.pointMinute.value == "0") {
          IssueController.issueC.pointName.value =
              IssueController.issueC.pointHour.value;
        } else {
          IssueController.issueC.pointName.value =
              "${IssueController.issueC.pointHour.value}.${IssueController.issueC.pointMinute.value}";
        }
      },
      scrollController: FixedExtentScrollController(initialItem: initialHourse),
      children: List<Widget>.generate(
        array.length,
        (int index) {
          return Center(
            child: Text(
              array[index],
            ),
          );
        },
      ),
    );
  }
}
