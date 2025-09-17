import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BluetoothDevice? _device;
  String _voltage = "Not connected";

  void _scanAndConnect() async {
    FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

    // Start scanning
    flutterBlue.startScan(timeout: const Duration(seconds: 5));

    // Listen for results
    flutterBlue.scanResults.listen((results) async {
      for (ScanResult r in results) {
        if (r.device.name.contains("ESP32")) {
          await flutterBlue.stopScan();
          await r.device.connect();
          setState(() {
            _device = r.device;
          });
          // TODO: discover voltage characteristic here
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ESP32 Voltage Reader")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Voltage: $_voltage", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scanAndConnect,
              child: const Text("Scan & Connect"),
            ),
          ],
        ),
      ),
    );
  }
}
