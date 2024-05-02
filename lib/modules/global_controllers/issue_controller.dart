import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:timebox/configs/themes/app_colors.dart';
import 'package:timebox/constants/cores/hive_constant.dart';
import 'package:timebox/modules/features/backlog/controllers/backlog_controller.dart';
import 'package:timebox/modules/features/home/controllers/home_controller.dart';
import 'package:timebox/modules/features/home/models/squad_model/squad_model.dart';
import 'package:timebox/modules/features/instruction/controllers/instruction_controller.dart';
import 'package:timebox/modules/features/my_squad/controllers/my_squad_controller.dart';
import 'package:timebox/modules/features/project/controllers/project_controller.dart';
import 'package:timebox/modules/features/today/controllers/today_controller.dart';
import 'package:timebox/modules/features/upcoming/controllers/upcoming_controller.dart';
import 'package:timebox/modules/global_controllers/list_issue_controller.dart';
import 'package:timebox/modules/global_modules/acceptance_model.dart';
import 'package:timebox/modules/global_modules/create_issue_model.dart';
import 'package:timebox/modules/global_modules/update_is_accept_model.dart';
import 'package:timebox/modules/global_modules/update_issue_model.dart';
import 'package:timebox/modules/global_repositories/issue_repository.dart';
import 'package:timebox/utils/services/dialog_service.dart';
import 'package:timebox/utils/services/hive_service.dart';
import 'package:timebox/utils/services/notification_service.dart';

import '../features/home/models/home_model.dart';

class IssueController extends GetxController {
  static IssueController get issueC => Get.find();

  var authId = 0.obs;
  var authName = "".obs;
  var id = 0.obs;
  var date = DateTime.now().obs;
  var projectId = 0.obs;
  var projectName = "".obs;
  var dateName = "No Date".obs;
  var hourName = "Setting Jam".obs;
  var pointName = "0".obs;
  var pointHour = "0".obs;
  var pointMinute = "0".obs;
  var repeatName = "No Repeat".obs;
  var assigneName = "".obs;
  var assignePhoto = "".obs;
  var acceptanceDone = 0.obs;
  var myId = 0.obs;

  var isSelectedDay = "".obs;
  var isFrist = false.obs;
  var isLoading = false.obs;
  var isAcceptenceLoading = false.obs;
  var isAcceptanceEdit = false.obs;

  var monthShow = "".obs;
  var hourShow = "".obs;
  var minuteShow = "".obs;

  var selectedMinute = 0.obs;
  var selectedHour = 0.obs;

  var showAssignee = false.obs;

  final nameTextController = TextEditingController();
  late FocusNode nameFocusNode = FocusNode();

  final descriptionTextController = TextEditingController();
  late FocusNode descriptionFocusNode = FocusNode();

  RxList<SquadModel> listSquadModel = RxList<SquadModel>([]);
  Rx<SquadModel> selectedSquadModel = Rx<SquadModel>(SquadModel());

  RxList<AcceptanceItem?> listAcceptance = RxList([]);
  RxList<AcceptanceItem?> temptListAcceptance = RxList([]);
  TextEditingController acceptanceCtrl = TextEditingController();

  ///Update Issue fuction
  Future<void> updateIssue({
    required int id,
    required String from,
    required String status,
    required String repeat,
  }) async {
    var fToast = FToast();
    if (from != "mySquad" && authId.value == 0) {
      authId.value = await HiveServices.box.get('id');
    }

    UpdateIssueResponseModel response = await IssueRepository.updateIssue(
      id: id,
      status: status,
    );

    if (response.statusCode == 200 && status == "0") {
      if (from == "waiting") {
        await BacklogController.backlogC.onReload();
      } else if (from == "today") {
        await TodayController.to.onReload();
      } else if (from == "upcoming") {
        await UpcomingController.upcomingC.onReload();
      } else if (from == "project") {
        await ProjectController.projectC.onReload();
      } else if (from == "mySquad") {
        await MySquadController.to.onReload();
      } else if (from == "instruction") {
        await InstructionController.to.onReload();
      }

      HomeController.homeC.onReload();
      if (!kIsWeb) {
        if (Platform.isAndroid || Platform.isIOS) {
          await FlutterRingtonePlayer.play(
            android: AndroidSounds.notification,
            ios: IosSounds.sentMessage,
            looping: false,
            volume: 1,
            asAlarm: false,
          );
        }
      }

      if (from != "upcoming") {
        fToast.showToast(
          gravity: ToastGravity.BOTTOM,
          toastDuration: const Duration(seconds: 3),
          child: GestureDetector(
            onTap: () {
              updateIssue(
                id: id,
                from: from,
                repeat: repeat,
                status: "1",
              );
              fToast.removeCustomToast();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Issue has been closed"),
                  SizedBox(width: 12),
                  Icon(
                    Icons.replay_outlined,
                    size: 24,
                    color: AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    } else if (response.statusCode == 200 && status == "1") {
      if (from == "waiting") {
        await BacklogController.backlogC.getIssueWaiting(
          id: authId.value,
          projectId: 0,
          section: "waiting",
        );
      } else if (from == "today") {
        await TodayController.to.onReload();
      } else if (from == "upcoming") {
        await UpcomingController.upcomingC.onReload();
      } else if (from == "project") {
        await ProjectController.projectC.onReload();
      } else if (from == "mySquad") {
        await MySquadController.to.onReload();
      } else if (from == "instruction") {
        await InstructionController.to.onReload();
      }

      HomeController.homeC.onReload();
    } else {
      DialogServices.generalSnackbar(
        context: Get.context!,
        message: response.message ?? '',
        dialogType: PanaraDialogType.warning,
      );
    }
  }

  Future<void> updateIsAccept({
    required int id,
    required String from,
    required String isAccept,
  }) async {
    UpdateIsAcceptModel response = await IssueRepository.updateIsAccept(
      id: id,
      isAccept: isAccept,
    );

    if (response.statusCode == 200) {
      if (from == "waiting") {
        await BacklogController.backlogC.onReload();
      } else if (from == "today") {
        await TodayController.to.onReload();
      } else if (from == "upcoming") {
        await UpcomingController.upcomingC.onReload();
      } else if (from == "project") {
        await ProjectController.projectC.onReload();
      } else if (from == "mySquad") {
        await MySquadController.to.onReload();
      } else if (from == "instruction") {
        await InstructionController.to.onReload();
      }

      HomeController.homeC.onReload();
    } else {
      DialogServices.generalSnackbar(
        context: Get.context!,
        message: response.message ?? '',
        dialogType: PanaraDialogType.warning,
      );
    }
  }

  Future<void> deleteIssue({
    required int id,
    required String from,
    required FToast fToast,
    status = 1,
  }) async {
    if (from != "mySquad" && authId.value == 0) {
      authId.value = await HiveServices.box.get('id');
    }

    if (status == 1) {
      await IssueRepository.deleteIssue(id: id);
    } else {
      await IssueRepository.undoDeleteIssue(id: id);
    }

    if (from == "waiting") {
      await BacklogController.backlogC.onReload();
    } else if (from == "today") {
      await TodayController.to.onReload();
    } else if (from == "upcoming") {
      await UpcomingController.upcomingC.onReload();
    } else if (from == "project") {
      await ProjectController.projectC.onReload();
    } else if (from == "mySquad") {
      await MySquadController.to.onReload();
    } else if (from == "instruction") {
      await InstructionController.to.onReload();
    }

    HomeController.homeC.onReload();

    if (status == 1) {
      fToast.showToast(
        gravity: ToastGravity.TOP,
        toastDuration: const Duration(seconds: 3),
        child: GestureDetector(
          onTap: () {
            deleteIssue(
              id: id,
              from: from,
              fToast: fToast,
              status: "0",
            );
            fToast.removeCustomToast();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Issue has been deleted"),
                SizedBox(width: 12),
                Icon(
                  Icons.replay_outlined,
                  size: 24,
                  color: AppColors.primaryColor,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Future<void> saveData({
    required int id,
    required int projectId,
    required String name,
    required String description,
    required DateTime date,
    required String dateName,
    required String from,
    required String point,
    required String repeat,
    required fToast,
    Function()? onSuccess,
    Function()? onError,
    int? userId,
  }) async {
    if (from != "mySquad" && authId.value == 0) {
      authId.value = await HiveServices.box.get('id');
    }

    var dateFormat = DateFormat('y-MM-d H:mm:ss').format(date).toString();

    if (id != 0) {
      UpdateIssueResponseModel response = await IssueRepository.saveDataUpdate(
        id: id,
        authId: from == "mySquad_instruction" ? (userId ?? 0) : authId.value,
        projectId: projectId,
        name: name,
        description: description,
        date: dateName == "No Date" ? "" : dateFormat,
        repeat: repeat == "No Repeat" ? "" : repeat,
        point: point,
        listAcceptance: listAcceptance,
      );

      if (response.statusCode == 200) {
        onBottomSheetClosed(from: from);

        if (from == "waiting") {
          await BacklogController.backlogC.onReload();
        } else if (from == "today") {
          await TodayController.to.onReload();
        } else if (from == "upcoming") {
          await UpcomingController.upcomingC.onReload();
        } else if (from == "project") {
          await ProjectController.projectC.onReload();
        } else if (from == "mySquad") {
          await MySquadController.to.onReload();
        } else if (from == "instruction") {
          await InstructionController.to.onReload();
        }

        if (dateName != "No Date") {
          var minDate = date.millisecondsSinceEpoch - 900000;
          var thisDate = DateTime.fromMillisecondsSinceEpoch(minDate);
          var body = ListIssueController.to.setDateName(
            dateName: dateName,
            isOverdue: false,
            from: "",
          );

          if (!kIsWeb) {
            NotificationService.handleNotif(
              id: id,
              title: name,
              body: body[0],
              startTime: DateTime.now(),
              finishTime: thisDate,
            );
          } else {
            NotificationService.handleNotifWeb(
              title: name,
              body: body[0],
              startTime: DateTime.now(),
              finishTime: thisDate,
            );
          }
        }

        HomeController.homeC.onReload();
        onSuccess;
        Get.back();
      } else {
        onError;
        DialogServices.generalSnackbar(
          context: Get.context!,
          message: response.message ?? '',
          dialogType: PanaraDialogType.warning,
        );
      }
    } else {
      CreateIssueResponseModel response = await IssueRepository.saveDataCreate(
        authId: authId.value,
        projectId: projectId,
        name: name,
        description: description,
        date: dateName == "No Date" ? "" : dateFormat,
        repeat: repeat == "No Repeat" ? "" : repeat,
        point: point,
        listAcceptance: temptListAcceptance,
      );
      String textTo = "";

      if (response.statusCode == 200) {
        var currentUserId = await HiveServices.box.get('id');
        var assigneUserId = authId.value;

        onBottomSheetClosed(from: from);

        if (from == "waiting") {
          textTo = "Waiting List";
          await BacklogController.backlogC.onReload();
        } else if (from == "today") {
          textTo = "Scheduled";
          await TodayController.to.onReload();
        } else if (from == "upcoming") {
          await UpcomingController.upcomingC.onReload();
        } else if (from == "project") {
          textTo = "Project";
          await ProjectController.projectC.onReload();
        } else if (from == "mySquad") {
          textTo = "My Squad";
          await MySquadController.to.onReload();
        } else if (from == "instruction") {
          textTo = "Instruction";
          await InstructionController.to.onReload();
        } else {
          if (dateName.split(", ")[0] == "Today") {
            textTo = "Today";
          } else {
            if (projectId != 0) {
              textTo = "Project";
            } else if (dateName != "No Date") {
              textTo = "Scheduled";
            } else if (assigneUserId != 0 && assigneUserId != currentUserId) {
              textTo = "My Squad";
            } else {
              textTo = "Waiting List";
            }
          }
        }

        onSuccess;

        if (dateName != "No Date") {
          var minDate = date.millisecondsSinceEpoch - 900000;
          var thisDate = DateTime.fromMillisecondsSinceEpoch(minDate);
          var body = ListIssueController.to.setDateName(
            dateName: dateName,
            isOverdue: false,
            from: "",
          );

          if (!kIsWeb) {
            NotificationService.handleNotif(
              id: id,
              title: name,
              body: body[0],
              startTime: DateTime.now(),
              finishTime: thisDate,
            );
          } else {
            NotificationService.handleNotifWeb(
              title: name,
              body: body[0],
              startTime: DateTime.now(),
              finishTime: thisDate,
            );
          }
        }

        if (from != "upcoming") {
          await fToast.showToast(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check),
                  const SizedBox(width: 12),
                  textTo.isEmpty
                      ? const Text("Issue has been created")
                      : Text("Issue has been created in $textTo"),
                ],
              ),
            ),
            gravity: ToastGravity.TOP,
            toastDuration: const Duration(seconds: 2),
          );
        }

        HomeController.homeC.onReload();
      } else {
        onError;
        DialogServices.generalSnackbar(
          context: Get.context!,
          message: response.message ?? '',
          dialogType: PanaraDialogType.warning,
        );
      }
    }
  }

  void onChangeName(value, from, fToast) {
    if (value.contains("\n")) {
      descriptionFocusNode.unfocus();
      nameTextController.text = nameTextController.text.replaceAll("\n", "");

      saveData(
        id: id.value,
        projectId: projectId.value,
        name: nameTextController.text,
        description: descriptionTextController.text,
        date: date.value,
        dateName: dateName.value,
        from: from,
        point: "${pointHour.value}:${pointMinute.value}",
        repeat: repeatName.value,
        fToast: fToast,
      );
    } else {
      var lowwerCase = value.toLowerCase();

      repeatKeyword(lowwerCase, value);

      todayKeyword(lowwerCase, value);

      tomorrowKeyword(lowwerCase, value);

      dayKeyword(value);

      dateKeyword(value);

      pointKeyword(lowwerCase, value);

      hourKeyword(value, from);
    }
  }

  void onSaveDataText(value, from, fToast, onSuccess, onError) {
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

    descriptionFocusNode.unfocus();
    nameTextController.text = nameTextController.text.replaceAll("\n", "");

    dateTime = DateTime.now();
    if (isRedundentClick()) {
      return;
    }
    saveData(
      id: id.value,
      projectId: projectId.value,
      name: nameTextController.text,
      description: descriptionTextController.text,
      date: date.value,
      dateName: dateName.value,
      from: from,
      point: "${pointHour.value}:${pointMinute.value}",
      repeat: repeatName.value,
      fToast: fToast,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  void repeatKeyword(lowwerCase, value) {
    if (lowwerCase.split(" ")[0] == "rdaily" && lowwerCase == "rdaily " ||
        lowwerCase.split(" ")[0] == "rweekly" && lowwerCase == "rweekly ") {
      isLoading.value = true;

      var replace = value.replaceAll(
          RegExp("rDaily |rWeekly |rdaily |rweekly |Rdaily |Rweekly "), "");
      nameTextController.text = replace;
      nameTextController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: nameTextController.text.length,
        ),
      );

      if (lowwerCase == "rdaily ") {
        repeatName.value = "daily";
      }

      if (lowwerCase == "rweekly ") {
        repeatName.value = "weekly";
      }

      if (dateName.value == "No Date") {
        dateName.value = dateName.value.replaceAll(
          dateName.value.split(", ")[0],
          "Today",
        );

        date.value = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          DateTime.now().hour,
          DateTime.now().minute,
        );
      }

      isLoading.value = false;
    } else if (lowwerCase.contains(" rdaily ") ||
        lowwerCase.contains(" rweekly ")) {
      isLoading.value = true;

      var replace = value.replaceAll(
          RegExp(" rDaily | rdaily | Rdaily | rWeekly | rweekly | Rweekly "),
          " ");
      nameTextController.text = replace;
      nameTextController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: nameTextController.text.length,
        ),
      );

      if (lowwerCase.contains(" rdaily ")) {
        repeatName.value = "daily";
      }

      if (lowwerCase.contains(" rweekly ")) {
        repeatName.value = "weekly";
      }

      if (dateName.value == "No Date") {
        dateName.value = dateName.value.replaceAll(
          dateName.value.split(", ")[0],
          "Today",
        );

        date.value = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          DateTime.now().hour,
          DateTime.now().minute,
        );
      }

      isLoading.value = false;
    }
  }

  void todayKeyword(lowwerCase, value) {
    if (lowwerCase.split(" ")[0] == "tod" && lowwerCase == "tod " ||
        lowwerCase.split(" ")[0] == "today" && lowwerCase == "today ") {
      isLoading.value = true;
      isSelectedDay.value = lowwerCase;

      var replace =
          value.replaceAll(RegExp("tod |Tod |TOD |today |Today |TODAY "), "");
      nameTextController.text = replace;
      nameTextController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: nameTextController.text.length,
        ),
      );

      if (date.value == DateTime.now()) {
        dateName.value = "Today";
        date.value = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        );
      } else {
        dateName.value = dateName.value.replaceAll(
          dateName.value.split(", ")[0],
          "Today",
        );

        date.value = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          date.value.hour,
          date.value.minute,
        );
      }

      isLoading.value = false;
    } else if (lowwerCase.contains(" tod ") || lowwerCase.contains(" today ")) {
      isLoading.value = true;
      isSelectedDay.value = lowwerCase;

      var replace = value.replaceAll(
          RegExp(" tod | Tod | TOD | today | Today | TODAY "), " ");
      nameTextController.text = replace;
      nameTextController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: nameTextController.text.length,
        ),
      );

      if (date.value == DateTime.now()) {
        dateName.value = "Today";
        date.value = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        );
      } else {
        dateName.value = dateName.value.replaceAll(
          dateName.value.split(", ")[0],
          "Today",
        );

        date.value = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          date.value.hour,
          date.value.minute,
        );
      }

      isLoading.value = false;
    }
  }

  void tomorrowKeyword(lowwerCase, value) {
    if (lowwerCase.split(" ")[0] == "tom" && lowwerCase == "tom " ||
        lowwerCase.split(" ")[0] == "tomorrow" && lowwerCase == "tomorrow ") {
      isLoading.value = true;
      isSelectedDay.value = lowwerCase;

      var replace = value.replaceAll(
          RegExp("tom |Tom |TOM |tomorrow |Tomorrow |TOMORROW "), "");
      nameTextController.text = replace;
      nameTextController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: nameTextController.text.length,
        ),
      );

      if (date.value == DateTime.now()) {
        dateName.value = "Tomorrow";
        date.value = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day + 1,
        );
      } else {
        dateName.value = dateName.value.replaceAll(
          dateName.value.split(", ")[0],
          "Tomorrow",
        );

        date.value = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day + 1,
          date.value.hour,
          date.value.minute,
        );
      }

      isLoading.value = false;
    } else if (lowwerCase.contains(" tom ") ||
        lowwerCase.contains(" tomorrow ")) {
      isLoading.value = true;
      isSelectedDay.value = lowwerCase;

      var replace = value.replaceAll(
          RegExp(" tom | Tom | TOM | tomorrow | Tomorrow | TOMORROW "), " ");
      nameTextController.text = replace;
      nameTextController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: nameTextController.text.length,
        ),
      );

      if (date.value == DateTime.now()) {
        dateName.value = "Tomorrow";
        date.value = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day + 1,
        );
      } else {
        dateName.value = dateName.value.replaceAll(
          dateName.value.split(", ")[0],
          "Tomorrow",
        );

        date.value = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day + 1,
          date.value.hour,
          date.value.minute,
        );
      }

      isLoading.value = false;
    }
  }

  void dayKeyword(value) {
    var dayRegex = RegExp(
      r" (mon(day?)?|tue(sday?)?|wed(nesday?)?|thu(rsday?)?|fri(day?)?|sat(urday?)?|sun(day?)?) ",
    );

    RegExp regex;
    String nameFirst = " ${value.split(" ")[0]} ";

    if (dayRegex.hasMatch(value)) {
      value = value;

      regex = dayRegex;
      isSelectedDay.value = value;
    } else if (dayRegex.hasMatch(nameFirst) && value.split(" ").length >= 2) {
      value = nameFirst;

      regex = dayRegex;
      isSelectedDay.value = value;
    } else {
      return;
    }

    var matches = regex.allMatches(value);
    for (final match in matches) {
      var matchString = match[0];
      var dayString = "${matchString?.trim().capitalize!.substring(0, 3)}";
      var isDay = (dayString == DateFormat('EEE').format(DateTime.now()))
          ? true
          : false;

      try {
        DateTime? dateTime;
        String? dayName;
        if (isDay == true) {
          dateTime = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day + 7,
            date.value.hour,
            date.value.minute,
          );
          dayName = DateFormat("dd MMM yyyy").format(dateTime);
        } else {
          if (DateFormat('EEE').format(DateTime.now()) == "Mon") {
            if (dayString == "Tue") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 1,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Wed") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 2,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Thu") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 3,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Fri") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 4,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Sat") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 5,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Sun") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 6,
                date.value.hour,
                date.value.minute,
              );
            }
          } else if (DateFormat('EEE').format(DateTime.now()) == "Tue") {
            if (dayString == "Mon") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 6,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Wed") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 1,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Thu") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 2,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Fri") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 3,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Sat") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 4,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Sun") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 5,
                date.value.hour,
                date.value.minute,
              );
            }
          } else if (DateFormat('EEE').format(DateTime.now()) == "Wed") {
            if (dayString == "Mon") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 5,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Tue") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 6,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Thu") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 1,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Fri") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 2,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Sat") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 3,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Sun") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 4,
                date.value.hour,
                date.value.minute,
              );
            }
          } else if (DateFormat('EEE').format(DateTime.now()) == "Thu") {
            if (dayString == "Mon") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 4,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Tue") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 5,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Wed") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 6,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Fri") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 1,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Sat") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 2,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Sun") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 3,
                date.value.hour,
                date.value.minute,
              );
            }
          } else if (DateFormat('EEE').format(DateTime.now()) == "Fri") {
            if (dayString == "Mon") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 3,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Tue") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 4,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Wed") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 5,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Thu") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 6,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Sat") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 1,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Sun") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 2,
                date.value.hour,
                date.value.minute,
              );
            }
          } else if (DateFormat('EEE').format(DateTime.now()) == "Sat") {
            if (dayString == "Mon") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 2,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Tue") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 3,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Wed") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 4,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Thu") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 5,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Fri") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 6,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Sun") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 1,
                date.value.hour,
                date.value.minute,
              );
            }
          } else if (DateFormat('EEE').format(DateTime.now()) == "Sun") {
            if (dayString == "Mon") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 1,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Tue") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 2,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Wed") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 3,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Thu") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 4,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Fri") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 5,
                date.value.hour,
                date.value.minute,
              );
            } else if (dayString == "Sat") {
              dateTime = DateTime(
                DateTime.now().year,
                DateTime.now().month,
                DateTime.now().day + 6,
                date.value.hour,
                date.value.minute,
              );
            }
          }

          dayName = DateFormat("dd MMM yyyy").format(dateTime!);
        }

        var replace = value.replaceAll(matchString, "");
        nameTextController.text = replace;
        nameTextController.selection = TextSelection.fromPosition(
          TextPosition(
            offset: nameTextController.text.length,
          ),
        );

        var tomorrow = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day + 1,
        );

        if (DateUtils.isSameDay(dateTime, DateTime.now())) {
          dateName.value = dateName.value.replaceAll(
            dateName.value.split(", ")[0],
            "Today",
          );
        } else if (dateTime == tomorrow) {
          dateName.value = dateName.value.replaceAll(
            dateName.value.split(", ")[0],
            "Tomorrow",
          );
        } else {
          dateName.value = dateName.value.replaceAll(
            dateName.value.split(", ")[0],
            dayName,
          );
        }

        date.value = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          date.value.hour,
          date.value.minute,
        );
        return;
      } catch (_) {}
    }
  }

  void dateKeyword(value) {
    var dateRegex = RegExp(r'( \d+ \w+ )');
    var dateRegexNoSpace = RegExp(r'(\d+ \w+ )');
    RegExp regex;

    if (dateRegex.hasMatch(value)) {
      regex = dateRegex;
      isSelectedDay.value = value;
    } else if (dateRegexNoSpace.hasMatch(value)) {
      regex = dateRegexNoSpace;
      isSelectedDay.value = value;
    } else {
      return;
    }

    var matches = regex.allMatches(value);
    for (final match in matches) {
      var matchString = match[0];
      var dateString =
          "${matchString?.trim().capitalize!} ${DateTime.now().year}";
      try {
        var month = dateString.split(" ")[1];
        DateTime dateTime;
        if (month.length == 3) {
          dateTime = DateFormat("dd MMM yyyy").parseStrict(dateString);
        } else {
          dateTime = DateFormat("dd MMMM yyyy").parseStrict(dateString);
        }

        //invalid date before now
        if (dateTime.isBefore(DateTime.now()) &&
            !DateUtils.isSameDay(dateTime, DateTime.now())) {
          return;
        }

        var replace = value.replaceAll(matchString, "");
        nameTextController.text = replace;
        nameTextController.selection = TextSelection.fromPosition(
          TextPosition(
            offset: nameTextController.text.length,
          ),
        );

        var tomorrow = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day + 1,
        );

        if (DateUtils.isSameDay(dateTime, DateTime.now())) {
          dateName.value = dateName.value.replaceAll(
            dateName.value.split(", ")[0],
            "Today",
          );
        } else if (dateTime == tomorrow) {
          dateName.value = dateName.value.replaceAll(
            dateName.value.split(", ")[0],
            "Tomorrow",
          );
        } else {
          dateName.value = dateName.value.replaceAll(
            dateName.value.split(", ")[0],
            dateString,
          );
        }

        date.value = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          date.value.hour,
          date.value.minute,
        );
        return;
      } catch (_) {}
    }
  }

  void pointKeyword(lowercase, value) {
    var pointRegex = RegExp(r'( [p]\d+(?:\.\d{1,2})? )');
    var pointRegexNoSpace = RegExp(r'([p]\d+(?:\.\d{1,2})? )');
    RegExp regex;

    if (pointRegex.hasMatch(lowercase)) {
      regex = pointRegex;
    } else if (pointRegexNoSpace.hasMatch(lowercase)) {
      regex = pointRegexNoSpace;
    } else {
      return;
    }

    var matchString = regex.stringMatch(lowercase);
    var pointKeyword = matchString?.trim();
    var point = pointKeyword?.substring(1, pointKeyword.length);

    if (double.parse(point ?? "0") > 8) {
      return;
    }

    if (point!.contains('.')) {
      var decimalPoint = point.substring(point.indexOf('.') + 1, point.length);
      if (decimalPoint == "0" || decimalPoint == "") {
        pointMinute.value = "0";
      } else if (decimalPoint == "25" || decimalPoint == "15") {
        pointMinute.value = "15";
      } else if (decimalPoint == "5" ||
          decimalPoint == "30" ||
          decimalPoint == "50") {
        pointMinute.value = "30";
      } else if (decimalPoint == "75" || decimalPoint == "45") {
        pointMinute.value = "45";
      } else {
        return;
      }
      pointHour.value = point.substring(0, point.indexOf('.'));
    } else {
      pointMinute.value = "0";
      pointHour.value = point;
    }

    if (pointMinute.value == "0") {
      pointName.value = point;
    } else {
      pointName.value = "${pointHour.value}.${pointMinute.value}";
    }

    var replace = value.replaceAll(matchString, "");
    nameTextController.text = replace;
    nameTextController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: nameTextController.text.length,
      ),
    );
  }

  void hourKeyword(value, from) {
    var checkhour = RegExp(
      "([01]?[0-9]|2[0-3]):[0-5][0-9]",
      caseSensitive: true,
    );

    if (checkhour.hasMatch(value) == true) {
      isLoading.value = true;

      var getHour = checkhour.stringMatch(value).toString();
      var splitHour = getHour.split(":");
      var hour = int.parse(splitHour[0]);
      var minute = int.parse(splitHour[1]);

      var replace = value.replaceAll(getHour, "");

      nameTextController.text = replace;
      nameTextController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: nameTextController.text.length,
        ),
      );

      if (!isSelectedDay.value.isNotEmpty && from != "upcoming") {
        /// If [date] is tomorrow or more
        if (date.value.day > DateTime.now().day) {
          var namedDay = dateName.value;
          if (namedDay.contains("Tomorow") || namedDay.contains("Tomorrow")) {
            date.value = DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day + 1,
              hour,
              minute,
            );

            dateName.value = "Tomorrow, $getHour";
          }

          /// If [namedDay] from [dateName] is "Tomorrow, 10:00" or "Senin, 13:00", ""
          /// else is "Senin" or "24 Maret 2024"
          if (namedDay.contains(",")) {
            var names = namedDay.split(",");
            var dayDateName = names[0];

            date.value = DateTime(
              date.value.year,
              date.value.month,
              date.value.day,
              hour,
              minute,
            );

            dateName.value = "$dayDateName, $getHour";
          } else {
            date.value = DateTime(
              date.value.year,
              date.value.month,
              date.value.day,
              hour,
              minute,
            );

            dateName.value = "${dateName.value}, $getHour";
          }
        } else if (hour <= DateTime.now().hour &&
            minute < DateTime.now().minute) {
          date.value = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day + 1,
            hour,
            minute,
          );

          dateName.value = "Tomorrow, $getHour";
        } else {
          date.value = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            hour,
            minute,
          );

          dateName.value = "Today, $getHour";
        }
      } else {
        if (dateName.value == "No Date") {
          date.value = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            hour,
            minute,
          );

          dateName.value = "Today, $getHour";
        } else {
          if (dateName.value.split(", ").length <= 1) {
            dateName.value = "${dateName.value}, $getHour";
          } else {
            dateName.value = dateName.value.replaceAll(
              dateName.value.split(", ")[1],
              getHour,
            );
          }

          date.value = DateTime(
            date.value.year,
            date.value.month,
            date.value.day,
            hour,
            minute,
          );
        }
      }

      hourName.value = getHour;
      selectedHour.value = date.value.hour;
      selectedMinute.value = date.value.minute;

      isLoading.value = false;
    }
  }

  void onChangeDate(DateTime value) {
    isLoading.value = true;
    chcekMonth(value);

    if (value.day == DateTime.now().day) {
      dateName.value = dateName.value.replaceAll(
        dateName.value.split(", ")[0],
        "Today",
      );
    } else if ((value.day - DateTime.now().day) == 1) {
      dateName.value = dateName.value.replaceAll(
        dateName.value.split(", ")[0],
        "Tomorrow",
      );
    } else {
      dateName.value = dateName.value.replaceAll(
        dateName.value.split(", ")[0],
        "${value.day} $monthShow ${value.year}",
      );
    }

    //memasukkan nilai value dan memisahkan pada bagian jam dan menit
    date.value = DateTime(
      value.year,
      value.month,
      value.day,
      date.value.hour,
      date.value.minute,
    );

    isLoading.value = false;
  }

  void onChangeHour(DateTime value) {
    isLoading.value = true;
    checkHour(value);
    checkMinute(value);

    if (dateName.value.split(", ").length <= 1) {
      if (dateName.value == "No Date") {
        dateName.value = "Today, ${hourShow.value}:${minuteShow.value}";
      } else {
        dateName.value =
            "${dateName.value}, ${hourShow.value}:${minuteShow.value}";
      }
    } else {
      dateName.value = dateName.value.replaceAll(
        dateName.value.split(", ")[1],
        "${hourShow.value}:${minuteShow.value}",
      );
    }

    hourName.value = "${hourShow.value}:${minuteShow.value}";
    //memasukkan nilai value dan memisahkan pada bagian jam dan menit
    date.value = DateTime(
      date.value.year,
      date.value.month,
      date.value.day,
      value.hour,
      value.minute,
    );

    isLoading.value = false;
  }

  void checkHour(value) {
    if (value.hour < 10) {
      hourShow.value = "0${value.hour}";
    } else {
      hourShow.value = "${value.hour}";
    }
  }

  void checkMinute(value) {
    if (value.minute < 10) {
      minuteShow.value = "0${value.minute}";
    } else {
      minuteShow.value = "${value.minute}";
    }
  }

  void chcekMonth(value) {
    if (value.month == 1) {
      monthShow.value = "Januari";
    } else if (value.month == 2) {
      monthShow.value = "Febuari";
    } else if (value.month == 3) {
      monthShow.value = "Maret";
    } else if (value.month == 4) {
      monthShow.value = "April";
    } else if (value.month == 5) {
      monthShow.value = "Mei";
    } else if (value.month == 6) {
      monthShow.value = "Juni";
    } else if (value.month == 7) {
      monthShow.value = "Juli";
    } else if (value.month == 8) {
      monthShow.value = "Agustus";
    } else if (value.month == 9) {
      monthShow.value = "September";
    } else if (value.month == 10) {
      monthShow.value = "October";
    } else if (value.month == 11) {
      monthShow.value = "November";
    } else if (value.month == 12) {
      monthShow.value = "Desember";
    }
  }

  void onChangeProject(value) {
    if (value.mProjectId != 0) {
      projectId.value = value.mProjectId;
      projectName.value = value.name;
      showAssignee.value = true;
    } else {
      projectId.value = 0;
      projectName.value = "0";
      showAssignee.value = false;
      onChangeAssigne(
        Squad(
          name: '',
          id: 0,
          photo: '',
        ),
      );
    }
  }

  void onChangeAssigne(value) {
    authId.value = value.userAuthId;
    assigneName.value = value.namaUser;
    assignePhoto.value = value.humanisFoto;
  }

  void noDate() {
    isLoading.value = true;
    dateName.value = "No Date";
    date.value = DateTime.now();
    hourName.value = "Setting Jam";
    isLoading.value = false;
    Get.back();
  }

  void tomorrowDate() {
    isLoading.value = true;

    dateName.value = dateName.value.replaceAll(
      dateName.value.split(", ")[0],
      "Tomorrow",
    );

    date.value = DateTime(
      date.value.year,
      date.value.month,
      DateTime.now().day + 1,
      date.value.hour,
      date.value.minute,
    );
    isLoading.value = false;

    Get.back();
  }

  void onBottomSheetClosed({required String from}) async {
    isLoading.value = true;
    showAssignee.value = false;
    if (from != "today" && from != "upcoming") {
      dateName.value = "No Date";
    }

    isFrist.value = false;
    nameTextController.clear();
    descriptionTextController.clear();
    if (from != "upcoming") {
      date.value = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
    }

    hourName.value = "Setting Jam";
    pointHour.value = "0";
    pointMinute.value = "0";
    pointName.value = "0";
    isSelectedDay.value = "";

    if (from != "project") {
      projectId.value = 0;
      projectName.value = "0";
    }

    if (from != "mySquad") {
      authId.value = 0;
      assigneName.value = "";
      assignePhoto.value = "";
    }

    temptListAcceptance.clear();
    listAcceptance.clear();
    if (from == "waiting") {
      await BacklogController.backlogC.onReload();
    } else if (from == "today") {
      await TodayController.to.onReload();
    } else if (from == "upcoming") {
      await UpcomingController.upcomingC.onReload();
    } else if (from == "project") {
      await ProjectController.projectC.onReload();
    } else if (from == "mySquad") {
      await MySquadController.to.onReload();
    } else if (from == "instruction") {
      await InstructionController.to.onReload();
    } else if (from == "mySquad_instruction") {
      await MySquadController.to.onReload();
    }

    acceptanceDone.value = 0;
    isLoading.value = false;
  }

  Future<void> getAcceptance({
    required int id,
  }) async {
    isAcceptenceLoading.value = true;

    AcceptanceModel response = await IssueRepository.getAcceptance(
      id: id,
    );

    if (response.statusCode == 200) {
      listAcceptance.value = response.data!;
      isAcceptenceLoading.value = false;
    } else {
      isAcceptenceLoading.value = false;
      DialogServices.generalSnackbar(
        context: Get.context!,
        message: response.message ?? '',
        dialogType: PanaraDialogType.warning,
      );
    }
  }

  void createTemptAcceptance({
    required int timeboxId,
    required String name,
  }) {
    temptListAcceptance.add(
      AcceptanceItem(
        id: timeboxId == 0 ? null : timeboxId,
        name: name,
        status: '1',
      ),
    );
  }

  Future<void> createAcceptance({
    required int timeboxId,
    required String name,
  }) async {
    await IssueRepository.createAcceptance(
      timeboxId: timeboxId,
      name: name,
    );

    AcceptanceModel response = await IssueRepository.getAcceptance(
      id: timeboxId,
    );

    if (response.statusCode == 200) {
      listAcceptance.value = response.data!;
    } else {
      DialogServices.generalSnackbar(
        context: Get.context!,
        message: response.message ?? '',
        dialogType: PanaraDialogType.warning,
      );
    }
  }

  Future<void> updateAcceptance({
    required int id,
    required String name,
  }) async {
    await IssueRepository.updateAcceptance(
      id: id,
      name: name,
    );
  }

  Future<void> updateAcceptanceStatus({
    required int id,
    required int timeboxId,
    required String status,
  }) async {
    if (status == "") {
      acceptanceDone.value = acceptanceDone.value + 1;
    } else {
      acceptanceDone.value = acceptanceDone.value - 1;
    }
    await IssueRepository.updateAcceptanceStatus(id: id, status: status);

    AcceptanceModel response = await IssueRepository.getAcceptance(
      id: timeboxId,
    );

    if (response.statusCode == 200) {
      listAcceptance.value = response.data!;
    } else {
      DialogServices.generalSnackbar(
        context: Get.context!,
        message: response.message ?? '',
        dialogType: PanaraDialogType.warning,
      );
    }
  }

  Future<void> deleteAsseptance({
    required int id,
    required int timeboxId,
  }) async {
    await IssueRepository.deleteAcceptance(id: id);

    AcceptanceModel response = await IssueRepository.getAcceptance(
      id: timeboxId,
    );

    if (response.statusCode == 200) {
      listAcceptance.value = response.data!;
    } else {
      DialogServices.generalSnackbar(
        context: Get.context!,
        message: response.message ?? '',
        dialogType: PanaraDialogType.warning,
      );
    }
  }

  int getUserAuthId() {
    final box = Hive.box(HiveConstant.db);
    return box.get('id');
  }

  @override
  void onInit() async {
    super.onInit();
    authName.value = await HiveServices.box.get("name");
  }
}
