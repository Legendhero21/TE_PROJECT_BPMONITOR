import 'package:flutter/material.dart';
import '../services/ble_service.dart';

class BPHomeContent extends StatefulWidget {
  const BPHomeContent({super.key});

  @override
  _BPHomeContentState createState() => _BPHomeContentState();
}

class _BPHomeContentState extends State<BPHomeContent> {
  BLEService bleService = BLEService();
  String statusText = "Searching for BP Monitor...";
  bool isConnected = false;
  bool hasReadings = false;

  double systolic = 0;
  double diastolic = 0;

  @override
  void initState() {
    super.initState();
    bleService.startScan((device) async {
      await bleService.connectToDevice(device);
      setState(() {
        statusText = "Connected to BP Monitor!";
        isConnected = true;
      });

      // Simulate reading after 5s for now
      Future.delayed(Duration(seconds: 5), () {
        setState(() {
          systolic = 120;
          diastolic = 80;
          hasReadings = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BP Monitor'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Latest Blood Pressure Reading",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),

            Text(
              statusText,
              style: TextStyle(
                fontSize: 18,
                color: isConnected ? Colors.green : Colors.red,
              ),
            ),
            SizedBox(height: 30),

            if (hasReadings)
              Column(
                children: [
                  _buildReadingCard(
                    title: "Systolic",
                    value: systolic,
                    color: Colors.lightBlue.shade100,
                    valueColor: Colors.blue,
                  ),
                  SizedBox(height: 20),
                  _buildReadingCard(
                    title: "Diastolic",
                    value: diastolic,
                    color: Colors.red.shade100,
                    valueColor: Colors.red,
                  ),
                ],
              )
            else if (isConnected)
              Column(
                children: [
                  Icon(Icons.bluetooth_connected, size: 80, color: Colors.blue),
                  SizedBox(height: 20),
                  Text(
                    "Waiting for readings...",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              )
            else
              Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    "Searching for BP Monitor...",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingCard({
    required String title,
    required double value,
    required Color color,
    required Color valueColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: color,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              value.toStringAsFixed(0),
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "mmHg",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
