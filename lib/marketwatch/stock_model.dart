class StockModel {
  String name;
  String id;
  String round;
  int rate;
  bool isUp;

  StockModel({
    required this.name,
    required this.id,
    required this.rate,
    required this.round,
    required this.isUp,
  });

  factory StockModel.fromMap(Map map) {
    return StockModel(
      name: map['name'],
      id: map['id'],
      rate: map['rate'],
      round: map['round'],
      isUp: map['isUp'],
    );
  }
}
