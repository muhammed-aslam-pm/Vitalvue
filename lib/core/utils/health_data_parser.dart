class HealthDataParser {
  // Based on SDK documentation and your logs
  // UUID: 6e400003-b5a3-f393-e0a9-e50e24dcca9e
  // Data format from logs: [115, 18, 0, 0, 86, 0, 11, 238, 0, 0, 66, 0, 0, 0, 0, 22]

  static Map<String, dynamic> parseHealthData(List<int> data) {
    if (data.isEmpty || data.length < 16) return {};

    // Based on SDK docs section 2.3.9 - Device data reporting format
    // Byte 0: Data type (115 = 0x73, which is real-time data)
    // Byte 1: Subtype (18 = 0x12 indicates step/calorie/distance data)

    if (data[0] == 0x73 && data[1] == 0x12) {
      // Format: [0x73, 0x12, step_low, step_mid, step_high, hr, cal_low, cal_mid, dist_low, dist_mid, spo2, ...]
      return {
        'steps': _bytes2Int([data[2], data[3], data[4]]), // 3-byte steps
        'heartRate': data[5], // 1-byte heart rate
        'calories': _bytes2Int([data[6], data[7]]), // 2-byte calories
        'distance': _bytes2Int([data[8], data[9]]), // 2-byte distance (meters)
        'bloodOxygen': data[10], // 1-byte SpO2
      };
    }

    return {};
  }

  // Convert byte array to int (big-endian)
  static int _bytes2Int(List<int> data) {
    int result = 0;
    for (int i = 0; i < data.length; i++) {
      result |= (data[i] & 0xFF) << (8 * (data.length - 1 - i));
    }
    return result;
  }

  static String parseDeviceName(List<int> data) {
    return String.fromCharCodes(data.where((byte) => byte != 0));
  }

  static String parseVersion(List<int> data) {
    return String.fromCharCodes(data.where((byte) => byte != 0));
  }

  // Parse blood pressure from manual measurement
  static Map<String, int> parseBloodPressure(List<int> data) {
    // From SDK: sbp (systolic), dbp (diastolic)
    if (data.length >= 2) {
      return {'systolic': data[0], 'diastolic': data[1]};
    }
    return {};
  }

  // Parse temperature (divide by 10)
  static double parseTemperature(List<int> data) {
    if (data.isNotEmpty) {
      int tempValue = _bytes2Int(data.take(2).toList());
      return tempValue / 10.0; // SDK doc: divide by 10
    }
    return 0.0;
  }

  // Parse HRV (divide by 10)
  static int parseHRV(List<int> data) {
    if (data.isNotEmpty) {
      return _bytes2Int(data.take(2).toList());
    }
    return 0;
  }

  // Parse stress (divide by 10)
  static int parseStress(List<int> data) {
    if (data.isNotEmpty) {
      return _bytes2Int(data.take(2).toList());
    }
    return 0;
  }
}
