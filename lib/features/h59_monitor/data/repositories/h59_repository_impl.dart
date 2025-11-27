import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/health_metrics.dart';
import '../../domain/repositories/h59_repository.dart';
import '../datasources/bluetooth_datasource.dart';

class H59RepositoryImpl implements H59Repository {
  final BluetoothDataSource dataSource;

  H59RepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, bool>> scanForDevice() async {
    try {
      final device = await dataSource.scanForH59Device();
      if (device == null) {
        return Left(DeviceNotFoundFailure('H59 device not found'));
      }
      return const Right(true);
    } catch (e) {
      return Left(BluetoothFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, String>>> connectToDevice() async {
    try {
      final device = await dataSource.scanForH59Device();
      if (device == null) {
        return Left(DeviceNotFoundFailure('H59 device not found'));
      }
      final info = await dataSource.connect(device);
      return Right(info);
    } catch (e) {
      return Left(ConnectionFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disconnectDevice() async {
    try {
      await dataSource.disconnect();
      return const Right(null);
    } catch (e) {
      return Left(BluetoothFailure(e.toString()));
    }
  }

  @override
  Stream<HealthMetrics> get healthMetricsStream => dataSource.metricsStream;

  @override
  bool get isConnected => dataSource.isConnected;
}
