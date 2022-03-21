class SpeakerTile {
  String name;
  String desc;
  String tag;
  String imgUri;
  String fbP;
  String liP;
  String isP;
  String twP;

  SpeakerTile({
    required this.name,
    required this.desc,
    required this.tag,
    required this.imgUri,
    required this.fbP,
    required this.liP,
    required this.isP,
    required this.twP,
  });

  factory SpeakerTile.fromMap(Map map) {
    return SpeakerTile(
      name: map['name'],
      desc: map['desc'],
      tag: map['tag'],
      imgUri: map['imgUri'],
      fbP: map['fbP'],
      liP: map['liP'],
      isP: map['isP'],
      twP: map['twP'],
    );
  }
}
