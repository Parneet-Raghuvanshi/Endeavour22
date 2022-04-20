class ProfileModel {
  String name;
  String endvrId;
  String userId;
  int amount;
  List<Company> company;

  ProfileModel({
    required this.name,
    required this.endvrId,
    required this.userId,
    required this.amount,
    required this.company,
  });

  factory ProfileModel.fromMap(Map map) {
    List<Company> temp = [];
    var tempMap = map['company'] as Map;
    temp = tempMap.values.map((e) => Company.fromMap(e)).toList();
    return ProfileModel(
      name: map['name'],
      endvrId: map['endvrId'],
      userId: map['userId'],
      amount: map['amount'],
      company: temp,
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> companyMap = {};
    for (var data in company) {
      companyMap[data.id] = data.toMap();
    }
    return {
      'name': name,
      'endvrId': endvrId,
      'userId': userId,
      'amount': amount,
      'company': companyMap,
    };
  }
}

class Company {
  String id;
  int stocks;

  Company({
    required this.id,
    required this.stocks,
  });

  factory Company.fromMap(Map map) {
    return Company(
      id: map['id'],
      stocks: map['stocks'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'stocks': stocks,
    };
  }
}
