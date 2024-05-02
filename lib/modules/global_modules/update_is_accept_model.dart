// To parse this JSON data, do
//
//     final updateIsAcceptModel = updateIsAcceptModelFromJson(jsonString);

import 'dart:convert';

UpdateIsAcceptModel updateIsAcceptModelFromJson(String str) =>
    UpdateIsAcceptModel.fromJson(json.decode(str));

String updateIsAcceptModelToJson(UpdateIsAcceptModel data) =>
    json.encode(data.toJson());

class UpdateIsAcceptModel {
  int? statusCode;
  UpdateIsAcceptModelData? data;
  String? message;
  List<dynamic>? settings;

  UpdateIsAcceptModel({
    this.statusCode,
    this.data,
    this.message,
    this.settings,
  });

  factory UpdateIsAcceptModel.fromJson(Map<String, dynamic> json) =>
      UpdateIsAcceptModel(
        statusCode: json["status_code"],
        data: json["data"] == null
            ? null
            : UpdateIsAcceptModelData.fromJson(json["data"]),
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

class UpdateIsAcceptModelData {
  bool? status;
  DataData? data;

  UpdateIsAcceptModelData({
    this.status,
    this.data,
  });

  factory UpdateIsAcceptModelData.fromJson(Map<String, dynamic> json) =>
      UpdateIsAcceptModelData(
        status: json["status"],
        data: json["data"] == null ? null : DataData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
      };
}

class DataData {
  int? id;
  int? userAuthId;
  int? mProjectId;
  String? name;
  dynamic typeRepetition;
  String? description;
  dynamic duedate;
  String? point;
  String? status;
  String? isAccept;
  dynamic copiedFrom;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? createdBy;
  int? updatedBy;
  int? deletedBy;

  DataData({
    this.id,
    this.userAuthId,
    this.mProjectId,
    this.name,
    this.typeRepetition,
    this.description,
    this.duedate,
    this.point,
    this.status,
    this.isAccept,
    this.copiedFrom,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
  });

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
        id: json["id"],
        userAuthId: json["user_auth_id"],
        mProjectId: json["m_project_id"],
        name: json["name"],
        typeRepetition: json["type_repetition"],
        description: json["description"],
        duedate: json["duedate"],
        point: json["point"],
        status: json["status"],
        isAccept: json["is_accept"],
        copiedFrom: json["copied_from"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        deletedBy: json["deleted_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_auth_id": userAuthId,
        "m_project_id": mProjectId,
        "name": name,
        "type_repetition": typeRepetition,
        "description": description,
        "duedate": duedate,
        "point": point,
        "status": status,
        "is_accept": isAccept,
        "copied_from": copiedFrom,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "deleted_by": deletedBy,
      };
}
