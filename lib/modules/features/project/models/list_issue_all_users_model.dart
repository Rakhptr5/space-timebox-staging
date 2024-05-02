// To parse this JSON data, do
//
//     final listIssueAllUsersModel = listIssueAllUsersModelFromJson(jsonString);

import 'dart:convert';

ListIssueAllUsersModel listIssueAllUsersModelFromJson(String str) =>
    ListIssueAllUsersModel.fromJson(json.decode(str));

String listIssueAllUsersModelToJson(ListIssueAllUsersModel data) =>
    json.encode(data.toJson());

class ListIssueAllUsersModel {
  int? statusCode;
  List<Datum>? data;
  String? message;
  List<dynamic>? settings;

  ListIssueAllUsersModel({
    this.statusCode,
    this.data,
    this.message,
    this.settings,
  });

  factory ListIssueAllUsersModel.fromJson(Map<String, dynamic> json) =>
      ListIssueAllUsersModel(
        statusCode: json["status_code"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        message: json["message"],
        settings: json["settings"] == null
            ? []
            : List<dynamic>.from(json["settings"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
        "settings":
            settings == null ? [] : List<dynamic>.from(settings!.map((x) => x)),
      };
}

class Datum {
  int? id;
  String? mProjectId;
  int? mRolesId;
  int? userAuthId;
  String? namaUser;
  String? humanisFoto;
  List<Timebox>? timebox;
  List<Issue>? issues;
  int? countIssues;
  double? countPoint;

  Datum({
    this.id,
    this.mProjectId,
    this.mRolesId,
    this.userAuthId,
    this.namaUser,
    this.humanisFoto,
    this.timebox,
    this.issues,
    this.countIssues,
    this.countPoint,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        mProjectId: json["m_project_id"],
        mRolesId: json["m_roles_id"],
        userAuthId: json["user_auth_id"],
        namaUser: json["nama_user"],
        humanisFoto: json["humanis_foto"],
        timebox: json["timebox"] == null
            ? []
            : List<Timebox>.from(
                json["timebox"]!.map((x) => Timebox.fromJson(x))),
        issues: json["issues"] == null
            ? []
            : List<Issue>.from(json["issues"]!.map((x) => Issue.fromJson(x))),
        countIssues: json["count_issues"],
        countPoint: json["count_point"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "m_project_id": mProjectId,
        "m_roles_id": mRolesId,
        "user_auth_id": userAuthId,
        "nama_user": namaUser,
        "humanis_foto": humanisFoto,
        "timebox": timebox == null
            ? []
            : List<dynamic>.from(timebox!.map((x) => x.toJson())),
        "issues": issues == null
            ? []
            : List<dynamic>.from(issues!.map((x) => x.toJson())),
        "count_issues": countIssues,
        "count_point": countPoint,
      };
}

class Issue {
  Issue({
    this.id,
    this.userAuthId,
    this.userAuthName,
    this.mProjectId,
    this.projectName,
    this.mProjectStatus,
    this.name,
    this.type,
    this.typeText,
    this.point,
    this.duedate,
    this.dayType,
  });

  int? id;
  int? userAuthId;
  String? userAuthName;
  int? mProjectId;
  String? projectName;
  String? mProjectStatus;
  String? name;
  String? type;
  String? typeText;
  String? point;
  String? duedate;
  String? dayType;

  factory Issue.fromJson(Map<String, dynamic> json) => Issue(
        id: json["id"],
        userAuthId: json["user_auth_id"],
        userAuthName: json["user_auth_name"]?.toString(),
        mProjectId: json["m_project_id"],
        projectName: json["project_name"]?.toString(),
        mProjectStatus: json["m_project_status"]?.toString(),
        name: json["name"]?.toString(),
        type: json["type"]?.toString(),
        typeText: json["type_text"]?.toString(),
        point: json["point"]?.toString(),
        duedate: json["duedate"]?.toString(),
        dayType: json["day_type"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_auth_id": userAuthId,
        "user_auth_name": userAuthName,
        "m_project_id": mProjectId,
        "project_name": projectName,
        "m_project_status": mProjectStatus,
        "name": name,
        "type": type,
        "typeName": typeText,
        "point": point,
        "duedate": duedate,
        "dayType": dayType,
      };
}

class Timebox {
  int? id;
  String? name;
  String? dayType;
  String? date;
  String? dateName;
  String? project;
  int? mProjectId;
  String? description;
  String? statusText;
  String? status;
  String? point;
  String? pointJam;
  String? typeRepetition;
  int? userAuthId;
  String? isAccept;
  String? createdAt;
  int? createdBy;
  String? creatorName;
  int? acceptanceDone;
  int? acceptanceAll;
  String? instructionStatus;
  bool? isInstruction;

  Timebox({
    this.id,
    this.name,
    this.dayType,
    this.date,
    this.dateName,
    this.project,
    this.mProjectId,
    this.description,
    this.statusText,
    this.status,
    this.point,
    this.pointJam,
    this.typeRepetition,
    this.userAuthId,
    this.isAccept,
    this.createdBy,
    this.creatorName,
    this.acceptanceDone,
    this.acceptanceAll,
    this.isInstruction,
    this.instructionStatus,
  });

  factory Timebox.fromJson(Map<String, dynamic> json) => Timebox(
        id: json["id"],
        name: json["name"],
        dayType: json["day_type"].toString(),
        date: json["date"].toString(),
        dateName: json["date_name"],
        project: json["project"],
        mProjectId: json["m_project_id"],
        description: json["description"],
        statusText: json["status_text"],
        status: json["status"],
        point: json["point"]?.toString(),
        pointJam: json["point_jam"].toString(),
        typeRepetition: json['type_repetition'].toString(),
        userAuthId: json["user_auth_id"],
        isAccept: json["is_accept"].toString(),
        createdBy: json["created_by"],
        creatorName: json["creator_name"].toString(),
        acceptanceDone: json["acceptance_done"],
        acceptanceAll: json["acceptance_all"],
        isInstruction: json['is_instruction'],
        instructionStatus: json['status_instruction'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_auth_id": userAuthId,
        "m_project_id": mProjectId,
        "name": name,
        "type_repetition": typeRepetition,
        "description": description,
        "point": point,
        "status": status,
        "is_accept": isAccept,
        "created_at": createdAt,
        "created_by": createdBy,
        "creator_name": creatorName,
        "day_type": dayType,
        "date": date,
        "date_name": dateName,
        "project": project,
        "status_text": statusText,
        "point_jam": pointJam,
        "acceptance_done": acceptanceDone,
        "acceptance_all": acceptanceAll,
      };
}
