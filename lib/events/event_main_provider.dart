import 'dart:async';
import 'dart:collection';

import 'package:endeavour22/events/event_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class EventMainProvider with ChangeNotifier {
  final List<EventModel> _corpEvents = [];
  final List<EventModel> _funEvents = [];
  final List<EventModel> _spsEvents = [];
  bool _isEventsOpen = true;
  final _eventDB = FirebaseDatabase.instance.ref().child('eventMain');
  late StreamSubscription<DatabaseEvent> _eventStream;

  List<EventModel> get corpEvents => _corpEvents;
  List<EventModel> get funEvents => _funEvents;
  List<EventModel> get spsEvents => _spsEvents;

  EventMainProvider() {
    _fetchEvents();
  }

  bool get isEventsOpen {
    return _isEventsOpen;
  }

  void _fetchEvents() {
    _eventStream = _eventDB.onValue.listen((event) {
      if (event.snapshot.value == null) {
        _corpEvents.clear();
        _funEvents.clear();
        _spsEvents.clear();
        _isEventsOpen = false;
        notifyListeners();
      } else {
        final _allData = new SplayTreeMap<String, dynamic>.from(
            event.snapshot.value as Map, (a, b) => a.compareTo(b));
        _allData.forEach((key, value) {
          final data = EventModel.fromMap(value);
          if (data.eventId.contains('CORP')) {
            _corpEvents.add(data);
          } else if (data.eventId.contains('FUN')) {
            _funEvents.add(data);
          } else if (data.eventId.contains('SPS')) {
            _spsEvents.add(data);
          }
        });
        _isEventsOpen = true;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _eventStream.cancel();
    super.dispose();
  }
}
