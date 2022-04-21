import 'dart:async';
import 'dart:collection';

import 'package:endeavour22/schedule/schedule_tile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class ScheduleProvider with ChangeNotifier {
  List<ScheduleTile> _dayOneSchedule = [];
  List<ScheduleTile> _dayTwoSchedule = [];
  final _dayOneDB =
      FirebaseDatabase.instance.reference().child('schedule').child('dayone');
  final _dayTwoDB =
      FirebaseDatabase.instance.reference().child('schedule').child('daytwo');
  late StreamSubscription<DatabaseEvent> _dayOneStream;
  late StreamSubscription<DatabaseEvent> _dayTwoStream;
  bool _completedOne = false;
  bool _completedTwo = false;

  List<ScheduleTile> get dayOne => _dayOneSchedule;
  List<ScheduleTile> get dayTwo => _dayTwoSchedule;

  bool get completedOne => _completedOne;
  bool get completedTwo => _completedTwo;

  ScheduleProvider() {
    _fetchDayOneSchedule();
    _fetchDayTwoSchedule();
  }

  void _fetchDayOneSchedule() {
    _dayOneStream = _dayOneDB.onValue.listen((event) {
      if (event.snapshot.value == null) {
        _dayOneSchedule.clear();
        _completedOne = true;
        notifyListeners();
      } else {
        final _allData = new SplayTreeMap<String, dynamic>.from(
            event.snapshot.value as Map, (a, b) => a.compareTo(b));
        _dayOneSchedule = _allData.values.map((e) {
          final data = ScheduleTile.fromMap(Map<String, dynamic>.from(e));
          return data;
        }).toList();
        _completedOne = true;
        notifyListeners();
      }
    });
  }

  void _fetchDayTwoSchedule() {
    _dayTwoStream = _dayTwoDB.onValue.listen((event) {
      if (event.snapshot.value == null) {
        _dayTwoSchedule.clear();
        _completedTwo = true;
        notifyListeners();
      } else {
        final _allData = new SplayTreeMap<String, dynamic>.from(
            event.snapshot.value as Map, (a, b) => a.compareTo(b));
        _dayTwoSchedule = _allData.values.map((e) {
          final data = ScheduleTile.fromMap(Map<String, dynamic>.from(e));
          return data;
        }).toList();
        _completedTwo = true;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _dayOneStream.cancel();
    _dayTwoStream.cancel();
    super.dispose();
  }
}
