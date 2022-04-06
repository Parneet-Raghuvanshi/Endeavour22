import 'dart:async';

import 'package:endeavour22/notifications/notification_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider with ChangeNotifier {
  List<NotificationModel> _notifications = [];
  int _dotCount = 0;
  final _notificationDB =
      FirebaseDatabase.instance.reference().child('notifications');
  late StreamSubscription<DatabaseEvent> _notificationStream;
  bool _completed = false;

  List<NotificationModel> get allNotification => _notifications;

  bool get completed => _completed;

  int get dotCount => _dotCount;

  void fetchNotifications(String userId) {
    _completed = false;
    _notificationStream = _notificationDB.child(userId).onValue.listen((event) {
      if (event.snapshot.value == null) {
        _notifications.clear();
        _completed = true;
        _dotCount = 0;
        notifyListeners();
      } else {
        _dotCount = 0;
        final _allData = Map<String, dynamic>.from(event.snapshot.value as Map);
        _notifications = _allData.values.map((e) {
          final data = NotificationModel.fromMap(Map<String, dynamic>.from(e));
          if (data.read == 'false') _dotCount++;
          return data;
        }).toList();
        _completed = true;
        notifyListeners();
      }
    });
  }

  void refreshNotifications(String userId) {
    final _notDB = FirebaseDatabase.instance.reference().child('notifications');
    _notDB.child(userId).once().then((event) {
      if (event.snapshot.value == null) {
        return;
      } else {
        final _allData = Map<String, dynamic>.from(event.snapshot.value as Map);
        _allData.forEach((key, value) {
          final data =
              NotificationModel.fromMap(Map<String, dynamic>.from(value));
          if (data.read == 'false') {
            final db = FirebaseDatabase.instance.reference();
            db
                .child('notifications')
                .child(userId)
                .child(data.id)
                .child('read')
                .set('true');
          }
        });
      }
    });
  }

  Future<void> deleteNotification(String userId, String id) async {
    final db = FirebaseDatabase.instance.reference();
    await db.child('notifications').child(userId).child(id).remove();
    notifyListeners();
  }

  @override
  void dispose() {
    _notificationStream.cancel();
    super.dispose();
  }
}
