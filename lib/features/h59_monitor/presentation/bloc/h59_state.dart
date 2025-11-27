import 'package:equatable/equatable.dart';
import '../../domain/entities/health_metrics.dart';

abstract class H59State extends Equatable {
  const H59State();

  @override
  List<Object?> get props => [];
}

class H59InitialState extends H59State {}

class H59ScanningState extends H59State {}

class H59DeviceFoundState extends H59State {}

class H59ConnectingState extends H59State {}

class H59ConnectedState extends H59State {
  final Map<String, String> deviceInfo;
  final HealthMetrics? metrics;

  const H59ConnectedState({required this.deviceInfo, this.metrics});

  H59ConnectedState copyWith({
    Map<String, String>? deviceInfo,
    HealthMetrics? metrics,
  }) {
    return H59ConnectedState(
      deviceInfo: deviceInfo ?? this.deviceInfo,
      metrics: metrics ?? this.metrics,
    );
  }

  @override
  List<Object?> get props => [deviceInfo, metrics];
}

class H59DisconnectedState extends H59State {}

class H59ErrorState extends H59State {
  final String message;

  const H59ErrorState(this.message);

  @override
  List<Object> get props => [message];
}
