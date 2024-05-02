import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/modules/global_controllers/issue_controller.dart';
import 'package:timebox/shared/widgets/card_issue/card_issue_widget.dart';

class ListIssueController extends GetxController {
  static ListIssueController get to => Get.find();

  /// Setting View
  List<String> setDateName({
    required String dateName,
    required bool isOverdue,
    required String from,
  }) {
    /// Setting Date
    String dateShow = dateName;
    String dateValue = dateName;

    if (dateName != "No Date") {
      if (isOverdue == true) {
        if (dateShow.split(", ")[1] == "00:00") {
          dateShow = dateShow.split(", ")[0];
          dateValue = dateShow.split(", ")[0];
        }
      } else {
        if (dateName.split(", ").length == 2) {
          if (from == "today") {
            dateShow = dateName.split(", ")[1];
            dateValue = dateName;

            if (dateShow == "00:00") {
              dateShow = "No Date";
              dateValue = dateName.split(", ")[0];
            }
          } else if (from == "upcoming") {
            dateShow = dateName.split(", ")[1];
            dateValue = dateName;

            if (dateShow == "00:00") {
              dateShow = "No Date";
              dateValue = dateName.split(", ")[0];
            }
          } else {
            dateShow = dateName;
            dateValue = dateName;

            if (dateShow.split(", ")[1] == "00:00") {
              dateShow = dateShow.split(", ")[0];
              dateValue = dateShow.split(", ")[0];
            }
          }
        } else {
          dateShow = dateName;
          dateValue = dateName;
        }
      }
    } else {
      dateShow = "No Date";
      dateValue = "No Date";
    }

    return [dateShow, dateValue];
  }

  Color setDayColor({
    required String status,
    required DateTime date,
  }) {
    if (status == "0") {
      return AppColors.redColor;
    } else if (status == "1" && date.hour < DateTime.now().hour) {
      return AppColors.redColor;
    } else if (status == "1" &&
        date.hour >= DateTime.now().hour &&
        date.minute > DateTime.now().minute) {
      return AppColors.green;
    } else if (status == "1" &&
        date.hour <= DateTime.now().hour &&
        date.minute < DateTime.now().minute) {
      return AppColors.redColor;
    } else if (status == "1" && date.hour > DateTime.now().hour) {
      return AppColors.green;
    } else if (status == "2") {
      return Colors.purple;
    } else {
      return AppColors.greyText;
    }
  }

  /// On Tap Setting
  Future<void> onTapUpdate({
    required int id,
    required int userId,
    required int assigneBy,
    required int createdBy,
    required String from,
    required String status,
    required String repeat,
    required String isAccept,
    required bool isSlide,
  }) async {
    /// Redundant click
    DateTime? loginClickTime;
    DateTime dateTime = DateTime.now();
    bool isRedundentClick() {
      if (loginClickTime == null) {
        loginClickTime = dateTime;
        return false;
      }
      if (dateTime.difference(loginClickTime!).inSeconds < 10) {
        // set this difference time in seconds
        return true;
      }

      loginClickTime = dateTime;
      return false;
    }

    dateTime = DateTime.now();
    if (isRedundentClick()) {
      return;
    }

    if (!isSlide && userId != assigneBy) {
      return;
    } else {
      if (createdBy != userId) {
        if (isAccept == "1") {
          return;
        }

        await IssueController.issueC.updateIsAccept(
          id: id,
          from: from,
          isAccept: isAccept == "0" ? "1" : "0",
        );
      } else {
        await IssueController.issueC.updateIssue(
          id: id,
          from: from,
          status: status == "open" ? "0" : "1",
          repeat: repeat,
        );
      }
    }
  }

  Future<void> onTapDelete({
    required int id,
    required String from,
    required fToast,
  }) async {
    return await IssueController.issueC.deleteIssue(
      id: id,
      from: from,
      fToast: fToast,
    );
  }

  Future<void> onTapReject({
    required int id,
    required String from,
  }) async {
    return await IssueController.issueC.updateIsAccept(
      id: id,
      isAccept: "",
      from: from,
    );
  }

  void onTapListTimebox({
    required int id,
    required int userId,
    required int projectId,
    required int assigneBy,
    required int createdBy,
    required String from,
    required String name,
    required String description,
    required String point,
    required String date,
    required String status,
    required String statusDay,
    required String pointName,
    required String dateName,
    required String projectName,
    required bool isOverdue,
    required bool isSlide,
    required String isAccept,
    required String repeat,
    required String assigneName,
    required String assignePhoto,
    required String createdName,
    required int acceptanceDone,
    int? userAuthId,
    Function()? onTapUpdateAcceptanceStatus,
    Function()? onCreatedAcceptance,
  }) {
    print(assignePhoto);

    Get.bottomSheet(
      persistent: false,
      CardIssueWidget(
        from: from,
        id: id,
        authId: assigneBy,
        userAuthId: userAuthId,
        name: name,
        description: description == "0" ? "" : description,
        assigneName: assigneName,
        assignePhoto: assignePhoto,
        createdName: createdName,
        date: dateName == "No Date" ? DateTime.now() : DateTime.parse(date),
        dateName: dateName,
        pointJam: pointName,
        projectId: projectId,
        projectName: projectName,
        repeat: repeat,
        readOnly: (isSlide == false) ? true : false,
        myId: userId,
        createdBy: createdBy,
        acceptanceDone: acceptanceDone,
        onTapUpdateAcceptanceStatus: onTapUpdateAcceptanceStatus,
        onCreatedAcceptance: onCreatedAcceptance,
        isEdit: true,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
    ).whenComplete(
        () => IssueController.issueC.onBottomSheetClosed(from: from));
  }
}
