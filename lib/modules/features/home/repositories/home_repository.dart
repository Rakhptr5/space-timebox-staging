import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:timebox/constants/cores/api_constant.dart';
import 'package:timebox/modules/features/home/models/home_model.dart';
import 'package:timebox/modules/features/home/models/squad_model/squad_model_res.dart';
import 'package:timebox/modules/global_controllers/global_controller.dart';
import 'package:timebox/utils/services/api_service.dart';

class HomeRepository {
  HomeRepository._();

  static Future<HomeResponseModel> getData({
    required int id,
  }) async {
    try {
      final Dio dio = ApiServices.dioCall(
        baseUrl: GlobalController.getGlobalBaseUrl,
      );

      var response = await dio.get(
        ApiConstant.home(
          authId: id,
        ),
      );
      return HomeResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      var response = jsonDecode(e.response.toString());
      if (e.response != null) {
        if (response['status_code'] == 422) {
          return HomeResponseModel(
            statusCode: response['status_code'],
            message: response['errors'][0].toString(),
          );
        } else {
          return HomeResponseModel(
            statusCode: response['status_code'],
            message: "Terjadi masalah pada server",
          );
        }
      } else {
        return HomeResponseModel(
          statusCode: 500,
          message:
              "Koneksi device ini terputus, silahkan chek kembali koneksi!",
        );
      }
    }
  }

  static Future<SquadModelRes> getAllSquadModel({
    required String userId,
  }) async {
    Map<String, dynamic> param = {
      'user_auth_id': userId,
    };
    try {
      final Dio dio = ApiServices.dioCall(
        baseUrl: GlobalController.getGlobalBaseUrl,
      );

      var res = await dio.get(
        ApiConstant.squad(),
        queryParameters: param,
      );

      return SquadModelRes.fromJson(res.data);
    } on DioException catch (e) {
      return SquadModelRes(
        statusCode: 500,
        message: e.message,
      );
    }
  }
}
