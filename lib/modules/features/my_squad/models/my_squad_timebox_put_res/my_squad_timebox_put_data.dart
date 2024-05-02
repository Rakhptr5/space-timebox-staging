import 'my_squad_timebox_put.dart';

class MySquadTimeboxPutData {
  bool? status;
  List<MySquadTimeboxPut>? data;

  MySquadTimeboxPutData({this.status, this.data});

  factory MySquadTimeboxPutData.fromJson(Map<String, dynamic> json) =>
      MySquadTimeboxPutData(
        status: json['status'] as bool?,
        data: (json['data'] as List<dynamic>?)
            ?.map((e) => MySquadTimeboxPut.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': data?.map((e) => e.toJson()).toList(),
      };
}
