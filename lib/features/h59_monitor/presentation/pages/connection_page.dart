import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/h59_bloc.dart';
import '../bloc/h59_event.dart';
import '../bloc/h59_state.dart';

class ConnectionPage extends StatelessWidget {
  const ConnectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E21),
        elevation: 0,
        title: const Text(
          'H59 Health Monitor',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocConsumer<H59Bloc, H59State>(
        listener: (context, state) {
          if (state is H59ErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is H59ConnectedState) {
            Navigator.of(context).pushReplacementNamed('/dashboard');
          }
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStateContent(context, state),
                  const SizedBox(height: 48),
                  _buildActionButton(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStateContent(BuildContext context, H59State state) {
    if (state is H59ScanningState) {
      return Column(
        children: [
          const CircularProgressIndicator(color: Color(0xFF6BB8E8)),
          const SizedBox(height: 24),
          Text(
            'Scanning for H59 device...',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
        ],
      );
    } else if (state is H59DeviceFoundState) {
      return Column(
        children: [
          const Icon(Icons.check_circle, size: 64, color: Colors.green),
          const SizedBox(height: 24),
          Text(
            'H59 Device Found!',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
        ],
      );
    } else if (state is H59ConnectingState) {
      return Column(
        children: [
          const CircularProgressIndicator(color: Color(0xFF6BB8E8)),
          const SizedBox(height: 24),
          Text(
            'Connecting...',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
        ],
      );
    }

    return Column(
      children: [
        const Icon(Icons.watch, size: 80, color: Color(0xFF6BB8E8)),
        const SizedBox(height: 24),
        Text(
          'H59 Health Monitor',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Make sure your H59 band is nearby and turned on',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, H59State state) {
    if (state is H59ScanningState || state is H59ConnectingState) {
      return const SizedBox.shrink();
    }

    if (state is H59DeviceFoundState) {
      return ElevatedButton.icon(
        onPressed: () {
          context.read<H59Bloc>().add(ConnectToH59Event());
        },
        icon: const Icon(Icons.bluetooth_connected),
        label: const Text('Connect to H59'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6BB8E8),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(fontSize: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: () {
        context.read<H59Bloc>().add(ScanForH59Event());
      },
      icon: const Icon(Icons.search),
      label: const Text('Scan for H59'),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6BB8E8),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: const TextStyle(fontSize: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
