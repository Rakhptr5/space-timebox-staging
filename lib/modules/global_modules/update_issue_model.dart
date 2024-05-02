// To parse this JSON data, do
//
//     final updateIssueResponseModel = updateIssueResponseModelFromJson(jsonString);

import 'dart:convert';

UpdateIssueResponseModel updateIssueResponseModelFromJson(String str) =>
    UpdateIssueResponseModel.fromJson(json.decode(str));

String updateIssueResponseModelToJson(UpdateIssueResponseModel data) =>
    json.encode(data.toJson());

class UpdateIssueResponseModel {
  UpdateIssueResponseModel({
    this.statusCode,
    this.data,
    this.message,
    this.settings,
  });

  int? statusCode;
  Data? data;
  String? message;
  List<dynamic>? settings;

  factory UpdateIssueResponseModel.fromJson(Map<String, dynamic> json) =>
      UpdateIssueResponseModel(
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
    this.id,
    this.name,
    this.dayType,
    this.duedate,
    this.project,
    this.mProjectId,
    this.description,
    this.statusText,
    this.status,
    this.point,
  });

  int? id;
  String? name;
  int? dayType;
  String? duedate;
  String? project;
  String? mProjectId;
  String? description;
  String? statusText;
  String? status;
  String? point;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        dayType: json["day_type"],
        duedate: json["duedate"],
        project: (json["project"].toString() == "")
            ? "0"
            : json["project"].toString(),
        mProjectId: (json["m_project_id"].toString() == "")
            ? "0"
            : json["m_project_id"].toString(),
        description: (json["description"].toString() == "")
            ? "0"
            : json["description"].toString(),
        statusText: json["status_text"],
        status: json["status"],
        point: json["point"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "day_type": dayType,
        "duedate": duedate,
        "project": project,
        "m_project_id": mProjectId,
        "description": description,
        "status_text": statusText,
        "status": status,
        "point": point,
      };
}
