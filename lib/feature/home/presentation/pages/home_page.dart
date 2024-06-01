import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:push_ups/feature/home/presentation/widgets/mouth_statistic.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push ups tracker'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              size: 60,
            ),
            Text(
              FirebaseAuth.instance.currentUser!.displayName ?? 'user',
              style: const TextStyle(fontSize: 18),
            ),
            Text('Last 28 days: 2500 push ups'),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
                width: 100,
                child: TextField(
                  keyboardType: TextInputType.number,
                )),
            TextButton(onPressed: () {}, child: const Text('Add')),
            Text('Today: 80'),
            const SizedBox(
              height: 50,
            ),
            const Text('Statistic by seasons'),
            MouthStatistic('Spring', [5, 0, 5, 0, 12, 44, 55, 1, 0, 22]),
            MouthStatistic('Spring', [5, 0, 5, 0, 12, 44, 55, 1, 0, 22]),
            const SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
