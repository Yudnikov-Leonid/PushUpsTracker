import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:push_ups/core/firebase_repository.dart';
import 'package:push_ups/feature/login/bloc/login_bloc.dart';
import 'package:push_ups/feature/login/bloc/login_event.dart';
import 'package:push_ups/feature/profile/presentation/widgets/goal_pie.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage(this._repository, {super.key});

  final FirebaseRepository _repository;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Icon(
              Icons.person,
              size: 60,
            ),
            Text(
              FirebaseAuth.instance.currentUser!.displayName ?? 'user',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: const Text('Reset today?'),
                            content: Text(
                                'Push ups today: ${widget._repository.data[DateFormat('yyyy-MM-dd').format(DateTime.now())]?.value ?? 0}'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancel')),
                              TextButton(
                                  onPressed: () async {
                                    await _resetDay();
                                    Navigator.of(context).pop();
                                    setState(() {});
                                  },
                                  child: const Text('Reset')),
                            ],
                          ));
                },
                child: const Text('Reset today')),
            TextButton(
              onPressed: () {
                context.read<LoginBloc>().add(LogOutEvent());
              },
              child: const Text('Log out'),
            ),
            GoalPie(
                widget._repository.data.values
                    .where((e) => e.season == 3)
                    .fold(0, (a, b) => a + b.value),
                10000)
          ],
        ),
      ),
    );
  }

  Future<void> _resetDay() async {
    final ref = FirebaseDatabase.instance.ref('push-ups');
    await ref
        .child(
            '${FirebaseAuth.instance.currentUser!.uid}|${DateFormat('yyyy-MM-dd').format(DateTime.now())}')
        .remove();
  }
}
