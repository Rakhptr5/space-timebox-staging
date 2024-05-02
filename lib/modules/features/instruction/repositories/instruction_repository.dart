import 'package:dio/dio.dart';
import 'package:timebox/constants/cores/api_constant.dart';
import 'package:timebox/modules/features/my_squad/models/list_my_squad_model.dart';
import 'package:timebox/utils/services/api_service.dart';

import '../../../global_controllers/global_controller.dart';

class InstructionRepository {
  static Future<ListMySquadModel> getDataDate({
    required String userAuthId,
    required String status,
  }) async {
    try {
      final Dio dio = ApiServices.dioCall(
        baseUrl: GlobalController.getGlobalBaseUrl,
      );

      var res = await dio.get(
        ApiConstant.getAllIssueTimeBoxInstruction(
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
        ApiConstant.getAllIssueTimeBoxInstruction(
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
}
