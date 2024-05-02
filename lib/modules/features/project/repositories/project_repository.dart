import 'package:dio/dio.dart';
import 'package:timebox/constants/cores/api_constant.dart';
import 'package:timebox/modules/features/project/models/list_issue_all_users_model.dart';
import 'package:timebox/modules/global_controllers/global_controller.dart';
import 'package:timebox/utils/services/api_service.dart';

class ProjectRepository {
  static Future<ListIssueAllUsersModel> getAllIssueFromTimebox({
    required String mProjectId,
    required String userAuthId,
    required bool isMyIssue,
  }) async {
    if (isMyIssue) {
      try {
        final Dio dio = ApiServices.dioCall(
          baseUrl: GlobalController.getGlobalBaseUrl,
        );

        Map<String, dynamic> param = {
          'm_project_id': mProjectId,
          'user_auth_id': userAuthId,
          'created_by': userAuthId,
        };

        var res = await dio.get(
          ApiConstant.getAllIssueFromTimebox(),
          queryParameters: param,
        );

        return ListIssueAllUsersModel.fromJson(res.data);
      } on DioException catch (e) {
        return ListIssueAllUsersModel(
          statusCode: 500,
          message: e.message,
        );
      }
    } else {
      Map<String, dynamic> param = {
        'm_project_id': mProjectId,
        'user_auth_id': userAuthId,
      };

      try {
        final Dio dio = ApiServices.dioCall(
          baseUrl: GlobalController.getGlobalBaseUrl,
        );

        var res = await dio.get(
          ApiConstant.getAllIssueFromTimebox(),
          queryParameters: param,
        );

        return ListIssueAllUsersModel.fromJson(res.data);
      } on DioException catch (e) {
        return ListIssueAllUsersModel(
          statusCode: 500,
          message: e.message,
        );
      }
    }
  }
}
