import 'package:dartz/dartz.dart';
import '../entities/health_metrics.dart';
import '../../../../core/errors/failures.dart';

abstract class H59Repository {
  Future<Either<Failure, bool>> scanForDevice();
  Future<Either<Failure, Map<String, String>>> connectToDevice();
  Future<Either<Failure, void>> disconnectDevice();
  Stream<HealthMetrics> get healthMetricsStream;
  bool get isConnected;
}
