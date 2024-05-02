// To parse this JSON data, do
//
//     final createIssueResponseModel = createIssueResponseModelFromJson(jsonString);

import 'dart:convert';

CreateIssueResponseModel createIssueResponseModelFromJson(String str) =>
    CreateIssueResponseModel.fromJson(json.decode(str));

String createIssueResponseModelToJson(CreateIssueResponseModel data) =>
    json.encode(data.toJson());

class CreateIssueResponseModel {
  CreateIssueResponseModel({
    this.statusCode,
    this.data,
    this.message,
    this.settings,
  });

  int? statusCode;
  CreateIssueResponseModelData? data;
  String? message;
  List<dynamic>? settings;

  factory CreateIssueResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateIssueResponseModel(
        statusCode: json["status_code"],
        data: json["data"] == null
            ? null
            : CreateIssueResponseModelData.fromJson(json["data"]),
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

class CreateIssueResponseModelData {
  CreateIssueResponseModelData({
    this.data,
  });

  bool? status;
  DataData? data;

  factory CreateIssueResponseModelData.fromJson(Map<String, dynamic> json) =>
      CreateIssueResponseModelData(
        data: json["data"] == null ? null : DataData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class DataData {
  DataData({
    this.name,
    this.duedate,
    this.userAuthId,
    this.mProjectId,
    this.description,
    this.point,
    this.status,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  String? name;
  String? duedate;
  String? userAuthId;
  String? mProjectId;
  String? description;
  String? point;
  String? status;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
        name: json["name"],
        duedate: json["duedate"],
        userAuthId: json["user_auth_id"],
        mProjectId: json["m_project_id"],
        description: json["description"],
        point: json["point"],
        status: json["status"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "duedate": duedate,
        "user_auth_id": userAuthId,
        "m_project_id": mProjectId,
        "description": description,
        "point": point,
        "status": status,
        "updated_at": updatedAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "id": id,
      };
}
