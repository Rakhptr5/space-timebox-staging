import 'my_squad_timebox_page.dart';

class MySquadTimeboxRes {
  int? statusCode;
  MySquadTimeboxPage? data;
  String? message;
  List<dynamic>? settings;

  MySquadTimeboxRes({
    this.statusCode,
    this.data,
    this.message,
    this.settings,
  });

  factory MySquadTimeboxRes.fromJson(Map<String, dynamic> json) {
    return MySquadTimeboxRes(
      statusCode: json['status_code'] as int?,
      data: json['data'] == null
          ? null
          : MySquadTimeboxPage.fromJson(json['data'] as Map<String, dynamic>),
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
