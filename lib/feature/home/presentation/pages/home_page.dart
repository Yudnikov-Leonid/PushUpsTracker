import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:push_ups/feature/home/domain/entity/day_push_ups.dart';
import 'package:push_ups/feature/home/presentation/widgets/month_statistic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<String, DayPushUps> _data = {};
  final Map<int, List<String>> _map = {}; //season, dates

  @override
  void initState() {
    final ref = FirebaseDatabase.instance.ref('push-ups').orderByChild('date');
    ref.onValue.listen((sn) {
      _map.clear();
      _data.clear();

      final list = sn.snapshot.children.where((child) =>
          child.child('userId').value.toString() ==
          FirebaseAuth.instance.currentUser!.uid);
      list.forEach((e) {
        _data[e.child('date').value.toString()] = DayPushUps(
            value: int.parse(e.child('value').value.toString()),
            season: int.parse(e.child('season').value.toString()),
            date: e.child('date').value.toString());
      });
      _data.forEach((key, e) {
        if (_map[e.season] == null) {
          _map[e.season] = [e.date];
        } else {
          _map[e.season]!.add(e.date);
        }
      });
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final seasons = <MonthStatistic>[];

    _map.forEach((key, v) {
      final String title;
      if (key % 4 == 1) {
        title = 'Winter';
      } else if (key % 4 == 2) {
        title = 'Sprint';
      } else if (key % 4 == 3) {
        title = 'Summer';
      } else {
        title = 'Autumn';
      }
      seasons.add(MonthStatistic(title, v.map((e) => _data[e]!).toList()));
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Push ups tracker'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.green.shade300,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            const Icon(
              Icons.person,
              size: 60,
            ),
            Text(
              FirebaseAuth.instance.currentUser!.displayName ?? 'user',
              style: const TextStyle(fontSize: 18),
            ),
            Text('Last 28 days: 2500 push ups'),
            Text('Today: 80'),
            const SizedBox(
              height: 50,
            ),
            const Text('Statistic by seasons'),
            Column(
              children: seasons.reversed.toList(),
            ),
            const SizedBox(
              height: 65,
            )
          ],
        ),
      ),
    );
  }
}
