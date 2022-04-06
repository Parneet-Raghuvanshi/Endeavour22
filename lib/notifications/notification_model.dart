class NotificationModel {
  String title;
  String body;
  String id;
  String date;
  String read;

  NotificationModel({
    required this.title,
    required this.body,
    required this.id,
    required this.date,
    required this.read,
  });

  factory NotificationModel.fromMap(Map map) {
    return NotificationModel(
      title: map['title'],
      body: map['body'],
      id: map['id'],
      date: map['date'],
      read: map['read'],
    );
  }
}
