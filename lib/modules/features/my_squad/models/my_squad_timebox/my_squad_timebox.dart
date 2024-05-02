class MySquadTimebox {
  int? id;
  int? userAuthId;
  int? mProjectId;
  String? name;
  dynamic typeRepetition;
  dynamic description;
  String? duedate;
  String? point;
  String? status;
  dynamic isAccept;
  dynamic copiedFrom;
  int? progress;
  dynamic inputProgressUserId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? createdBy;
  int? updatedBy;
  int? deletedBy;
  String? projectName;
  String? creatorName;

  MySquadTimebox({
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
    this.progress,
    this.inputProgressUserId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.projectName,
    this.creatorName,
  });

  factory MySquadTimebox.fromJson(Map<String, dynamic> json) => MySquadTimebox(
        id: json['id'] as int?,
        userAuthId: json['user_auth_id'] as int?,
        mProjectId: json['m_project_id'] as int?,
        name: json['name'] as String?,
        typeRepetition: json['type_repetition'] as dynamic,
        description: json['description'] as dynamic,
        duedate: json['duedate'] as String?,
        point: json['point'] as String?,
        status: json['status'] as String?,
        isAccept: json['is_accept'] as dynamic,
        copiedFrom: json['copied_from'] as dynamic,
        progress: json['progress'] as dynamic,
        inputProgressUserId: json['input_progress_user_id'] as dynamic,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
        deletedAt: json['deleted_at'] as dynamic,
        createdBy: json['created_by'] as int?,
        updatedBy: json['updated_by'] as int?,
        deletedBy: json['deleted_by'] as int?,
        projectName: json['project_name'] as String?,
        creatorName: json['creator_name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_auth_id': userAuthId,
        'm_project_id': mProjectId,
        'name': name,
        'type_repetition': typeRepetition,
        'description': description,
        'duedate': duedate,
        'point': point,
        'status': status,
        'is_accept': isAccept,
        'copied_from': copiedFrom,
        'progress': progress,
        'input_progress_user_id': inputProgressUserId,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'deleted_at': deletedAt,
        'created_by': createdBy,
        'updated_by': updatedBy,
        'deleted_by': deletedBy,
        'project_name': projectName,
      };

  set setProgress(int val) {
    progress = val;
  }

  set setStatus(String val) {
    status = val;
  }
}

class DataIssuesSpace {
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

  DataIssuesSpace({
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

  factory DataIssuesSpace.fromJson(Map<String, dynamic> json) =>
      DataIssuesSpace(
        id: json["id"] as int?,
        duedate: json['duedate'] as String?,
        type: json["type"] as String?,
        mProjectStatus: json["m_project_status"] as String?,
        mProjectId: json["m_project_id"] as int?,
        point: json["point"] as int?,
        name: json["name"] as String?,
        userAuthId: json["user_auth_id"] as int?,
        projectName: json["project_name"] as String?,
        project: json['data'] == null
            ? null
            : Project.fromJson(json['project'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        'duedate': duedate,
        "type": type,
        "m_project_status": mProjectStatus,
        "m_project_id": mProjectId,
        "point": point,
        "name": name,
        "user_auth_id": userAuthId,
        "project_name": projectName,
        "project": project?.toJson(),
      };
}

class Project {
  int id;
  String name;

  Project({
    required this.id,
    required this.name,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
