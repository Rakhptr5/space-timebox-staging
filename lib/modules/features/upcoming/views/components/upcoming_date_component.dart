import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/configs/themes/app_icon.dart';
import 'package:timebox/configs/themes/app_text_style.dart';
import 'package:timebox/constants/cores/dimension_constant.dart';
import 'package:timebox/modules/features/upcoming/controllers/upcoming_controller.dart';

class UpcomingDateComponent extends StatelessWidget {
  const UpcomingDateComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: (kIsWeb == true || Platform.isAndroid || Platform.isWindows)
            ? DimensionConstant.pixel25
            : DimensionConstant.pixel15,
      ),
      child: Obx(
        () => TableCalendar(
          locale: "id",
          calendarFormat: CalendarFormat.week,
          availableGestures: AvailableGestures.horizontalSwipe,
          firstDay: DateTime(DateTime.now().year - 10),
          lastDay: DateTime(DateTime.now().year + 10),
          startingDayOfWeek: StartingDayOfWeek.monday,
          focusedDay: UpcomingController.upcomingC.date.value,
          availableCalendarFormats: const {
            CalendarFormat.week: 'Week',
          },
          headerStyle: HeaderStyle(
            titleCentered: true,
            titleTextStyle: AppTextStyle.f15BlackW600,
            leftChevronMargin: EdgeInsets.zero,
            leftChevronPadding: EdgeInsets.zero,
            leftChevronIcon: AppIcon.backCalendar,
            rightChevronMargin: EdgeInsets.zero,
            rightChevronPadding: EdgeInsets.zero,
            rightChevronIcon: AppIcon.forwardCalendar,
            headerMargin: EdgeInsets.zero,
            headerPadding: EdgeInsets.only(
              top: 0,
              right:
                  (kIsWeb == true || Platform.isAndroid || Platform.isWindows)
                      ? DimensionConstant.pixel20
                      : DimensionConstant.pixel10,
              left: (kIsWeb == true || Platform.isAndroid || Platform.isWindows)
                  ? DimensionConstant.pixel20
                  : DimensionConstant.pixel10,
              bottom:
                  (kIsWeb == true || Platform.isAndroid || Platform.isWindows)
                      ? DimensionConstant.pixel25
                      : DimensionConstant.pixel15,
            ),
          ),
          calendarStyle: CalendarStyle(
            outsideDaysVisible: false,
            tablePadding: EdgeInsets.zero,
            defaultTextStyle: AppTextStyle.f15GreyTextW400,
            selectedTextStyle: AppTextStyle.f15WhiteW600,
            todayTextStyle: AppTextStyle.f15PrimaryW500,
            weekendTextStyle: AppTextStyle.f15RedW600,
            todayDecoration: const BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.rectangle,
            ),
            selectedDecoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(
                DimensionConstant.double0Dot75,
              ),
              shape: BoxShape.rectangle,
            ),
            weekendDecoration: const BoxDecoration(
              shape: BoxShape.rectangle,
            ),
            defaultDecoration: const BoxDecoration(
              shape: BoxShape.rectangle,
            ),
          ),
          onDaySelected: (day, focusedDay) async {
            UpcomingController.upcomingC.selectedDay(day);
          },
          selectedDayPredicate: (day) =>
              isSameDay(UpcomingController.upcomingC.date.value, day),
        ),
      ),
    );
  }
}
