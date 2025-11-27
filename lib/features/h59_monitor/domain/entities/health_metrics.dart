import 'package:equatable/equatable.dart';

class HealthMetrics extends Equatable {
  final int? heartRate;
  final int? bloodOxygen;
  final int? steps;
  final int? calories; // kcal
  final int? distance; // meters
  final int? systolic; // blood pressure
  final int? diastolic; // blood pressure
  final double? temperature; // celsius
  final int? hrv; // ms
  final int? stress; // 0-100
  final DateTime lastUpdate;

  const HealthMetrics({
    this.heartRate,
    this.bloodOxygen,
    this.steps,
    this.calories,
    this.distance,
    this.systolic,
    this.diastolic,
    this.temperature,
    this.hrv,
    this.stress,
    required this.lastUpdate,
  });

  @override
  List<Object?> get props => [
    heartRate,
    bloodOxygen,
    steps,
    calories,
    distance,
    systolic,
    diastolic,
    temperature,
    hrv,
    stress,
    lastUpdate,
  ];
}
