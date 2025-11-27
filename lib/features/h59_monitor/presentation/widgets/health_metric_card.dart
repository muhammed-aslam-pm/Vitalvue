import 'package:flutter/material.dart';

class HealthMetricCard extends StatelessWidget {
  final String title;
  final String date;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final List<Color> gradientColors;
  final bool showPlus;

  const HealthMetricCard({
    Key? key,
    required this.title,
    required this.date,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
    required this.gradientColors,
    this.showPlus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            Text(
              date,
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
            const Spacer(),
            if (showPlus)
              Center(
                child: Icon(Icons.add_circle_outline, size: 48, color: color),
              )
            else
              _buildValueSection(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildValueSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                unit,
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
