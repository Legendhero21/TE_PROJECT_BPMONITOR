import 'package:flutter/material.dart';
import 'package:bp_monitor_app/services/firebase_service.dart';
import 'package:bp_monitor_app/models/bp_reading.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<BPReading> _readings = [];

  @override
  void initState() {
    super.initState();
    _loadReadings();
  }

  Future<void> _loadReadings() async {
    final data = await _firebaseService.fetchReadings();
    setState(() => _readings = data);
  }

  @override
  Widget build(BuildContext context) {
    final recent = _readings.take(5).toList().reversed.toList();
    final formatter = DateFormat('dd/MM');

    final systolicSpots = recent.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.systolic.toDouble());
    }).toList();

    final diastolicSpots = recent.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.diastolic.toDouble());
    }).toList();

    final xLabels = recent.map((r) => formatter.format(r.timestamp)).toList();

    final avgSys = recent.isNotEmpty
        ? recent.map((r) => r.systolic).reduce((a, b) => a + b) / recent.length
        : 0;
    final avgDia = recent.isNotEmpty
        ? recent.map((r) => r.diastolic).reduce((a, b) => a + b) / recent.length
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("BP Analysis"),
      ),
      body: _readings.isEmpty
          ? const Center(child: Text("No data for analysis."))
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Recent BP Trends", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 260,
                    child: LineChart(
                      LineChartData(
                        minY: 60,
                        maxY: 160,
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true, reservedSize: 40, interval: 20),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index < xLabels.length) {
                                  return Text(xLabels[index], style: const TextStyle(fontSize: 10));
                                }
                                return const Text('');
                              },
                              reservedSize: 32,
                              interval: 1,
                            ),
                          ),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(show: true),
                        borderData: FlBorderData(show: true),
                        lineBarsData: [
                          LineChartBarData(
                            spots: systolicSpots,
                            isCurved: true,
                            color: Colors.red,
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                          ),
                          LineChartBarData(
                            spots: diastolicSpots,
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.circle, color: Colors.red, size: 10),
                      const SizedBox(width: 4),
                      const Text("Systolic"),
                      const SizedBox(width: 20),
                      const Icon(Icons.circle, color: Colors.blue, size: 10),
                      const SizedBox(width: 4),
                      const Text("Diastolic"),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text("Avg Systolic: ${avgSys.toStringAsFixed(1)} mmHg", style: const TextStyle(fontSize: 16)),
                  Text("Avg Diastolic: ${avgDia.toStringAsFixed(1)} mmHg", style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  _getInterpretation(avgSys.toDouble(), avgDia.toDouble()),
                ],
              ),
            ),
    );
  }

  Widget _getInterpretation(double sys, double dia) {
    String status = "";
    Color color = Colors.green;

    if (sys >= 140 || dia >= 90) {
      status = "High BP Detected. Consult Doctor.";
      color = Colors.red;
    } else if (sys <= 90 || dia <= 60) {
      status = "Low BP Detected. Take Care.";
      color = Colors.orange;
    } else {
      status = "BP is within normal range.";
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(Icons.health_and_safety, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(status, style: TextStyle(color: color, fontSize: 16)))
        ],
      ),
    );
  }
}
