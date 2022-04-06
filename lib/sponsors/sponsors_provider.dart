import 'dart:async';

import 'package:endeavour22/sponsors/sponsor_tile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class SponsorsProvider with ChangeNotifier {
  List<SponsorTile> _sponsors = [];
  final _sponsorDB = FirebaseDatabase.instance.reference().child('sponsors');
  late StreamSubscription<DatabaseEvent> _sponsorsStream;
  bool _completed = false;

  List<SponsorTile> get allSponsors => _sponsors;

  bool get completed => _completed;

  SponsorsProvider() {
    _fetchSponsors();
  }

  void _fetchSponsors() {
    _sponsorsStream = _sponsorDB.onValue.listen((event) {
      if (event.snapshot.value == null) {
        _sponsors.clear();
        _completed = true;
        notifyListeners();
      } else {
        final _allData = Map<String, dynamic>.from(event.snapshot.value as Map);
        _sponsors = _allData.values.map((e) {
          final data = SponsorTile.fromMap(Map<String, dynamic>.from(e));
          return data;
        }).toList();
        _completed = true;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _sponsorsStream.cancel();
    super.dispose();
  }
}
