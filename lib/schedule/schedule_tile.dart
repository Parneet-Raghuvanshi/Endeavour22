class ScheduleTile {
  String title;
  String time;
  String location;

  ScheduleTile({
    required this.title,
    required this.location,
    required this.time,
  });

  factory ScheduleTile.fromMap(Map map) {
    return ScheduleTile(
      title: map['title'],
      location: map['location'],
      time: map['time'],
    );
  }
}
