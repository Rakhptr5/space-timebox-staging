// To parse this JSON data, do
//
//     final issueResponseModel = issueResponseModelFromJson(jsonString);

import 'dart:convert';

IssueResponseModel issueResponseModelFromJson(String str) =>
    IssueResponseModel.fromJson(json.decode(str));

String issueResponseModelToJson(IssueResponseModel data) =>
    json.encode(data.toJson());

class IssueResponseModel {
  IssueResponseModel({
    this.statusCode,
    this.data,
    this.message,
    this.settings,
  });

  int? statusCode;
  Data? data;
  String? message;
  List<dynamic>? settings;

  factory IssueResponseModel.fromJson(Map<String, dynamic> json) =>
      IssueResponseModel(
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
    this.issue,
    this.overdueIssue,
    this.timebox,
    this.overdueTimebox,
    this.point,
  });

  List<Issue>? issue;
  List<Issue>? overdueIssue;
  List<Timebox>? timebox;
  List<Timebox>? overdueTimebox;
  Point? point;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        issue: json["issue"] == null
            ? []
            : List<Issue>.from(json["issue"]!.map((x) => Issue.fromJson(x))),
        overdueIssue: json["overdue_issue"] == null
            ? []
            : List<Issue>.from(
                json["overdue_issue"]!.map((x) => Issue.fromJson(x))),
        timebox: json["timebox"] == null
            ? []
            : List<Timebox>.from(
                json["timebox"]!.map((x) => Timebox.fromJson(x))),
        overdueTimebox: json["overdue_timebox"] == null
            ? []
            : List<Timebox>.from(
                json["overdue_timebox"]!.map((x) => Timebox.fromJson(x))),
        point: json["point"] == null ? null : Point.fromJson(json["point"]),
      );

  Map<String, dynamic> toJson() => {
        "issue": issue == null
            ? []
            : List<dynamic>.from(issue!.map((x) => x.toJson())),
        "overdue_issue": overdueIssue == null
            ? []
            : List<dynamic>.from(overdueIssue!.map((x) => x.toJson())),
        "timebox": timebox == null
            ? []
            : List<dynamic>.from(timebox!.map((x) => x.toJson())),
        "overdue_timebox": overdueTimebox == null
            ? []
            : List<dynamic>.from(overdueTimebox!.map((x) => x.toJson())),
        "point": point?.toJson(),
      };
}

class Point {
  Point({
    this.pointDone,
    this.pointAll,
    this.issueCount,
  });

  String? pointDone;
  String? pointAll;
  String? issueCount;

  factory Point.fromJson(Map<String, dynamic> json) => Point(
        pointDone: json["point_done"],
        pointAll: json["point_all"],
        issueCount: json["issue_count"],
      );

  Map<String, dynamic> toJson() => {
        "point_done": pointDone,
        "point_all": pointAll,
        "issue_count": issueCount,
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
        userAuthName: json["user_auth_name"],
        mProjectId: json["m_project_id"],
        projectName: json["project_name"],
        mProjectStatus: json["m_project_status"],
        name: json["name"],
        type: json["type"],
        typeText: json["type_text"],
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
  String? assigneName;
  String? assignePhoto;

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
    this.assigneName,
    this.assignePhoto,
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
        assigneName: json['assigne_name'],
        assignePhoto: json['assigne_photo'],
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
