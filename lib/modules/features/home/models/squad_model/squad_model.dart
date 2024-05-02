class SquadModel {
  int? id;
  int? atasanId;
  int? humanisId;
  String? humanisFoto;
  int? humanisPositionId;
  String? nama;
  String? humanisDepartmentName;
  String? humanisPositionName;
  int? countIssue;
  String? checkedAt;

  SquadModel({
    this.id,
    this.atasanId,
    this.humanisId,
    this.humanisFoto,
    this.humanisPositionId,
    this.nama,
    this.humanisDepartmentName,
    this.humanisPositionName,
    this.countIssue,
    this.checkedAt,
  });

  factory SquadModel.fromJson(Map<String, dynamic> json) => SquadModel(
        id: json['id'] as int?,
        atasanId: json['atasan_id'] as int?,
        humanisId: json['humanis_id'] as int?,
        humanisFoto: json['humanis_foto'] as String?,
        humanisPositionId: json['humanis_position_id'] as int?,
        nama: json['nama'] as String?,
        humanisDepartmentName: json['humanis_department_name'] as String?,
        humanisPositionName: json['humanis_position_name'] as String?,
        countIssue: json['count_issue'] as int?,
        checkedAt: json['checked_at'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'atasan_id': atasanId,
        'humanis_id': humanisId,
        'humanis_foto': humanisFoto,
        'humanis_position_id': humanisPositionId,
        'nama': nama,
        'humanis_department_name': humanisDepartmentName,
        'humanis_position_name': humanisPositionName,
        'count_issue': countIssue,
        'checked_at': checkedAt,
      };

  static List<SquadModel> fromJsonList(List list) {
    return list.map((item) => SquadModel.fromJson(item)).toList();
  }
}
