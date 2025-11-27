import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/h59_repository.dart';

class DisconnectDevice {
  final H59Repository repository;

  DisconnectDevice(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.disconnectDevice();
  }
}
