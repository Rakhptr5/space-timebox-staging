import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:timebox/constants/cores/api_constant.dart';
import 'package:timebox/modules/features/today/models/today_issue_model.dart';
import 'package:timebox/utils/services/api_service.dart';

import '../../../global_controllers/global_controller.dart';

class TodayIssueRepository {
  TodayIssueRepository._();

  static Future<TodayIssueResponseModel> getIssue({
    required int id,
    required int projectId,
    required String position,
  }) async {
    try {
      final Dio dio = ApiServices.dioCall(
        baseUrl: GlobalController.getGlobalBaseUrl,
      );

      var response = await dio.get(
        ApiConstant.getIssue(
          authId: id,
          projectId: projectId,
          position: position,
        ),
      );

      return TodayIssueResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      var response = jsonDecode(e.response.toString());
      if (e.response != null) {
        if (response['status_code'] == 422) {
          return TodayIssueResponseModel(
            statusCode: response['status_code'],
            message: response['errors'][0].toString(),
          );
        } else {
          return TodayIssueResponseModel(
            statusCode: response['status_code'],
            message: "Terjadi masalah pada server",
          );
        }
      } else {
        return TodayIssueResponseModel(
          statusCode: 500,
          message:
              "Koneksi device ini terputus, silahkan chek kembali koneksi!",
        );
      }
    }
  }
}
