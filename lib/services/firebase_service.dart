import 'package:firebase_database/firebase_database.dart';
import 'package:bp_monitor_app/models/bp_reading.dart';

class FirebaseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  // Save BP reading to Firebase
  Future<void> saveReading(BPReading reading) async {
    final userRef = _db.child('users/default_user/bp_readings').push();
    await userRef.set(reading.toMap());
  }

  // Fetch all BP readings
  Future<List<BPReading>> fetchReadings() async {
    final snapshot = await _db.child('users/default_user/bp_readings').get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      final readings = data.entries.map((entry) {
        final readingMap = Map<String, dynamic>.from(entry.value);
        return BPReading.fromMap({...readingMap, 'id': entry.key});
      }).toList();

      // Sort recent first
      readings.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      return readings;
    } else {
      return [];
    }
  }

  // Delete reading by ID
  Future<void> deleteReading(String id) async {
    await _db.child('users/default_user/bp_readings/$id').remove();
  }
}
