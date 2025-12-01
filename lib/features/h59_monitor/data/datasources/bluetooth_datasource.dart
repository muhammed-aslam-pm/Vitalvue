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
        print('📱 Found device: ${result.device.platformName}');
        if (result.device.platformName.toUpperCase().contains(
          BluetoothConstants.deviceNamePrefix,
        )) {
          h59Device = result.device;
          print('✅ H59 Device found: ${result.device.platformName}');
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
    print('🔗 Connecting to ${device.platformName}...');
    await device.connect(
      timeout: BluetoothConstants.connectionTimeout,
      license: License.free,
    );
    _connectedDevice = device;

    // Discover services
    final services = await device.discoverServices();
    final deviceInfo = <String, String>{};

    print('🔍 Discovered ${services.length} services');

    for (var service in services) {
      print('📦 Service: ${service.uuid}');

      for (var characteristic in service.characteristics) {
        final uuid = characteristic.uuid.toString().toLowerCase();
        print('  📋 Characteristic: $uuid');
        print(
          '     Properties: R:${characteristic.properties.read} '
          'W:${characteristic.properties.write} '
          'N:${characteristic.properties.notify}',
        );

        // Read device information
        if (characteristic.properties.read) {
          try {
            final value = await characteristic.read();
            print('     ✅ Read value: $value');

            if (uuid.contains(BluetoothConstants.deviceNameUuid)) {
              deviceInfo['name'] = HealthDataParser.parseDeviceName(value);
              print('     📛 Device Name: ${deviceInfo['name']}');
            } else if (uuid.contains(BluetoothConstants.hardwareVersionUuid)) {
              deviceInfo['hardwareVersion'] = HealthDataParser.parseVersion(
                value,
              );
              print('     🔧 Hardware: ${deviceInfo['hardwareVersion']}');
            } else if (uuid.contains(BluetoothConstants.firmwareVersionUuid)) {
              deviceInfo['firmwareVersion'] = HealthDataParser.parseVersion(
                value,
              );
              print('     💾 Firmware: ${deviceInfo['firmwareVersion']}');
            }
          } catch (e) {
            print('     ❌ Read error: $e');
          }
        }

        // Subscribe to health data notifications
        if (characteristic.properties.notify &&
            uuid.contains(BluetoothConstants.healthDataUuid)) {
          print('     🔔 Subscribing to notifications...');
          await characteristic.setNotifyValue(true);

          final sub = characteristic.lastValueStream.listen((value) {
            print('📊 Health data received: $value');
            final parsedData = HealthDataParser.parseHealthData(value);
            print('   Parsed: $parsedData');

            if (parsedData.isNotEmpty) {
              _metricsController.add(HealthMetricsModel.fromMap(parsedData));
            }
          });
          _subscriptions.add(sub);
          print('     ✅ Subscribed successfully!');
        }
      }
    }

    print('✅ Connection complete!');
    return deviceInfo;
  }

  @override
  Future<void> disconnect() async {
    print('❌ Disconnecting...');
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
