class BluetoothConstants {
  static const String deviceNamePrefix = 'H59';

  // UUIDs from your logs
  static const String deviceNameUuid = '2a00';
  static const String hardwareVersionUuid = '2a27';
  static const String firmwareVersionUuid = '2a26';
  static const String systemIdUuid = '2a23';
  static const String healthDataUuid = '6e400003-b5a3-f393-e0a9-e50e24dcca9e';
  static const String customDataUuid1 = 'fea1';
  static const String customDataUuid2 = 'fea2';

  static const Duration scanTimeout = Duration(seconds: 15);
  static const Duration connectionTimeout = Duration(seconds: 15);
}
