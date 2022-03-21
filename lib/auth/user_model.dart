class UserModel {
  String id;
  String name;
  String email;
  String phoneNumber;
  bool confirmed;
  String role;
  bool profile;
  bool eventPass;
  bool internshipFair;
  bool hackathon;
  String endvrid;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.confirmed,
    required this.role,
    required this.profile,
    required this.eventPass,
    required this.internshipFair,
    required this.hackathon,
    required this.endvrid,
  });

  factory UserModel.fromMap(Map map) {
    return UserModel(
      id: map['_id'],
      name: map['name'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      confirmed: map['confirmed'],
      role: map['role'],
      profile: map['profile'],
      eventPass: map['eventPass'],
      internshipFair: map['internshipFair'],
      hackathon: map['hackathon'],
      endvrid: map['endvrid'],
    );
  }
}
