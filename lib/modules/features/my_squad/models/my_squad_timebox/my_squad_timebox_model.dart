import '../my_squad_issues_space/my_squad_issues_space.dart';
import 'my_squad_timebox.dart';

class MySquadTimeboxModel {
  String? tanggal;
  String? checkedIn;
  List<MySquadTimebox>? modelData;
  List<MySquadIssuesSpace>? modelDataIssueSpace;

  MySquadTimeboxModel({
    this.tanggal,
    this.modelData,
    this.modelDataIssueSpace,
    this.checkedIn,
  });

  factory MySquadTimeboxModel.fromJson(Map<String, dynamic> json) =>
      MySquadTimeboxModel(
        tanggal: json['tanggal'] as String?,
        checkedIn: json['checked_in'] as String?,
        modelData: (json['data'] as List<dynamic>?)
            ?.map((e) => MySquadTimebox.fromJson(e as Map<String, dynamic>))
            .toList(),
        modelDataIssueSpace: (json['dataIssueSpace'] as List<dynamic>?)
            ?.map((e) => MySquadIssuesSpace.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'tanggal': tanggal,
        'checked_in': checkedIn,
        'data': modelData?.map((e) => e.toJson()).toList(),
        'dataIssueSpace': modelDataIssueSpace?.map((e) => e.toJson()).toList(),
      };
}
