// To parse this JSON data, do
//
//     final acceptanceModelAcceptanceModel = acceptanceModelAcceptanceModelFromJson(jsonString);

import 'dart:convert';

AcceptanceModel acceptanceModelAcceptanceModelFromJson(String str) =>
    AcceptanceModel.fromJson(json.decode(str));

String acceptanceModelAcceptanceModelToJson(AcceptanceModel data) =>
    json.encode(data.toJson());

class AcceptanceModel {
  int? statusCode;
  List<AcceptanceItem>? data;
  String? message;
  List<dynamic>? settings;

  AcceptanceModel({
    this.statusCode,
    this.data,
    this.message,
    this.settings,
  });

  factory AcceptanceModel.fromJson(Map<String, dynamic> json) =>
      AcceptanceModel(
        statusCode: json["status_code"],
        data: json["data"] == null
            ? []
            : List<AcceptanceItem>.from(
                json["data"]!.map((x) => AcceptanceItem.fromJson(x))),
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

class AcceptanceItem {
  int? id;
  int? tTimeboxIssueId;
  String? name;
  String? status;

  AcceptanceItem({
    this.id,
    this.tTimeboxIssueId,
    this.name,
    this.status,
  });

  factory AcceptanceItem.fromJson(Map<String, dynamic> json) => AcceptanceItem(
        id: json["id"],
        tTimeboxIssueId: json["t_timebox_issue_id"],
        name: json["name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "t_timebox_issue_id": tTimeboxIssueId,
        "name": name,
        "status": status,
      };
}
