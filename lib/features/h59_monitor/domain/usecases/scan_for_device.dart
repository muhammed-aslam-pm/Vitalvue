import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/h59_repository.dart';

class ScanForDevice {
  final H59Repository repository;

  ScanForDevice(this.repository);

  Future<Either<Failure, bool>> call() async {
    return await repository.scanForDevice();
  }
}
