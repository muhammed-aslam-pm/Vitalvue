abstract class Failure {
  final String message;
  const Failure(this.message);
}

class BluetoothFailure extends Failure {
  const BluetoothFailure(super.message);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

class DeviceNotFoundFailure extends Failure {
  const DeviceNotFoundFailure(super.message);
}
