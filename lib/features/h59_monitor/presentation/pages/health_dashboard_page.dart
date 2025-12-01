import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/h59_bloc.dart';
import '../bloc/h59_event.dart';
import '../bloc/h59_state.dart';
import '../widgets/health_metric_card.dart';

class HealthDashboardPage extends StatelessWidget {
  const HealthDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E21),
        elevation: 0,
        title: const Text(
          'Data',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              // Refresh data
              print('🔄 Refresh requested');
            },
          ),
          IconButton(
            icon: const Icon(Icons.bluetooth_disabled, color: Colors.white),
            onPressed: () {
              print('❌ Disconnect requested');
              context.read<H59Bloc>().add(DisconnectFromH59Event());
              Navigator.of(context).pushReplacementNamed('/');
            },
            tooltip: 'Disconnect',
          ),
        ],
      ),
      body: BlocBuilder<H59Bloc, H59State>(
        builder: (context, state) {
          print('🎨 Dashboard state: $state');

          if (state is H59ConnectedState) {
            final metrics = state.metrics;
            final deviceInfo = state.deviceInfo;

            print(
              '📊 Current metrics: ${metrics?.heartRate} bpm, ${metrics?.bloodOxygen}% SpO2',
            );

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Device Info Banner
                  _buildDeviceInfoBanner(deviceInfo),
                  const SizedBox(height: 16),

                  // Steps Chart Area
                  _buildStepsChart(metrics?.steps ?? 0),
                  const SizedBox(height: 24),

                  // Grid of Health Metrics
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.85,
                    children: [
                      HealthMetricCard(
                        title: 'Heart Rate',
                        date: _formatDate(metrics?.lastUpdate),
                        value: '${metrics?.heartRate ?? '--'}',
                        unit: 'bpm',
                        icon: Icons.favorite,
                        color: const Color(0xFFFF6B9D),
                        gradientColors: const [
                          Color(0xFF8B2635),
                          Color(0xFF4A1319),
                        ],
                      ),
                      HealthMetricCard(
                        title: 'Sleep',
                        date: _formatDate(DateTime.now()),
                        value: '-- --',
                        unit: 'min',
                        icon: Icons.nightlight_round,
                        color: const Color(0xFF9D6CFF),
                        gradientColors: const [
                          Color(0xFF4A2B7C),
                          Color(0xFF2A1A4D),
                        ],
                      ),
                      HealthMetricCard(
                        title: 'Exercise record',
                        date: _formatDate(DateTime.now()),
                        value: '${metrics?.calories ?? '--'}',
                        unit: 'kcal',
                        icon: Icons.directions_run,
                        color: const Color(0xFFFF9B54),
                        gradientColors: const [
                          Color(0xFF8B4A1F),
                          Color(0xFF4D2A11),
                        ],
                      ),
                      HealthMetricCard(
                        title: 'Blood Pressure',
                        date: _formatDate(DateTime.now()),
                        value:
                            metrics?.systolic != null &&
                                metrics?.diastolic != null
                            ? '${metrics!.systolic}/${metrics.diastolic}'
                            : '--',
                        unit: 'mmHg',
                        icon: Icons.monitor_heart,
                        color: const Color(0xFFB8A26F),
                        gradientColors: const [
                          Color(0xFF5C5137),
                          Color(0xFF3D3625),
                        ],
                      ),
                      HealthMetricCard(
                        title: 'Body Temperature',
                        date: _formatDate(metrics?.lastUpdate),
                        value: metrics?.temperature != null
                            ? '${metrics!.temperature!.toStringAsFixed(1)}'
                            : '36.5',
                        unit: '℃',
                        icon: Icons.thermostat,
                        color: const Color(0xFF6BAFFF),
                        gradientColors: const [
                          Color(0xFF2B577C),
                          Color(0xFF1A364D),
                        ],
                      ),
                      HealthMetricCard(
                        title: 'Blood Oxygen',
                        date: _formatDate(metrics?.lastUpdate),
                        value: '${metrics?.bloodOxygen ?? '--'}',
                        unit: '%',
                        icon: Icons.water_drop,
                        color: const Color(0xFF6BB8E8),
                        gradientColors: const [
                          Color(0xFF2B5C74),
                          Color(0xFF1A3845),
                        ],
                      ),
                      HealthMetricCard(
                        title: 'One key measurement',
                        date: _formatDate(DateTime.now()),
                        value: '',
                        unit: '',
                        icon: Icons.add_circle_outline,
                        color: const Color(0xFF4DD8A7),
                        gradientColors: const [
                          Color(0xFF266C53),
                          Color(0xFF17442F),
                        ],
                        showPlus: true,
                      ),
                      HealthMetricCard(
                        title: 'HRV',
                        date: _formatDate(DateTime.now()),
                        value: '${metrics?.hrv ?? '--'}',
                        unit: 'ms',
                        icon: Icons.favorite_border,
                        color: const Color(0xFFFF6B9D),
                        gradientColors: const [
                          Color(0xFF8B2635),
                          Color(0xFF4A1319),
                        ],
                      ),
                      HealthMetricCard(
                        title: 'Stress',
                        date: _formatDate(metrics?.lastUpdate),
                        value: '${metrics?.stress ?? '--'}',
                        unit: 'Normal',
                        icon: Icons.psychology,
                        color: const Color(0xFF6BDDFF),
                        gradientColors: const [
                          Color(0xFF2B6E7C),
                          Color(0xFF1A434D),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        },
      ),
    );
  }

  Widget _buildDeviceInfoBanner(Map<String, String> deviceInfo) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.watch, color: Color(0xFF6BB8E8), size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceInfo['name'] ?? 'H59 Device',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'FW: ${deviceInfo['firmwareVersion'] ?? 'Unknown'}',
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.circle, color: Colors.green, size: 8),
                SizedBox(width: 4),
                Text(
                  'Connected',
                  style: TextStyle(color: Colors.green, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepsChart(int steps) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0E21),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.directions_walk,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$steps',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'steps',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Real-time step data',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '2025-11-27';
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
