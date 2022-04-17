class TeamTile {
  String name;
  String domain;
  String rank;
  String imgUri;
  String fbP;
  String liP;
  String glP;
  int badgeType;
  int badgeCount;

  TeamTile({
    required this.name,
    required this.domain,
    required this.rank,
    required this.imgUri,
    required this.fbP,
    required this.liP,
    required this.glP,
    required this.badgeCount,
    required this.badgeType,
  });

  factory TeamTile.fromMap(Map map) {
    return TeamTile(
      name: map['name'],
      domain: map['domain'],
      rank: map['rank'],
      imgUri: map['imgUri'],
      fbP: map['fbP'],
      liP: map['liP'],
      glP: map['glP'],
      badgeCount: map['badgeCount'],
      badgeType: map['badgeType'],
    );
  }
}
