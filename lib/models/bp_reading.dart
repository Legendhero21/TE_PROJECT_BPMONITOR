// lib/models/bp_reading.dart

class BPReading {
  final String id;
  final int systolic;
  final int diastolic;
  final DateTime timestamp;

  BPReading({
    required this.id,
    required this.systolic,
    required this.diastolic,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'systolic': systolic,
      'diastolic': diastolic,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory BPReading.fromMap(Map<String, dynamic> map) {
    return BPReading(
      id: map['id'],
      systolic: map['systolic'],
      diastolic: map['diastolic'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
