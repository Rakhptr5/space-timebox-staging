import '../home_model.dart';

class SquadNew extends CardIssueDataModel {
  int? userAuthId;
  String? namaUser;
  String? humanisFoto;
  String? humanisPositionName;
  int? countIssue;
  bool? haveProject;

  SquadNew({
    this.userAuthId,
    this.namaUser,
    this.humanisFoto,
    this.humanisPositionName,
    this.countIssue,
    this.haveProject = false,
  });

  factory SquadNew.fromJson(Map<String, dynamic> json) => SquadNew(
        userAuthId: json['user_auth_id'] as int?,
        namaUser: json['nama_user'] as String?,
        humanisFoto: json['humanis_foto'] as String?,
        humanisPositionName: json['humanis_position_name'] as String?,
        countIssue: json['countIssue'] as int?,
        haveProject: json['have_project'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'user_auth_id': userAuthId,
        'nama_user': namaUser,
        'humanis_foto': humanisFoto,
        'humanis_position_name': humanisPositionName,
        'countIssue': countIssue,
      };
}
