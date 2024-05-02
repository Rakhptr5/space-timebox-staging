import 'package:timebox/modules/features/home/models/home_model.dart';

class SquadRes extends CardIssueDataModel {
  int? statusCode;
  Data? data;
  String? message;
  List<dynamic>? settings;

  SquadRes({this.statusCode, this.data, this.message, this.settings});

  factory SquadRes.fromJson(Map<String, dynamic> json) => SquadRes(
        statusCode: json['status_code'] as int?,
        data: json['data'] == null
            ? null
            : Data.fromJson(json['data'] as Map<String, dynamic>),
        message: json['message'] as String?,
        settings: json['settings'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'status_code': statusCode,
        'data': data?.toJson(),
        'message': message,
        'settings': settings,
      };
}
