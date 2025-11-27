import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/h59_monitor/data/datasources/bluetooth_datasource.dart';
import 'features/h59_monitor/data/repositories/h59_repository_impl.dart';
import 'features/h59_monitor/domain/usecases/connect_device.dart';
import 'features/h59_monitor/domain/usecases/disconnect_device.dart';
import 'features/h59_monitor/domain/usecases/scan_for_device.dart';
import 'features/h59_monitor/presentation/bloc/h59_bloc.dart';
import 'features/h59_monitor/presentation/pages/connection_page.dart';
import 'features/h59_monitor/presentation/pages/health_dashboard_page.dart';

void main() {
  runApp(const H59App());
}

class H59App extends StatelessWidget {
  const H59App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dataSource = BluetoothDataSourceImpl();
    final repository = H59RepositoryImpl(dataSource);

    return BlocProvider(
      create: (context) => H59Bloc(
        scanForDevice: ScanForDevice(repository),
        connectDevice: ConnectDevice(repository),
        disconnectDevice: DisconnectDevice(repository),
        repository: repository,
      ),
      child: MaterialApp(
        title: 'H59 Health Monitor',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFF0A0E21),
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const ConnectionPage(),
          '/dashboard': (context) => const HealthDashboardPage(),
        },
      ),
    );
  }
}
