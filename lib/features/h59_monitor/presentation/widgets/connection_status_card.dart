import 'package:flutter/material.dart';

class ConnectionStatusCard extends StatelessWidget {
  final String deviceName;
  final String firmwareVersion;
  final DateTime lastUpdate;

  const ConnectionStatusCard({
    Key? key,
    required this.deviceName,
    required this.firmwareVersion,
    required this.lastUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.watch, size: 48, color: Colors.blue),
            const SizedBox(height: 12),
            Text(deviceName, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            const Text(
              'Connected',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Firmware: $firmwareVersion',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Last update: ${lastUpdate.hour}:${lastUpdate.minute.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
