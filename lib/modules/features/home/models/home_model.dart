// To parse this JSON data, do
//
//     final homeResponseModel = homeResponseModelFromJson(jsonString);

import 'dart:convert';

HomeResponseModel homeResponseModelFromJson(String str) =>
    HomeResponseModel.fromJson(json.decode(str));

String homeResponseModelToJson(HomeResponseModel data) =>
    json.encode(data.toJson());

class HomeResponseModel {
  HomeResponseModel({
    this.statusCode,
    this.data,
    this.message,
    this.settings,
  });

  int? statusCode;
  Data? data;
  String? message;
  List<dynamic>? settings;

  factory HomeResponseModel.fromJson(Map<String, dynamic> json) =>
      HomeResponseModel(
        statusCode: json["status_code"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
        settings: json["settings"] == null
            ? []
            : List<dynamic>.from(json["settings"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "data": data?.toJson(),
        "message": message,
        "settings":
            settings == null ? [] : List<dynamic>.from(settings!.map((x) => x)),
      };
}

class Data {
  Data({
    this.count,
    this.project,
  });

  Count? count;
  List<Project>? project;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        count: json["count"] == null ? null : Count.fromJson(json["count"]),
        project: json["project"] == null
            ? []
            : List<Project>.from(
                json["project"]!.map((x) => Project.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count?.toJson(),
        "project": project == null
            ? []
            : List<dynamic>.from(project!.map((x) => x.toJson())),
      };
}

class Count {
  Count({
    this.backlog,
    this.today,
    this.instruction,
  });

  String? backlog;
  String? today;
  String? instruction;

  factory Count.fromJson(Map<String, dynamic> json) => Count(
        backlog: json["backlog"].toString(),
        today: json["today"].toString(),
        instruction: json["instruction"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "backlog": backlog,
        "today": today,
        "instruction": instruction,
      };
}

/// abstract to use for project and squad in autocomplete
abstract class CardIssueDataModel {}

class Project extends CardIssueDataModel {
  Project({
    this.mProjectId,
    this.name,
    this.countTimebox,
  });

  int? mProjectId;
  String? name;
  dynamic countTimebox;

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        mProjectId: json["m_project_id"],
        name: json["name"],
        countTimebox: json["count_timebox"],
      );

  Map<String, dynamic> toJson() => {
        "m_project_id": mProjectId,
        "name": name,
        "count_timebox": countTimebox,
      };

  static List<Project> fromJsonList(List list) {
    return list.map((item) => Project.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '$mProjectId $name';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(Project model) {
    return mProjectId == model.mProjectId;
  }

  @override
  String toString() => name!;
}

class Squad extends CardIssueDataModel {
  Squad({
    this.id,
    this.name,
    this.photo,
  });

  int? id;
  String? name;
  String? photo;

  factory Squad.fromJson(Map<String, dynamic> json) => Squad(
        id: json["user_auth_id"],
        name: json["nama_user"],
        photo: json["humanis_foto"],
      );

  Map<String, dynamic> toJson() => {
        "user_auth_id": id,
        "nama_user": name,
        "humanis_foto": photo,
      };

  static List<Squad> fromJsonList(List list) {
    return list.map((item) => Squad.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '$id $name';
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(Squad model) {
    return id == model.id;
  }

  @override
  String toString() => name!;
}
