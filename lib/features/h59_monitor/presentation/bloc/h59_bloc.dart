import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vitalvue/features/h59_monitor/domain/entities/health_metrics.dart';
import '../../domain/usecases/connect_device.dart';
import '../../domain/usecases/disconnect_device.dart';
import '../../domain/usecases/scan_for_device.dart';
import '../../domain/repositories/h59_repository.dart';
import 'h59_event.dart';
import 'h59_state.dart';

class H59Bloc extends Bloc<H59Event, H59State> {
  final ScanForDevice scanForDevice;
  final ConnectDevice connectDevice;
  final DisconnectDevice disconnectDevice;
  final H59Repository repository;
  StreamSubscription? _metricsSubscription;

  H59Bloc({
    required this.scanForDevice,
    required this.connectDevice,
    required this.disconnectDevice,
    required this.repository,
  }) : super(H59InitialState()) {
    on<ScanForH59Event>(_onScanForH59);
    on<ConnectToH59Event>(_onConnectToH59);
    on<DisconnectFromH59Event>(_onDisconnectFromH59);
    on<HealthMetricsUpdatedEvent>(_onHealthMetricsUpdated);
  }

  Future<void> _onScanForH59(
    ScanForH59Event event,
    Emitter<H59State> emit,
  ) async {
    emit(H59ScanningState());
    final result = await scanForDevice();
    result.fold(
      (failure) => emit(H59ErrorState(failure.message)),
      (_) => emit(H59DeviceFoundState()),
    );
  }

  Future<void> _onConnectToH59(
    ConnectToH59Event event,
    Emitter<H59State> emit,
  ) async {
    emit(H59ConnectingState());
    final result = await connectDevice();

    await result.fold((failure) async => emit(H59ErrorState(failure.message)), (
      deviceInfo,
    ) async {
      emit(H59ConnectedState(deviceInfo: deviceInfo));

      // Listen to health metrics stream
      _metricsSubscription = repository.healthMetricsStream.listen((metrics) {
        add(
          HealthMetricsUpdatedEvent({
            'heartRate': metrics.heartRate,
            'bloodOxygen': metrics.bloodOxygen,
            'steps': metrics.steps,
          }),
        );
      });
    });
  }

  Future<void> _onDisconnectFromH59(
    DisconnectFromH59Event event,
    Emitter<H59State> emit,
  ) async {
    await _metricsSubscription?.cancel();
    final result = await disconnectDevice();
    result.fold(
      (failure) => emit(H59ErrorState(failure.message)),
      (_) => emit(H59DisconnectedState()),
    );
  }

  void _onHealthMetricsUpdated(
    HealthMetricsUpdatedEvent event,
    Emitter<H59State> emit,
  ) {
    if (state is H59ConnectedState) {
      final currentState = state as H59ConnectedState;
      emit(
        currentState.copyWith(
          metrics: HealthMetrics(
            heartRate: event.metrics['heartRate'] as int?,
            bloodOxygen: event.metrics['bloodOxygen'] as int?,
            steps: event.metrics['steps'] as int?,
            lastUpdate: DateTime.now(),
          ),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _metricsSubscription?.cancel();
    return super.close();
  }
}
