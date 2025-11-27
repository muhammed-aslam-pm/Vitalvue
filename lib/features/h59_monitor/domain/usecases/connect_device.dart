import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/h59_repository.dart';

class ConnectDevice {
  final H59Repository repository;

  ConnectDevice(this.repository);

  Future<Either<Failure, Map<String, String>>> call() async {
    return await repository.connectToDevice();
  }
}
