import '../../domain/entities/health_metrics.dart';

class HealthMetricsModel extends HealthMetrics {
  const HealthMetricsModel({
    super.heartRate,
    super.bloodOxygen,
    super.steps,
    super.calories,
    super.distance,
    super.systolic,
    super.diastolic,
    super.temperature,
    super.hrv,
    super.stress,
    required super.lastUpdate,
  });

  factory HealthMetricsModel.fromMap(Map<String, dynamic> map) {
    return HealthMetricsModel(
      heartRate: map['heartRate'] as int?,
      bloodOxygen: map['bloodOxygen'] as int?,
      steps: map['steps'] as int?,
      calories: map['calories'] as int?,
      distance: map['distance'] as int?,
      systolic: map['systolic'] as int?,
      diastolic: map['diastolic'] as int?,
      temperature: map['temperature'] as double?,
      hrv: map['hrv'] as int?,
      stress: map['stress'] as int?,
      lastUpdate: DateTime.now(),
    );
  }

  factory HealthMetricsModel.empty() {
    return HealthMetricsModel(lastUpdate: DateTime.now());
  }

  HealthMetricsModel copyWith({
    int? heartRate,
    int? bloodOxygen,
    int? steps,
    int? calories,
    int? distance,
    int? systolic,
    int? diastolic,
    double? temperature,
    int? hrv,
    int? stress,
  }) {
    return HealthMetricsModel(
      heartRate: heartRate ?? this.heartRate,
      bloodOxygen: bloodOxygen ?? this.bloodOxygen,
      steps: steps ?? this.steps,
      calories: calories ?? this.calories,
      distance: distance ?? this.distance,
      systolic: systolic ?? this.systolic,
      diastolic: diastolic ?? this.diastolic,
      temperature: temperature ?? this.temperature,
      hrv: hrv ?? this.hrv,
      stress: stress ?? this.stress,
      lastUpdate: DateTime.now(),
    );
  }
}
