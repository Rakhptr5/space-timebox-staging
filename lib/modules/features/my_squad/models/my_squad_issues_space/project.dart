class Project {
  int? id;
  String? name;

  Project({this.id, this.name});

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'] as int?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
