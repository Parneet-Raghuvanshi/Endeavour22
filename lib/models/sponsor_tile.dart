class SponsorTile {
  String name;
  String link;
  String cat;
  String imgUri;
  String tile;

  SponsorTile({
    required this.name,
    required this.link,
    required this.imgUri,
    required this.cat,
    required this.tile,
  });

  factory SponsorTile.fromMap(Map map) {
    return SponsorTile(
      name: map['name'],
      link: map['link'],
      imgUri: map['imgUri'],
      cat: map['cat'],
      tile: map['tile'],
    );
  }
}
