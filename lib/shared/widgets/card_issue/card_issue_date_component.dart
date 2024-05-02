import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/configs/themes/app_icon.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/modules/global_controllers/issue_controller.dart';
import 'package:timebox/shared/customs/time_picker_custom.dart';

class CardIssueDateComponent extends StatelessWidget {
  CardIssueDateComponent({super.key});

  final controller = IssueController.issueC;

  @override
  Widget build(BuildContext context) {
    controller.checkMinute(controller.date.value);
    controller.chcekMonth(controller.date.value);

    return Obx(
      () => Wrap(
        children: [
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// Tomorrow
                  InkWell(
                    hoverColor: Colors.transparent,
                    onTap: () => controller.tomorrowDate(),
                    child: const SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Icon(
                            Icons.sunny,
                            size: 23,
                            color: Colors.purple,
                          ),
                          SizedBox(width: 15),
                          Text(
                            'Tomorrow',
                            style: AppTextStyle.f13BlackW400,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  /// No Date
                  InkWell(
                    hoverColor: Colors.transparent,
                    onTap: () => controller.noDate(),
                    child: const SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Icon(
                            Icons.block,
                            size: 23,
                            color: AppColors.black,
                          ),
                          SizedBox(width: 15),
                          Text(
                            'No Date',
                            style: AppTextStyle.f13BlackW400,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Divider(height: 1),

                  /// Table Calendar
                  TableCalendar(
                    locale: "id",
                    calendarFormat: CalendarFormat.month,
                    availableGestures: AvailableGestures.horizontalSwipe,
                    firstDay: DateTime.now(),
                    lastDay: DateTime(DateTime.now().year + 10),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    focusedDay: controller.date.value,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month',
                    },
                    headerStyle: const HeaderStyle(
                      titleCentered: false,
                      leftChevronVisible: false,
                      rightChevronVisible: false,
                      titleTextStyle: AppTextStyle.f15BlackW600,
                      leftChevronMargin: EdgeInsets.zero,
                      leftChevronPadding: EdgeInsets.zero,
                      leftChevronIcon: AppIcon.backCalendar,
                      rightChevronMargin: EdgeInsets.zero,
                      rightChevronPadding: EdgeInsets.zero,
                      rightChevronIcon: AppIcon.forwardCalendar,
                      headerMargin: EdgeInsets.zero,
                      headerPadding: EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                    ),
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      cellMargin: EdgeInsets.zero,
                      tablePadding: EdgeInsets.zero,
                      defaultTextStyle: AppTextStyle.f15GreyTextW400,
                      selectedTextStyle: AppTextStyle.f15WhiteW600,
                      todayTextStyle: AppTextStyle.f15PrimaryW500,
                      weekendTextStyle: AppTextStyle.f15RedW600,
                      todayDecoration: const BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      weekendDecoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(
                          .75,
                        ),
                        shape: BoxShape.circle,
                      ),
                      defaultDecoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                    ),
                    onDaySelected: (day, focusedDay) async {
                      controller.onChangeDate(day);
                    },
                    selectedDayPredicate: (day) =>
                        isSameDay(controller.date.value, day),
                  ),
                  const SizedBox(height: 15),
                  const Divider(height: 1),
                  const SizedBox(height: 15),

                  /// Button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        minSize: 35,
                        color: AppColors.bgColorGrey,
                        padding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 10,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.edit,
                              color: AppColors.greyText,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              controller.hourName.value,
                              style: AppTextStyle.f15GreyTextW400,
                            ),
                          ],
                        ),
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (_) => Container(
                              padding: const EdgeInsets.all(
                                10,
                              ),
                              margin: EdgeInsets.zero,
                              height: 350,
                              decoration: const BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(
                                    20,
                                  ),
                                  topLeft: Radius.circular(
                                    20,
                                  ),
                                ),
                              ),
                              child: CupertinoDatePicker(
                                initialDateTime:
                                    controller.date.value.hour == 0 &&
                                            IssueController
                                                    .issueC.date.value.minute ==
                                                0
                                        ? DateTime.now()
                                        : controller.date.value,
                                mode: CupertinoDatePickerMode.time,
                                use24hFormat: true,
                                onDateTimeChanged: (DateTime newTime) {
                                  controller.onChangeHour(newTime);
                                },
                              ),
                            ),
                          );

                          var date = DateTime(
                            controller.date.value.year,
                            controller.date.value.month,
                            controller.date.value.day,
                            DateTime.now().hour,
                            DateTime.now().minute,
                          );

                          controller.onChangeHour(date);
                        },
                      ),
                      const SizedBox(width: 15),
                      CupertinoButton(
                        minSize: 35,
                        color: AppColors.bgColorGrey,
                        padding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 10,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.share_arrival_time_outlined,
                              color: AppColors.greyText,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              controller.pointName.value,
                              style: AppTextStyle.f15GreyTextW400,
                            ),
                          ],
                        ),
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (_) => Container(
                              padding: const EdgeInsets.all(
                                10,
                              ),
                              margin: EdgeInsets.zero,
                              height: 350,
                              decoration: const BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(
                                    20,
                                  ),
                                  topLeft: Radius.circular(
                                    20,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TimePickerCustom(
                                      key: const ValueKey("hour"),
                                      isHour: true,
                                      initial: int.parse(
                                        controller.pointHour.value,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TimePickerCustom(
                                      key: const ValueKey("minute"),
                                      isHour: false,
                                      initial: int.parse(
                                        IssueController
                                            .issueC.pointMinute.value,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 15),
                      CupertinoButton(
                        minSize: 35,
                        color: AppColors.bgColorGrey,
                        padding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 10,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.repeat_outlined,
                              color: AppColors.greyText,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              controller.repeatName.value,
                              style: AppTextStyle.f15GreyTextW400,
                            ),
                          ],
                        ),
                        onPressed: () {
                          const List<String> listRepeat = <String>[
                            '-',
                            'daily',
                            'weekly',
                          ];

                          int initial = 0;
                          if (controller.repeatName.value == "daily") {
                            initial = 1;
                          } else if (controller.repeatName.value == "weekly") {
                            initial = 2;
                          }

                          showCupertinoModalPopup(
                            context: context,
                            builder: (_) => Container(
                              padding: const EdgeInsets.all(
                                10,
                              ),
                              margin: EdgeInsets.zero,
                              height: 350,
                              decoration: const BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(
                                    20,
                                  ),
                                  topLeft: Radius.circular(
                                    20,
                                  ),
                                ),
                              ),
                              child: CupertinoPicker(
                                magnification: 1.22,
                                squeeze: 1.2,
                                useMagnifier: true,
                                itemExtent: 32,
                                onSelectedItemChanged: (int selectedItem) {
                                  if (selectedItem == 1) {
                                    controller.repeatName.value = "daily";
                                  } else if (selectedItem == 2) {
                                    controller.repeatName.value = "weekly";
                                  } else {
                                    controller.repeatName.value = "No Repeat";
                                  }
                                },
                                scrollController: FixedExtentScrollController(
                                  initialItem: initial,
                                ),
                                children: List<Widget>.generate(
                                  listRepeat.length,
                                  (int index) {
                                    return Center(
                                      child: Text(
                                        listRepeat[index],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      CupertinoButton(
                        minSize: 35,
                        color: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 10,
                        ),
                        child: const Icon(
                          Icons.send_sharp,
                          size: 20,
                        ),
                        onPressed: () {
                          Get.back();
                          controller.nameFocusNode.requestFocus();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
