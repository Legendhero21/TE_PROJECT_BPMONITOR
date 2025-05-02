import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'services/alert_service.dart'; // ✅ In-app alert service

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } catch (e) {
    if (!e.toString().contains("already exists")) {
      rethrow;
    }
  }

  runApp(const BPMonitorApp());
}

class BPMonitorApp extends StatelessWidget {
  const BPMonitorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BP Monitor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) {
        // ✅ Start alert monitoring *after* context is available
        WidgetsBinding.instance.addPostFrameCallback((_) {
          AlertService().startMonitoring(context);
        });
        return child!;
      },
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
