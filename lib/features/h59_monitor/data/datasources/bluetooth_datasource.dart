import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../../core/constants/bluetooth_constants.dart';
import '../../../../core/utils/health_data_parser.dart';
import '../models/health_metrics_model.dart';

abstract class BluetoothDataSource {
  Future<BluetoothDevice?> scanForH59Device();
  Future<Map<String, String>> connect(BluetoothDevice device);
  Future<void> disconnect();
  Stream<HealthMetricsModel> get metricsStream;
  bool get isConnected;
}

class BluetoothDataSourceImpl implements BluetoothDataSource {
  BluetoothDevice? _connectedDevice;
  final StreamController<HealthMetricsModel> _metricsController =
      StreamController<HealthMetricsModel>.broadcast();
  final List<StreamSubscription> _subscriptions = [];

  @override
  bool get isConnected => _connectedDevice != null;

  @override
  Stream<HealthMetricsModel> get metricsStream => _metricsController.stream;

  @override
  Future<BluetoothDevice?> scanForH59Device() async {
    if (await FlutterBluePlus.adapterState.first != BluetoothAdapterState.on) {
      throw Exception('Bluetooth is not enabled');
    }

    BluetoothDevice? h59Device;
    final completer = Completer<BluetoothDevice?>();

    await FlutterBluePlus.startScan(
      timeout: BluetoothConstants.scanTimeout,
      androidUsesFineLocation: true,
    );

    final subscription = FlutterBluePlus.scanResults.listen((results) {
      for (var result in results) {
        if (result.device.platformName.toUpperCase().contains(
          BluetoothConstants.deviceNamePrefix,
        )) {
          h59Device = result.device;
          FlutterBluePlus.stopScan();
          if (!completer.isCompleted) {
            completer.complete(h59Device);
          }
          break;
        }
      }
    });

    await Future.delayed(BluetoothConstants.scanTimeout);
    await FlutterBluePlus.stopScan();
    subscription.cancel();

    if (!completer.isCompleted) {
      completer.complete(h59Device);
    }

    return completer.future;
  }

  @override
  Future<Map<String, String>> connect(BluetoothDevice device) async {
    await device.connect(
      timeout: BluetoothConstants.connectionTimeout,
      license: License.free,
    );
    _connectedDevice = device;

    // Discover services
    final services = await device.discoverServices();
    final deviceInfo = <String, String>{};

    for (var service in services) {
      for (var characteristic in service.characteristics) {
        final uuid = characteristic.uuid.toString().toLowerCase();

        // Read device information
        if (characteristic.properties.read) {
          try {
            final value = await characteristic.read();

            if (uuid.contains(BluetoothConstants.deviceNameUuid)) {
              deviceInfo['name'] = HealthDataParser.parseDeviceName(value);
            } else if (uuid.contains(BluetoothConstants.hardwareVersionUuid)) {
              deviceInfo['hardwareVersion'] = HealthDataParser.parseVersion(
                value,
              );
            } else if (uuid.contains(BluetoothConstants.firmwareVersionUuid)) {
              deviceInfo['firmwareVersion'] = HealthDataParser.parseVersion(
                value,
              );
            }
          } catch (e) {
            // Ignore read errors
          }
        }

        // Subscribe to health data notifications
        if (characteristic.properties.notify &&
            uuid.contains(BluetoothConstants.healthDataUuid)) {
          await characteristic.setNotifyValue(true);
          final sub = characteristic.lastValueStream.listen((value) {
            final parsedData = HealthDataParser.parseHealthData(value);
            if (parsedData.isNotEmpty) {
              _metricsController.add(HealthMetricsModel.fromMap(parsedData));
            }
          });
          _subscriptions.add(sub);
        }
      }
    }

    return deviceInfo;
  }

  @override
  Future<void> disconnect() async {
    for (var sub in _subscriptions) {
      await sub.cancel();
    }
    _subscriptions.clear();

    if (_connectedDevice != null) {
      await _connectedDevice!.disconnect();
      _connectedDevice = null;
    }
  }

  void dispose() {
    _metricsController.close();
    disconnect();
  }
}
