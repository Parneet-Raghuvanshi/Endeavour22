import 'dart:async';

import 'package:endeavour22/team/team_tile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class TeamProvider with ChangeNotifier {
  List<TeamTile> _team = [];
  final _teamDB = FirebaseDatabase.instance.reference().child('team');
  late StreamSubscription<DatabaseEvent> _teamStream;
  bool _completed = false;

  List<TeamTile> get allTeam => _team;

  bool get completed => _completed;

  TeamProvider() {
    _fetchTeam();
  }

  void _fetchTeam() {
    _teamStream = _teamDB.onValue.listen((event) {
      if (event.snapshot.value == null) {
        _team.clear();
        _completed = true;
        notifyListeners();
      } else {
        final _allData = Map<String, dynamic>.from(event.snapshot.value as Map);
        _team = _allData.values.map((e) {
          final data = TeamTile.fromMap(Map<String, dynamic>.from(e));
          return data;
        }).toList();
        _completed = true;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _teamStream.cancel();
    super.dispose();
  }
}
