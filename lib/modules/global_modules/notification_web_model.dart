class NotificationWebModel {
  const NotificationWebModel({
    required this.id,
    required this.body,
    required this.startTime,
    required this.finishTime,
  });

  final String id;
  final String body;
  final String startTime;
  final String finishTime;

  factory NotificationWebModel.fromJson(Map<String, dynamic> json) =>
      NotificationWebModel(
        id: json['id'] as String,
        body: json['body'] as String,
        startTime: json['startTime'] as String,
        finishTime: json['finishTime'] as String,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "body": body,
        "startTime": startTime,
        "finishTime": finishTime,
      };
}
