import 'dart:async';

import 'package:endeavour22/events/event_detail_tile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class EventContentProvider with ChangeNotifier {
  List<EventDetailTile> _contentAll = [];
  late StreamSubscription<DatabaseEvent> _contentStream;

  List<EventDetailTile> get allContent => _contentAll;

  void fetchData(String eventId) {
    _fetchContent(eventId);
  }

  void _fetchContent(String eventId) {
    final _contentDB =
        FirebaseDatabase.instance.ref().child('eventContent').child(eventId);
    _contentStream = _contentDB.onValue.listen((event) {
      if (event.snapshot.value == null) {
        _contentAll.clear();
        notifyListeners();
      } else {
        final _allData = Map<String, dynamic>.from(event.snapshot.value as Map);
        _contentAll = _allData.values.map((e) {
          final data = EventDetailTile.fromMap(Map<String, dynamic>.from(e));
          return data;
        }).toList();
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _contentStream.cancel();
    super.dispose();
  }
}
