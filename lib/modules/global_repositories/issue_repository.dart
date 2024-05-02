import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:timebox/constants/cores/api_constant.dart';
import 'package:timebox/modules/global_controllers/global_controller.dart';
import 'package:timebox/modules/global_modules/acceptance_model.dart';
import 'package:timebox/modules/global_modules/create_issue_model.dart';
import 'package:timebox/modules/global_modules/issue_model.dart';
import 'package:timebox/modules/global_modules/update_is_accept_model.dart';
import 'package:timebox/modules/global_modules/update_issue_model.dart';
import 'package:timebox/utils/services/api_service.dart';
import 'package:timebox/utils/services/hive_service.dart';

class IssueRepository {
  IssueRepository._();

  static Future<IssueResponseModel> getIssue({
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

      return IssueResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      var response = jsonDecode(e.response.toString());
      if (e.response != null) {
        if (response['status_code'] == 422) {
          return IssueResponseModel(
            statusCode: response['status_code'],
            message: response['errors'][0].toString(),
          );
        } else {
          return IssueResponseModel(
            statusCode: response['status_code'],
            message: "Terjadi masalah pada server",
          );
        }
      } else {
        return IssueResponseModel(
          statusCode: 500,
          message:
              "Koneksi device ini terputus, silahkan chek kembali koneksi!",
        );
      }
    }
  }

  static Future<IssueResponseModel> getIssueBacklog({
    required int id,
    required int projectId,
    required String section,
  }) async {
    try {
      final Dio dio = ApiServices.dioCall(
        baseUrl: GlobalController.getGlobalBaseUrl,
      );

      var response = await dio.get(
        ApiConstant.getIssueBacklog(
          authId: id,
          projectId: projectId,
          position: "backlog",
          section: section,
        ),
      );

      return IssueResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      var response = jsonDecode(e.response.toString());
      if (e.response != null) {
        if (response['status_code'] == 422) {
          return IssueResponseModel(
            statusCode: response['status_code'],
            message: response['errors'][0].toString(),
          );
        } else {
          return IssueResponseModel(
            statusCode: response['status_code'],
            message: "Terjadi masalah pada server",
          );
        }
      } else {
        return IssueResponseModel(
          statusCode: 500,
          message:
              "Koneksi device ini terputus, silahkan chek kembali koneksi!",
        );
      }
    }
  }

  static Future<UpdateIssueResponseModel> updateIssue({
    required int id,
    required String status,
  }) async {
    try {
      final Dio dio = ApiServices.dioCall(
        baseUrl: GlobalController.getGlobalBaseUrl,
      );

      var formData = {
        'id': id,
        "status": status,
      };

      var response = await dio.put(ApiConstant.issue(), data: formData);
      return UpdateIssueResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      var response = jsonDecode(e.response.toString());
      if (e.response != null) {
        if (response['status_code'] == 422) {
          return UpdateIssueResponseModel(
            statusCode: response['status_code'],
            message: response['errors'][0].toString(),
          );
        } else {
          return UpdateIssueResponseModel(
            statusCode: response['status_code'],
            message: "Terjadi masalah pada server",
          );
        }
      } else {
        return UpdateIssueResponseModel(
          statusCode: 500,
          message:
              "Koneksi device ini terputus, silahkan chek kembali koneksi!",
        );
      }
    }
  }

  static Future<UpdateIsAcceptModel> updateIsAccept({
    required int id,
    required String isAccept,
  }) async {
    try {
      final Dio dio = ApiServices.dioCall(
        baseUrl: GlobalController.getGlobalBaseUrl,
      );

      var formData = {
        'id': id,
        "is_accept": isAccept,
      };

      var response = await dio.put(
        ApiConstant.getAllIssueFromTimebox(),
        data: formData,
      );
      return UpdateIsAcceptModel.fromJson(response.data);
    } on DioException catch (e) {
      var response = jsonDecode(e.response.toString());
      if (e.response != null) {
        if (response['status_code'] == 422) {
          return UpdateIsAcceptModel(
            statusCode: response['status_code'],
            message: response['errors'][0].toString(),
          );
        } else {
          return UpdateIsAcceptModel(
            statusCode: response['status_code'],
            message: "Terjadi masalah pada server",
          );
        }
      } else {
        return UpdateIsAcceptModel(
          statusCode: 500,
          message:
              "Koneksi device ini terputus, silahkan chek kembali koneksi!",
        );
      }
    }
  }

  static Future<CreateIssueResponseModel> saveDataCreate({
    required int authId,
    required int projectId,
    required String name,
    required String description,
    required String date,
    required String point,
    required String repeat,
    required List<AcceptanceItem?>? listAcceptance,
  }) async {
    try {
      final Dio dio = ApiServices.dioCall(
        baseUrl: GlobalController.getGlobalBaseUrl,
      );

      var formData = {
        'user_auth_id': authId,
        "m_project_id": projectId,
        'name': name,
        'description': description,
        'duedate': date,
        "point_jam": point,
        "type_repetition": repeat,
        "status": "1",
        "created_by": await HiveServices.box.get('id'),
        "issue_acceptance": listAcceptance ?? [],
      };

      ///jika di bagian body tidak ada postman
      var response = await dio.post(ApiConstant.issue(), data: formData);
      return CreateIssueResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      var response = jsonDecode(e.response.toString());

      if (e.response != null) {
        if (response['status_code'] == 422) {
          return CreateIssueResponseModel(
            statusCode: response['status_code'],
            message: response['errors'][0].toString(),
          );
        } else {
          return CreateIssueResponseModel(
            statusCode: response['status_code'],
            message: "Terjadi masalah pada server",
          );
        }
      } else {
        return CreateIssueResponseModel(
          statusCode: 500,
          message:
              "Koneksi device ini terputus, silahkan chek kembali koneksi!",
        );
      }
    }
  }

  static Future<UpdateIssueResponseModel> saveDataUpdate({
    required int id,
    required int authId,
    required int projectId,
    required String name,
    required String description,
    required String date,
    required String point,
    required String repeat,
    required List<AcceptanceItem?>? listAcceptance,
  }) async {
    try {
      final Dio dio = ApiServices.dioCall(
        baseUrl: GlobalController.getGlobalBaseUrl,
      );

      var formData = {
        'id': id,
        'user_auth_id': authId,
        "m_project_id": projectId,
        'name': name,
        'description': description,
        'duedate': date,
        "point_jam": point,
        "type_repetition": repeat,
        "status": "1",
        "issue_acceptance": listAcceptance ?? [],
      };

      ///jika di bagian body tidak ada postman
      var response = await dio.put(ApiConstant.issue(), data: formData);
      return UpdateIssueResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      var response = jsonDecode(e.response.toString());

      if (e.response != null) {
        if (response['status_code'] == 422) {
          return UpdateIssueResponseModel(
            statusCode: response['status_code'],
            message: response['errors'][0].toString(),
          );
        } else {
          return UpdateIssueResponseModel(
            statusCode: response['status_code'],
            message: "Terjadi masalah pada server",
          );
        }
      } else {
        return UpdateIssueResponseModel(
          statusCode: 500,
          message:
              "Koneksi device ini terputus, silahkan chek kembali koneksi!",
        );
      }
    }
  }

  static Future<void> deleteIssue({required int id}) async {
    final Dio dio = ApiServices.dioCall(
      baseUrl: GlobalController.getGlobalBaseUrl,
    );

    await dio.delete(ApiConstant.deleteIssue(id: id));
  }

  static Future<void> undoDeleteIssue({required int id}) async {
    final Dio dio = ApiServices.dioCall(
      baseUrl: GlobalController.getGlobalBaseUrl,
    );

    await dio.post(ApiConstant.undoDeleteIssue(id: id));
  }

  static Future<AcceptanceModel> getAcceptance({
    required int id,
  }) async {
    try {
      final Dio dio = ApiServices.dioCall(
        baseUrl: GlobalController.getGlobalBaseUrl,
      );

      Map<String, dynamic> param = {
        't_timebox_issue_id': id,
      };

      var response = await dio.get(
        ApiConstant.acceptance(),
        queryParameters: param,
      );

      return AcceptanceModel.fromJson(response.data);
    } on DioException catch (e) {
      var response = jsonDecode(e.response.toString());
      if (e.response != null) {
        if (response['status_code'] == 422) {
          return AcceptanceModel(
            statusCode: response['status_code'],
            message: response['errors'][0].toString(),
          );
        } else {
          return AcceptanceModel(
            statusCode: response['status_code'],
            message: "Terjadi masalah pada server",
          );
        }
      } else {
        return AcceptanceModel(
          statusCode: 500,
          message:
              "Koneksi device ini terputus, silahkan chek kembali koneksi!",
        );
      }
    }
  }

  static Future<void> createAcceptance({
    required int timeboxId,
    required String name,
  }) async {
    var formData = FormData.fromMap({
      't_timebox_issue_id': timeboxId,
      'name': name,
      "status": "1",
    });

    final Dio dio = ApiServices.dioCall(
      baseUrl: GlobalController.getGlobalBaseUrl,
    );

    await dio.post(ApiConstant.acceptance(), data: formData);
  }

  static Future<void> updateAcceptance({
    required int id,
    required String name,
  }) async {
    final Dio dio = ApiServices.dioCall(
      baseUrl: GlobalController.getGlobalBaseUrl,
    );

    await dio.put(
      ApiConstant.acceptance(),
      data: {
        'id': id,
        "name": name,
      },
    );
  }

  static Future<void> updateAcceptanceStatus({
    required int id,
    required String status,
  }) async {
    final Dio dio = ApiServices.dioCall(
      baseUrl: GlobalController.getGlobalBaseUrl,
    );

    await dio.put(ApiConstant.acceptance(), data: {'id': id, "status": status});
  }

  static Future<void> deleteAcceptance({required int id}) async {
    final Dio dio = ApiServices.dioCall(
      baseUrl: GlobalController.getGlobalBaseUrl,
    );

    await dio.delete("api/v1/timebox-acceptance/$id");
  }
}
