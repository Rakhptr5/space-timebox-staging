import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:timebox/constants/cores/api_constant.dart';
import 'package:timebox/modules/features/my_squad/models/list_my_squad_model.dart';
import 'package:timebox/modules/features/my_squad/models/my_squad_timebox/my_squad_timebox.dart';
import 'package:timebox/modules/features/my_squad/models/my_squad_timebox/my_squad_timebox_res.dart';
import 'package:timebox/modules/features/my_squad/models/my_squad_timebox_put_res/my_squad_timebox_put_res.dart';
import 'package:timebox/modules/global_controllers/global_controller.dart';
import 'package:timebox/utils/services/api_service.dart';

class MySquadRepository {
  static Future<ListMySquadModel> getDataDate({
    required String userAuthId,
    required String status,
  }) async {
    try {
      final Dio dio = ApiServices.dioCall(
        baseUrl: GlobalController.getGlobalBaseUrl,
      );

      var res = await dio.get(
        ApiConstant.getAllIssueTimeBoxSquad(
          userAuthId: userAuthId,
          status: status,
        ),
      );

      return ListMySquadModel.fromJson(res.data);
    } on DioException catch (e) {
      return ListMySquadModel(
        statusCode: 500,
        message: e.message,
      );
    }
  }

  static Future<ListMySquadModel> getDataProject({
    required String userAuthId,
    required String status,
  }) async {
    try {
      final Dio dio = ApiServices.dioCall(
        baseUrl: GlobalController.getGlobalBaseUrl,
      );

      var res = await dio.get(
        ApiConstant.getAllIssueTimeBoxSquad(
            userAuthId: userAuthId, status: status, fillter: "project"),
      );

      return ListMySquadModel.fromJson(res.data);
    } on DioException catch (e) {
      return ListMySquadModel(
        statusCode: 500,
        message: e.message,
      );
    }
  }

  static Future<MySquadTimeboxRes> getMySquadTimeboxData({
    required int userAuthId,
    int? page = 1,
  }) async {
    Map<String, dynamic> param = {
      'page': page,
    };
    try {
      final Dio dio = ApiServices.dioCall(
        baseUrl: GlobalController.getGlobalBaseUrl,
      );

      var res = await dio.get(
        ApiConstant.getMySquadTimebox(
          userAuthId: userAuthId,
        ),
        queryParameters: param,
      );

      return MySquadTimeboxRes.fromJson(res.data);
    } on DioException catch (e) {
      return MySquadTimeboxRes(
        statusCode: 500,
        message: e.message,
      );
    }
  }

  static Future<MySquadTimeboxPutRes> putMySquadTimeboxData({
    required int seniorId,
    required int authId,
    required List<MySquadTimebox> listData,
  }) async {
    var jsonRaw = {
      "form": {
        "senior_id": seniorId,
        "user_auth_id": authId,
      },
      "detail": [
        for (var element in listData)
          {
            "id": element.id,
            "status": element.status,
            "duedate": element.duedate,
          },
      ]
    };

    try {
      final Dio dio = ApiServices.dioCall(
        baseUrl: GlobalController.getGlobalBaseUrl,
      );

      var res = await dio.put(
        ApiConstant.putMySquadTimebox(),
        data: jsonEncode(jsonRaw),
      );

      return MySquadTimeboxPutRes.fromJson(res.data);
    } on DioException catch (e) {
      return MySquadTimeboxPutRes(
        statusCode: e.response?.statusCode ?? 500,
        message: e.message,
      );
    }
  }
}
