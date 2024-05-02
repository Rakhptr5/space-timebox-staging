import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:timebox/modules/features/my_squad/models/list_my_squad_model.dart';
import 'package:timebox/modules/features/my_squad/models/my_squad_percentage_model.dart';
import 'package:timebox/modules/features/my_squad/models/my_squad_timebox/my_squad_timebox.dart';
import 'package:timebox/modules/features/my_squad/repositories/my_squad_repository.dart';
import 'package:timebox/modules/global_controllers/global_controller.dart';
import 'package:timebox/utils/services/dialog_service.dart';
import 'package:timebox/utils/services/hive_service.dart';
import 'package:collection/collection.dart';

import '../../../../configs/routes/app_route.dart';
import '../../instruction/repositories/instruction_repository.dart';
import '../models/my_squad_timebox/my_squad_timebox_model.dart';

class MySquadController extends GetxController {
  static MySquadController get to => Get.find();
  dynamic argumentData = Get.arguments;

  var isLoading = true.obs;
  var isByProject = false.obs;

  var id = 0.obs;
  var title = "".obs;
  var desc = "".obs;
  var photo = "".obs;
  var checkedAtFromHome = "".obs;
  var authId = 0.obs;
  Timer? checkOverdueTimer;

  var listData = <MySquadInstruction?>[].obs;

  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  List<MySquadPercentageModel> listPercentageData = [];

  RxList<MySquadTimeboxModel> listMySquadTimebox =
      RxList<MySquadTimeboxModel>([]);
  RxList<MySquadTimeboxModel> listTodayMySquadTimebox =
      RxList<MySquadTimeboxModel>([]);
  RxList<MySquadInstruction> listInstructionMySquad =
      RxList<MySquadInstruction>([]);
  RxNum totalPoint = RxNum(0.00);
  RxList<Map<int, num>> listTotalPoint = RxList<Map<int, num>>([]);
  RxNum totalInstructionIssue = RxNum(0.00);
  RxNum totalTodayIssues = RxNum(0.00);
  RxString checkedAt = RxString('');
  RxBool isButtonCheckDisable = RxBool(false);
  RxBool isDialogShowing = RxBool(false);

  @override
  void onInit() async {
    super.onInit();
    isLoading.value = true;

    if (!kIsWeb) {
      await GlobalController.to.checkConnection();
    }

    if (argumentData != null) {
      title.value = argumentData[0];
      authId.value = argumentData[1];
      desc.value = argumentData[2];
      photo.value = argumentData[3];
      checkedAtFromHome.value = argumentData[4];

      await HiveServices.box.put("mySquadTitle", argumentData[0]);
      await HiveServices.box.put("mySquadId", argumentData[1]);
      await HiveServices.box.put("mySquadDesc", argumentData[2]);
      await HiveServices.box.put("mySquadPhoto", argumentData[3]);
      await HiveServices.box.put("mySquadCheckedAt", argumentData[4]);
    } else {
      title.value = await HiveServices.box.get("mySquadTitle");
      authId.value = await HiveServices.box.get("mySquadId");
      desc.value = await HiveServices.box.get("mySquadDesc");
      photo.value = await HiveServices.box.get("mySquadPhoto");
      checkedAtFromHome.value = await HiveServices.box.get("mySquadCheckedAt");
    }

    id.value = await HiveServices.box.get("id");
    if (await HiveServices.box.get("mySquadIsByProject") == null) {
      isByProject.value = true;
      await HiveServices.box.put("mySquadIsByProject", true);
    } else {
      if (await HiveServices.box.get("mySquadIsByProject") == false) {
        isByProject.value = false;
        await HiveServices.box.put("mySquadIsByProject", false);
      } else {
        isByProject.value = true;
        await HiveServices.box.put("mySquadIsByProject", true);
      }
    }

    await getAllMySquadTimeboxData();
    await getAllInstruction();
    await timerCheckOverdue();

    isLoading.value = false;
  }

  Future<void> onRefresh() async {
    isLoading.value = true;
    isDialogShowing.value = false;
    listTotalPoint.clear();
    totalPoint.value = 0.00;
    await Future.delayed(const Duration(milliseconds: 1000));

    if (!kIsWeb) {
      await GlobalController.to.checkConnection();
    }

    try {
      await getAllMySquadTimeboxData();
      await getAllInstruction();
      await timerCheckOverdue();

      isLoading.value = false;
      refreshController.refreshCompleted();
    } catch (e) {
      isLoading.value = false;
      refreshController.refreshFailed();
    }
  }

  void initAllStatus() {
    for (var element in listMySquadTimebox) {
      /// change all overdue task status to 2
      if (element.modelData != null || element.modelData != []) {
        for (var element in element.modelData!) {
          if (element.progress == 1) {
            element.setStatus = '2';
            setTotalPoint(element, 100);
          }
        }
      }

      /// set total point from space issue
      if (element.modelDataIssueSpace != null ||
          element.modelDataIssueSpace != []) {
        for (var element in element.modelDataIssueSpace!) {
          totalPoint.value += element.point ?? 0;
        }
      }
    }
  }

  @override
  onClose() {
    checkOverdueTimer?.cancel();
  }

  bool checkDataIsNotEmpty() {
    /// check whether the timebox data is empty or not
    var instructionNotEmpty = listInstructionMySquad
        .any((element) => element.data?.timebox?.isNotEmpty ?? false);

    if (listMySquadTimebox.isNotEmpty ||
        listTodayMySquadTimebox.isNotEmpty ||
        instructionNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }

  void onTapChangeStatus(MySquadTimebox val) {
    if (val.status == '1') {
      return;
    }
    switch (val.status) {
      case '0':
        val.setStatus = '2';
        setTotalPoint(val, 100);
        update();
        break;
      case '2':
        val.setStatus = '0';
        setTotalPoint(val, 0);
        update();
        break;

      default:
        val.setStatus = '0';
        setTotalPoint(val, 0);
        update();
        break;
    }
  }

  bool checkIsOverdue(MySquadTimeboxModel data) {
    // / check is overdue(true) or not(false)
    DateTime? dateData = DateTime.tryParse(data.tanggal ?? '');
    var dateNow = DateTime.now();
    var overdueTime = DateTime(
      dateNow.year,
      dateNow.month,
      dateNow.day,
      10,
      59,
      dateNow.second,
    );
    if ((dateData?.day ?? dateNow.day) <= overdueTime.day) {
      if (dateNow.hour <= overdueTime.hour &&
          dateNow.minute <= overdueTime.minute) {
        return false;
      } else {
        return true;
      }
    } else {
      return false;
    }
  }

  Future<void> timerCheckOverdue() async {
    var dateNow = DateTime.now();
    var overdueTime = DateTime(
      dateNow.year,
      dateNow.month,
      dateNow.day,
      11,
      00,
      dateNow.second,
    );
    var isTodayTimeboxEmpty = listTodayMySquadTimebox
        .every((element) => element.modelData?.isEmpty ?? true);
    
    var isTodaySpaceEmpty = listTodayMySquadTimebox
        .every((element) => element.modelDataIssueSpace?.isEmpty ?? true);

    if (dateNow.isBefore(overdueTime)) {
      /// button condition if all data empty
      if (listMySquadTimebox.isEmpty && isTodayTimeboxEmpty == true && isTodaySpaceEmpty == true) {
        isButtonCheckDisable.value = true;
      } else {
        isButtonCheckDisable.value = false;
      }

      /// run function
      checkOverdueTimer = Timer(
        Duration(seconds: overdueTime.difference(dateNow).inSeconds),
        () => onRefresh(),
      );
    } else {
      isButtonCheckDisable.value = true;
      checkOverdueTimer?.cancel();
    }
  }

  String getTitleWithDate(String? dueDate) {
    if (dueDate == null || dueDate == '') {
      return '-';
    }
    var formatedDate = DateTime.tryParse(dueDate);
    return DateFormat('EEEE, d MMM').format(formatedDate ?? DateTime.now());
  }

  String getPoint(MySquadTimeboxModel model) {
    double getPoint = 0;
    if (model.modelData == null && model.modelData == []) {
      return '0.00';
    }

    for (var element in model.modelData!) {
      getPoint += double.parse(element.point ?? '0.00');
    }

    for (var element in model.modelDataIssueSpace!) {
      getPoint += double.parse(element.point.toString());
    }

    return getPoint.toStringAsFixed(2);
  }

  String getTotalIssue() {
    totalTodayIssues.value = 0;
    for (var element in listTodayMySquadTimebox) {
      totalTodayIssues.value += element.modelData!.length;
      totalTodayIssues.value += element.modelDataIssueSpace!.length;
    }
    return '${totalTodayIssues.value} Issues';
  }

  String getTotalInstructionIssue() {
    totalInstructionIssue.value = 0;
    for (var element in listInstructionMySquad) {
      if (element.data != null &&
          element.data!.timebox != [] &&
          element.data!.timebox != null) {
        totalInstructionIssue.value += element.data!.timebox!.length;
      }
    }
    return '${totalInstructionIssue.value} Issues';
  }

  Future<void> getCheckedTime() async {
    var formatedTime = DateFormat('hh:mm');
    var parsedDateTime = DateTime.tryParse(checkedAt.value);

    if (parsedDateTime != null && checkedAt.value != '') {
      checkedAt.value = formatedTime.format(parsedDateTime);
    } else {
      if (checkedAtFromHome.value != '') {
        checkedAt.value = checkedAtFromHome.value;
      } else {
        var now = DateTime.now();

        /// if list mysquadTimebox empty and mysquadToday empty,
        /// it means it's in negative case flow.
        checkedAt.value = formatedTime.format(now).toString();
      }
    }
  }

  bool getIsAlreadyCheck() {
    if (checkedAtFromHome.value != '' || checkedAt.value != '') {
      getCheckedTime();
      isButtonCheckDisable.value = true;
      return true;
    } else {
      return false;
    }
  }

  Future<void> setTotalPoint(MySquadTimebox data, int percentage) async {
    num temptTotalPoint = 0;
    int temptId = data.id ?? 0;

    /// formula: times(*) the point with percentange and get the last 2 decimal number
    var formula = ((num.tryParse(data.point ?? '0') ?? 0) * (percentage / 100))
        .toStringAsFixed(2);

    ///parse the formula
    var resultFormula = num.tryParse(formula) ?? 0;

    ///if id is not in the list then add the value
    if (listTotalPoint.firstWhereIndexedOrNull(
            (index, element) => element.containsKey(data.id)) ==
        null) {
      listTotalPoint.add({temptId: resultFormula});
    }

    ///if id already exist then change the value
    else {
      var lastIndexWhere = listTotalPoint
          .lastIndexWhere((element) => element.containsKey(temptId));
      listTotalPoint[lastIndexWhere] = {temptId: resultFormula};
    }

    /// for every map<int, num> in listTotalPoint
    for (var element in listTotalPoint) {
      /// sum all tempTotalPoint with element.values (num)
      for (var i in element.values) {
        /// tempTotalPoint = tempTotalPoint + i
        temptTotalPoint += i;
      }
    }
    // log('temp total point: ${temptTotalPoint.toStringAsFixed(2)}');
    totalPoint.value = num.parse(temptTotalPoint.toStringAsFixed(2));
  }

  void onTapCheckIn() async {
    isLoading.value = true;
    for (var element in listMySquadTimebox) {
      await Future.delayed(
        const Duration(seconds: 1),
        () => putMySquadTimebox(listData: element.modelData ?? []).then(
          (value) => getCheckedTime(),
        ),
      );
    }

    for (var element in listTodayMySquadTimebox) {
      await Future.delayed(
        const Duration(seconds: 1),
        () => putMySquadTimebox(listData: element.modelData ?? []).then(
          (value) => getCheckedTime(),
        ),
      );
    }

    // await onRefresh();
    Get.offAllNamed(AppRoutes.homeRoute);
  }

  Future<void> onReload() async {
    totalPoint.value = 0.00;
    listTotalPoint.clear();
    await getAllMySquadTimeboxData();
    await getAllInstruction();
  }

  Future<void> getData() async {
    if (!isByProject.value) {
      ListMySquadModel response = await MySquadRepository.getDataDate(
        userAuthId: authId.value.toString(),
        status: "1",
      );

      if (response.statusCode == 200) {
        listData.value = response.data!;
      } else {
        DialogServices.generalSnackbar(
          context: Get.context!,
          message: response.message ?? '',
          dialogType: PanaraDialogType.warning,
        );
      }
    } else {
      ListMySquadModel response = await MySquadRepository.getDataProject(
        userAuthId: authId.value.toString(),
        status: "1",
      );

      if (response.statusCode == 200) {
        listData.value = response.data!;
      } else {
        DialogServices.generalSnackbar(
          context: Get.context!,
          message: response.message ?? '',
          dialogType: PanaraDialogType.warning,
        );
      }
    }
  }

  Future<void> getAllMySquadTimeboxData() async {
    var res = await MySquadRepository.getMySquadTimeboxData(
      userAuthId: authId.value,
    );

    if (res.statusCode != 200) {
      DialogServices.generalSnackbar(
        context: Get.context!,
        message: res.message ?? '',
        dialogType: PanaraDialogType.warning,
      );
      return;
    }

    var newData = res.data?.pageData;
    if (newData != [] || newData != null) {
      /// get list closed timebox with pass by value
      listMySquadTimebox.value = List<MySquadTimeboxModel>.from(newData ?? []);

      /// remove element of today timebox
      listMySquadTimebox.removeWhere((element) =>
          DateTime.parse(element.tanggal ?? DateTime.now().toString())
              .day
              .isEqual(DateTime.now().day));

      /// get list today timebox
      listTodayMySquadTimebox.value = newData
              ?.where((element) =>
                  DateTime.parse(element.tanggal ?? DateTime.now().toString())
                      .day
                      .isEqual(DateTime.now().day))
              .toList() ??
          [];
      initAllStatus();
    }
  }

  Future<void> putMySquadTimebox({
    required List<MySquadTimebox> listData,
  }) async {
    var res = await MySquadRepository.putMySquadTimeboxData(
      seniorId: id.value,
      authId: authId.value,
      listData: listData,
    );

    if (res.statusCode != 200) {
      if (!isDialogShowing.value) {
        DialogServices.generalSnackbar(
          context: Get.context!,
          message: res.message ?? '',
          dialogType: PanaraDialogType.warning,
        );
        isDialogShowing.value = true;
      }
      return;
    }

    var newData = res.data;
    if (newData == null) {
      return;
    }
    if (newData.data == null) {
      return;
    }
    if (newData.data == []) {
      return;
    }
    if (newData.data!.lastOrNull == null) {
      return;
    } else {
      var checkNewData = newData.data?.firstOrNull;
      if (checkNewData != null) {
        checkedAt.value = checkNewData.checkedAt ?? '';
      }
    }
  }

  Future<void> getAllInstruction() async {
    var res = await InstructionRepository.getDataDate(
      userAuthId: authId.value.toString(),
      status: "1",
    );

    if (res.statusCode != 200) {
      DialogServices.generalSnackbar(
        context: Get.context!,
        message: res.message ?? '',
        dialogType: PanaraDialogType.warning,
      );
      return;
    }

    var newData = res.data;
    if (newData != [] && newData != null && newData.isNotEmpty) {
      listInstructionMySquad.value = res.data ?? [];
    }
  }
}

/// old code
// int getTotalPercentage(MySquadTimeboxModel value) {
//   /// check if from listPercentageData with tanggal as id
//   var temptList =
//       listPercentageData.where((element) => element.id == value.tanggal);

//   if (temptList.firstOrNull == null) {
//     return 0;
//   }

//   /// get total percentage and set value from
//   /// multiplying listpercentage
//   var temptTotal = temptList.first.totalPercentage;
//   temptTotal = temptList.first.listPercentage
//       .fold(0, (previousValue, element) => element + previousValue);

//   return (temptTotal ~/ temptList.first.listPercentage.length);
// }

/// old code
// void addPercentage({
//   required int percentage,
//   required int index,
//   required MySquadTimeboxModel value,
// }) {
//   /// check listPercentageData with tanggal as id
//   var temptList =
//       listPercentageData.where((element) => element.id == value.tanggal);

//   if (temptList.firstOrNull == null) {
//     return;
//   }

//   /// check if list index not exist,
//   /// true insert, false change value
//   var temptPercentageList = temptList.first.listPercentage;
//   if (temptPercentageList
//           .firstWhereIndexedOrNull((i, element) => i == index) ==
//       null) {
//     temptPercentageList.insert(index, percentage);
//   } else {
//     temptPercentageList[index] = percentage;
//   }

//   /// change the model progress
//   if (value.modelData != null && value.modelData != []) {
//     value.modelData![index].setProgress = percentage;
//   }
// }
