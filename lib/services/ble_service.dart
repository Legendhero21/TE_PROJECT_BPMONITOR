import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLEService {
  BluetoothDevice? connectedDevice;

  // Start scanning for devices
  void startScan(Function(BluetoothDevice) onDeviceFound) async {
    // Start scanning properly
    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 4),
      withServices: [],
    );

    // Listen to scan results
    FlutterBluePlus.scanResults.listen((List<ScanResult> results) async {
      for (ScanResult r in results) {
        print('Device found: ${r.device.name}');
        if (r.device.name == "BP Monitor") {
          await FlutterBluePlus.stopScan(); // stop scan BEFORE connecting
          onDeviceFound(r.device);
          break;
        }
      }
    });
  }

  // Connect to device
  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();
    connectedDevice = device;
  }

  // Disconnect
  Future<void> disconnect() async {
    if (connectedDevice != null) {
      await connectedDevice!.disconnect();
      connectedDevice = null;
    }
  }
}
