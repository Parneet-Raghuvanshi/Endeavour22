import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class GlimpsesProvider with ChangeNotifier {
  List<String> _glimpses = [];
  final _glDB = FirebaseDatabase.instance.reference().child('glimpses');
  late StreamSubscription<DatabaseEvent> _glStream;

  List<String> get glimpses => _glimpses;

  GlimpsesProvider() {
    _fetchGlimpses();
  }

  void _fetchGlimpses() {
    _glStream = _glDB.onValue.listen((event) {
      if (event.snapshot.value == null) {
        _glimpses.clear();
        notifyListeners();
      } else {
        final _allData = Map<String, dynamic>.from(event.snapshot.value as Map);
        _glimpses = _allData.values.map((e) {
          return e['img'].toString();
        }).toList();
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _glStream.cancel();
    super.dispose();
  }
}
