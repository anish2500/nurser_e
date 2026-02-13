import 'dart:async';
import 'package:flutter/material.dart';
import 'package:light_sensor/light_sensor.dart';

class LightSensorScreen extends StatefulWidget {
  const LightSensorScreen({super.key});

  @override
  State<LightSensorScreen> createState() => _LightSensorScreenState();
}

class _LightSensorScreenState extends State<LightSensorScreen> {
  // lux is the unit of illuminance
  int _lux = 0;
  StreamSubscription<int>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = LightSensor.luxStream().listen((int lux) {
      setState(() {
        _lux = lux;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
        title: const Text('Light Sensor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Light Sensor',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Text('$_lux lux', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}