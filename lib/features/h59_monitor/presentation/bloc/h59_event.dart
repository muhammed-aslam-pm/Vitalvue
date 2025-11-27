import 'package:equatable/equatable.dart';

abstract class H59Event extends Equatable {
  const H59Event();

  @override
  List<Object> get props => [];
}

class ScanForH59Event extends H59Event {}

class ConnectToH59Event extends H59Event {}

class DisconnectFromH59Event extends H59Event {}

class HealthMetricsUpdatedEvent extends H59Event {
  final Map<String, dynamic> metrics;

  const HealthMetricsUpdatedEvent(this.metrics);

  @override
  List<Object> get props => [metrics];
}
