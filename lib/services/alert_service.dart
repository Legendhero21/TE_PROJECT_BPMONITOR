import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AlertService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  void startMonitoring(BuildContext context) {
    _db.child('users/default_user/bp_readings').onChildAdded.listen((event) {
      final data = event.snapshot.value as Map;
      final sys = data['systolic'] ?? 0;
      final dia = data['diastolic'] ?? 0;

      if (sys > 140 || dia > 90) {
        _showAlert(context, "High BP: $sys/$dia mmHg. Consult Doctor.");
      } else if (sys < 90 || dia < 60) {
        _showAlert(context, "Low BP: $sys/$dia mmHg. Stay hydrated.");
      }
    });
  }

  void _showAlert(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
