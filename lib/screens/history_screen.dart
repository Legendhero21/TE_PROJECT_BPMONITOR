import 'package:flutter/material.dart';
import 'package:bp_monitor_app/models/bp_reading.dart';
import 'package:bp_monitor_app/services/firebase_service.dart';
import 'package:bp_monitor_app/screens/analysis_screen.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<BPReading> _readings = [];
  Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    _loadReadings();
  }

  Future<void> _loadReadings() async {
    final data = await _firebaseService.fetchReadings();
    setState(() => _readings = data);
  }

  void _toggleSelection(String id) {
    setState(() {
      _selectedIds.contains(id)
          ? _selectedIds.remove(id)
          : _selectedIds.add(id);
    });
  }

  Future<void> _deleteSelected() async {
    for (String id in _selectedIds) {
      await _firebaseService.deleteReading(id);
    }
    _selectedIds.clear();
    await _loadReadings();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd MMM yyyy, hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: const Text("BP History"),
        actions: [
          if (_selectedIds.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete',
              onPressed: _deleteSelected,
            ),
        ],
      ),
      body: _readings.isEmpty
          ? const Center(child: Text('No BP readings available'))
          : ListView.builder(
              itemCount: _readings.length,
              itemBuilder: (context, index) {
                final reading = _readings[index];
                final isSelected = _selectedIds.contains(reading.id);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  child: ListTile(
                    onLongPress: () => _toggleSelection(reading.id),
                    leading: isSelected
                        ? const Icon(Icons.check_circle, color: Colors.red)
                        : const Icon(Icons.favorite_border, color: Colors.blue),
                    title: Text(
                      'Sys: ${reading.systolic}   Dia: ${reading.diastolic}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(formatter.format(reading.timestamp)),
                    trailing: isSelected
                        ? const Icon(Icons.delete, color: Colors.red)
                        : null,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AnalysisScreen()),
          );
        },
        icon: const Icon(Icons.analytics),
        label: const Text("Analyze"),
      ),
    );
  }
}
