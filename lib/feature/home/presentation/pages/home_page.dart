import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:push_ups/core/firebase_repository.dart';
import 'package:push_ups/feature/home/domain/entity/day_push_ups.dart';
import 'package:push_ups/feature/home/presentation/pages/add_push_ups.dart';
import 'package:push_ups/feature/home/presentation/widgets/month_statistic.dart';

class HomePage extends StatefulWidget {
  const HomePage(this._repository, {super.key});

  final FirebaseRepository _repository;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  VoidCallback _callback = () {};

  @override
  void initState() {
    _callback = () {
      setState(() {});
    };
    widget._repository.addCallback(_callback);
    super.initState();
  }

  @override
  void dispose() {
    widget._repository.removeCallback(_callback);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seasons = <MonthStatistic>[];

    widget._repository.map.forEach((key, v) {
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
      seasons.add(MonthStatistic(
          title, v.map((e) => widget._repository.data[e]!).toList()));
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Push ups tracker')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AddPushUpsDialog(widget
                      ._repository
                      .data[DateFormat('yyyy-MM-dd').format(DateTime.now())]
                      ?.value ??
                  0));
        },
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
            Text('Last 28 days: ${widget._repository.last28Days} push ups'),
            Text(
                'Today: ${widget._repository.data[DateFormat('yyyy-MM-dd').format(DateTime.now())]?.value ?? 0}'),
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
