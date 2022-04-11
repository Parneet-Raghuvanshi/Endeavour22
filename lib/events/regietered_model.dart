class RegisteredModel {
  String eventName;
  List<Member> members;

  RegisteredModel({
    required this.eventName,
    required this.members,
  });

  factory RegisteredModel.fromMap(Map map) {
    List<Member> tempMember = [];
    for (var element in map['members']) {
      tempMember.add(Member.fromMap(element));
    }
    return RegisteredModel(
      eventName: map['name'],
      members: tempMember,
    );
  }
}

class Member {
  String name;
  String email;
  String endvrid;
  String college;
  String branch;
  bool isLeader;

  Member({
    required this.name,
    required this.email,
    required this.endvrid,
    required this.college,
    required this.branch,
    required this.isLeader,
  });

  factory Member.fromMap(Map map) {
    return Member(
      name: map['name'],
      email: map['email'],
      endvrid: map['endvrid'],
      college: map['college'],
      branch: map['branch'],
      isLeader: map['isLeader'],
    );
  }
}
