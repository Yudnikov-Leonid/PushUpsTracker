import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddPushUpsDialog extends StatelessWidget {
  AddPushUpsDialog(this._pushUpsToday, {super.key});

  final _controller = TextEditingController();
  final int _pushUpsToday;
  bool isAdding = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                width: 50,
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                )),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () async {
                if (isAdding || _controller.text.isEmpty) return;
                isAdding = true;
                await _add(int.parse(_controller.text));
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _add(int value) async {
    final ref = FirebaseDatabase.instance.ref('push-ups');
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await ref.child('${FirebaseAuth.instance.currentUser!.uid}|$date').set({
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'season': 3,
      'date': date,
      'value': _pushUpsToday + value
    });
  }
}
