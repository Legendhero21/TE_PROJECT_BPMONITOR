import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:bp_monitor_app/models/bp_reading.dart';
import 'package:bp_monitor_app/services/firebase_service.dart';

class BLEService {
  BluetoothDevice? connectedDevice;

  // Start scanning for devices
  void startScan(Function(BluetoothDevice) onDeviceFound) async {
    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 4),
      withServices: [], // optional: use service UUID if known
    );

    FlutterBluePlus.scanResults.listen((List<ScanResult> results) async {
      for (ScanResult r in results) {
        print('Device found: ${r.device.name}');
        if (r.device.name == "BP Monitor") {
          await FlutterBluePlus.stopScan();
          onDeviceFound(r.device);
          break;
        }
      }
    });
  }

  // Connect and listen for readings
  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();
    connectedDevice = device;

    print('🔗 Connected to ${device.name}');

    // Discover services
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.notify) {
          await characteristic.setNotifyValue(true);
          print('📡 Subscribed to characteristic: ${characteristic.uuid}');

          characteristic.value.listen((value) {
            final String received = utf8.decode(value);
            print("📥 Received: $received");

            _handleIncomingData(received);
          });
        }
      }
    }
  }

  void _handleIncomingData(String data) {
    try {
      final parts = data.split(',');
      if (parts.length == 2 &&
          parts[0].contains('SYS') &&
          parts[1].contains('DIA')) {
        final sys = int.parse(parts[0].split(':')[1].trim());
        final dia = int.parse(parts[1].split(':')[1].trim());

        final reading = BPReading(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          systolic: sys,
          diastolic: dia,
          timestamp: DateTime.now(),
        );

        FirebaseService().saveReading(reading);
        print("✅ Saved BP Reading to Firebase: $sys / $dia");
      }
    } catch (e) {
      print("⚠️ Error parsing data: $data — $e");
    }
  }

  Future<void> disconnect() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      connectedDevice = null;
    }
  }
}
