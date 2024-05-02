import 'squad_model.dart';

class SquadModelRes {
  int? statusCode;
  List<SquadModel>? data;
  String? message;
  List<dynamic>? settings;

  SquadModelRes({
    this.statusCode,
    this.data,
    this.message,
    this.settings,
  });

  factory SquadModelRes.fromJson(Map<String, dynamic> json) => SquadModelRes(
        statusCode: json['status_code'] as int?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => SquadModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        message: json['message'] as String?,
        settings: json['settings'] as List<dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'status_code': statusCode,
        'data': data?.map((e) => e.toJson()).toList(),
        'message': message,
        'settings': settings,
      };
}
