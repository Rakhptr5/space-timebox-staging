class MySquadPercentageModel {
  const MySquadPercentageModel({
    required this.id,
    required this.totalPercentage,
    required this.listPercentage,
    required this.listPoint,
  });

  final String id;
  final int totalPercentage;
  final List<int> listPercentage;
  final List<num> listPoint;
}
