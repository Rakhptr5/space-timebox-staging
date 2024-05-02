import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:timebox/constants/cores/api_constant.dart';
import 'package:timebox/modules/features/login/models/login_model.dart';
import 'package:timebox/utils/services/api_service.dart';

import '../../../global_controllers/global_controller.dart';

class LoginRepository {
  LoginRepository._();

  static Future<LoginResponseModel> login(
    String email,
    String password,
  ) async {
    final Dio dio = ApiServices.dioCall(
      baseUrl: GlobalController.getGlobalBaseUrl,
    );

    try {
      var formData = FormData.fromMap({
        'email': email,
        'password': password,
      });

      ///jika di bagian body tidak ada postman
      var response = await dio.post(ApiConstant.login(), data: formData);
      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      var response = jsonDecode(e.response.toString());
      if (e.response != null) {
        if (response['status_code'] == 422) {
          return LoginResponseModel(
            statusCode: response['status_code'],
            message: response['errors'][0].toString(),
          );
        } else {
          return LoginResponseModel(
            statusCode: response['status_code'],
            message: "Terjadi masalah pada server",
          );
        }
      } else {
        return LoginResponseModel(
          statusCode: 500,
          message:
              "Koneksi device ini terputus, silahkan chek kembali koneksi!",
        );
      }
    }
  }
}
