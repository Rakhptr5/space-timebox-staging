class MySquadTimeboxPut {
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
  int? inputProgressUserId;
  String? checkedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? createdBy;
  int? updatedBy;
  int? deletedBy;

  MySquadTimeboxPut({
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
    this.checkedAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
  });

  factory MySquadTimeboxPut.fromJson(Map<String, dynamic> json) =>
      MySquadTimeboxPut(
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
        progress: json['progress'] as int?,
        inputProgressUserId: json['input_progress_user_id'] as int?,
        checkedAt: json['checked_at'] as String?,
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
        'checked_at': checkedAt,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'deleted_at': deletedAt,
        'created_by': createdBy,
        'updated_by': updatedBy,
        'deleted_by': deletedBy,
      };
}
