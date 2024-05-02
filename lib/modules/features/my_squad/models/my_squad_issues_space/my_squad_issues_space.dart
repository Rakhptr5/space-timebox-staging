import 'project.dart';

class MySquadIssuesSpace {
  int? id;
  String? duedate;
  String? type;
  String? mProjectStatus;
  int? mProjectId;
  int? point;
  String? name;
  int? userAuthId;
  String? projectName;
  Project? project;

  MySquadIssuesSpace({
    this.id,
    this.duedate,
    this.type,
    this.mProjectStatus,
    this.mProjectId,
    this.point,
    this.name,
    this.userAuthId,
    this.projectName,
    this.project,
  });

  factory MySquadIssuesSpace.fromJson(Map<String, dynamic> json) {
    return MySquadIssuesSpace(
      id: json['id'] as int?,
      duedate: json['duedate'] as String?,
      type: json['type'] as String?,
      mProjectStatus: json['m_project_status'] as String?,
      mProjectId: json['m_project_id'] as int?,
      point: json['point'] as int?,
      name: json['name'] as String?,
      userAuthId: json['user_auth_id'] as int?,
      projectName: json['project_name'] as String?,
      project: json['project'] == null
          ? null
          : Project.fromJson(json['project'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'duedate': duedate,
        'type': type,
        'm_project_status': mProjectStatus,
        'm_project_id': mProjectId,
        'point': point,
        'name': name,
        'user_auth_id': userAuthId,
        'project_name': projectName,
        'project': project?.toJson(),
      };
}
