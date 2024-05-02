import 'my_squad_timebox_put_data.dart';

class MySquadTimeboxPutRes {
  int? statusCode;
  MySquadTimeboxPutData? data;
  String? message;
  List<dynamic>? settings;

  MySquadTimeboxPutRes({
    this.statusCode,
    this.data,
    this.message,
    this.settings,
  });

  factory MySquadTimeboxPutRes.fromJson(Map<String, dynamic> json) {
    return MySquadTimeboxPutRes(
      statusCode: json['status_code'] as int?,
      data: json['data'] == null
          ? null
          : MySquadTimeboxPutData.fromJson(
              json['data'] as Map<String, dynamic>),
      message: json['message'] as String?,
      settings: json['settings'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'status_code': statusCode,
        'data': data?.toJson(),
        'message': message,
        'settings': settings,
      };
}
