class EventModel {
  String name;
  String id;
  String eventId;
  String imgUri;
  String isOpen;
  String memberCount;
  String desc;
  String price;
  String mongoId;
  String discount;
  bool isDis;

  EventModel({
    required this.name,
    required this.id,
    required this.eventId,
    required this.imgUri,
    required this.isOpen,
    required this.memberCount,
    required this.desc,
    required this.price,
    required this.mongoId,
    required this.discount,
    required this.isDis,
  });

  factory EventModel.fromMap(Map map) {
    return EventModel(
      name: map['name'],
      id: map['id'],
      eventId: map['eventId'],
      imgUri: map['imgUri'],
      isOpen: map['isOpen'],
      memberCount: map['memberCount'],
      desc: map['desc'],
      price: map['price'],
      mongoId: map['mongoId'],
      discount: map['discount'],
      isDis: map['isDis'],
    );
  }
}
