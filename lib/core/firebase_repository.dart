import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:push_ups/feature/home/domain/entity/day_push_ups.dart';

class FirebaseRepository {
  final List<VoidCallback> _callbacks = [];
  FirebaseRepository();

  final Map<String, BaseDayPushUps> data = {};
  final Map<int, List<String>> map = {}; //season, dates
  int last28Days = 0;

  int currentSeason = 0;

  void addCallback(VoidCallback reload) {
    _callbacks.add(reload);
  }
  
  void removeCallback(VoidCallback reload) {
    _callbacks.remove(reload);
  }

  void init() {
    var month = DateTime.now().month;
    month += (DateTime.now().year - 2024) * 12;
    currentSeason = month ~/ 3 + 1;


    final ref = FirebaseDatabase.instance.ref('push-ups').orderByChild('date');
    final formatter = DateFormat('yyyy-MM-dd');
    ref.onValue.listen((sn) {
      map.clear();
      data.clear();
      last28Days = 0;

      final previous28Days = DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day - 28);

      final list = sn.snapshot.children.where((child) =>
          child.child('userId').value.toString() ==
          FirebaseAuth.instance.currentUser!.uid);
      list.forEach((e) {
        data[e.child('date').value.toString()] = BaseDayPushUps(
            value: int.parse(e.child('value').value.toString()),
            season: int.parse(e.child('season').value.toString()),
            date: e.child('date').value.toString());
      });
      data.forEach((key, e) {
        if (map[e.season] == null) {
          map[e.season] = [e.date];
        } else {
          map[e.season]!.add(e.date);
        }
        if (formatter.parse(e.date).millisecondsSinceEpoch >
            previous28Days.millisecondsSinceEpoch) {
          last28Days += e.value;
        }
      });
      _callbacks.forEach((e) {
        e();
      });
    });
  }
}
