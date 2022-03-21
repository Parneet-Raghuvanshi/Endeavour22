class EventDetailTile {
  String title;
  String body;

  EventDetailTile({
    required this.title,
    required this.body,
  });

  factory EventDetailTile.fromMap(Map map) {
    return EventDetailTile(
      title: map['title'],
      body: map['body'],
    );
  }
}
