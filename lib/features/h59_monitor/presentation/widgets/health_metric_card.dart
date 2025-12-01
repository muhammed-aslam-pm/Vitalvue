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
  final String? customIconPath; // For custom asset images

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
    this.customIconPath,
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              date,
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
            const Spacer(),
            if (showPlus) _buildPlusIcon() else _buildValueSection(),
            const SizedBox(height: 8),
            _buildIllustration(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlusIcon() {
    return Center(
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.add, size: 32, color: color),
      ),
    );
  }

  Widget _buildValueSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value,
          style: const TextStyle(
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
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildIllustration() {
    // Custom illustrations based on type
    if (customIconPath != null) {
      return Align(
        alignment: Alignment.bottomRight,
        child: Image.asset(
          customIconPath!,
          width: 60,
          height: 60,
          color: Colors.white.withOpacity(0.2),
        ),
      );
    }

    // Fallback to custom-drawn icons
    return Align(alignment: Alignment.bottomRight, child: _getCustomIcon());
  }

  Widget _getCustomIcon() {
    switch (title) {
      case 'Heart Rate':
        return _buildHeartIcon();
      case 'Sleep':
        return _buildMoonIcon();
      case 'Exercise record':
        return _buildRunningIcon();
      case 'Blood Pressure':
        return _buildBPIcon();
      case 'Body Temperature':
        return _buildThermometerIcon();
      case 'Blood Oxygen':
        return _buildOxygenIcon();
      case 'HRV':
        return _buildHRVIcon();
      case 'Stress':
        return _buildStressIcon();
      default:
        return Icon(icon, size: 60, color: Colors.white.withOpacity(0.15));
    }
  }

  Widget _buildHeartIcon() {
    return CustomPaint(
      size: const Size(60, 60),
      painter: HeartPainter(color: Colors.white.withOpacity(0.15)),
    );
  }

  Widget _buildMoonIcon() {
    return Icon(
      Icons.nightlight_round,
      size: 60,
      color: Colors.white.withOpacity(0.15),
    );
  }

  Widget _buildRunningIcon() {
    return Stack(
      children: [
        Icon(
          Icons.directions_run,
          size: 60,
          color: Colors.white.withOpacity(0.15),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Icon(
            Icons.local_fire_department,
            size: 24,
            color: Colors.orange.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildBPIcon() {
    return Icon(
      Icons.favorite,
      size: 60,
      color: Colors.white.withOpacity(0.15),
    );
  }

  Widget _buildThermometerIcon() {
    return CustomPaint(
      size: const Size(60, 60),
      painter: ThermometerPainter(color: Colors.white.withOpacity(0.15)),
    );
  }

  Widget _buildOxygenIcon() {
    return CustomPaint(
      size: const Size(60, 60),
      painter: OxygenPainter(color: Colors.white.withOpacity(0.15)),
    );
  }

  Widget _buildHRVIcon() {
    return CustomPaint(
      size: const Size(60, 60),
      painter: HRVWavePainter(color: Colors.white.withOpacity(0.15)),
    );
  }

  Widget _buildStressIcon() {
    return Stack(
      children: [
        Icon(Icons.psychology, size: 60, color: Colors.white.withOpacity(0.15)),
        Positioned(
          right: 5,
          top: 5,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

// Custom Painters for Icons
class HeartPainter extends CustomPainter {
  final Color color;
  HeartPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, size.height * 0.35);

    // Left curve
    path.cubicTo(
      size.width * 0.2,
      size.height * 0.1,
      size.width * 0.1,
      size.height * 0.3,
      size.width / 2,
      size.height * 0.75,
    );

    // Right curve
    path.moveTo(size.width / 2, size.height * 0.35);
    path.cubicTo(
      size.width * 0.8,
      size.height * 0.1,
      size.width * 0.9,
      size.height * 0.3,
      size.width / 2,
      size.height * 0.75,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ThermometerPainter extends CustomPainter {
  final Color color;
  ThermometerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Bulb
    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.8),
      size.width * 0.15,
      paint,
    );

    // Tube
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height * 0.4),
          width: size.width * 0.2,
          height: size.height * 0.5,
        ),
        const Radius.circular(10),
      ),
      paint,
    );

    // Mercury
    paint.style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.45,
        size.height * 0.3,
        size.width * 0.1,
        size.height * 0.45,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OxygenPainter extends CustomPainter {
  final Color color;
  OxygenPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw water drop
    final path = Path();
    path.moveTo(size.width / 2, size.height * 0.2);
    path.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.5,
      size.width / 2,
      size.height * 0.9,
    );
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.5,
      size.width / 2,
      size.height * 0.2,
    );

    canvas.drawPath(path, paint);

    // O2 text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'O₂',
        style: TextStyle(
          color: color,
          fontSize: size.width * 0.2,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size.width / 2 - textPainter.width / 2,
        size.height / 2 - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HRVWavePainter extends CustomPainter {
  final Color color;
  HRVWavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final path = Path();
    path.moveTo(0, size.height / 2);

    // ECG-like wave
    path.lineTo(size.width * 0.2, size.height / 2);
    path.lineTo(size.width * 0.25, size.height * 0.2);
    path.lineTo(size.width * 0.3, size.height * 0.7);
    path.lineTo(size.width * 0.35, size.height / 2);
    path.lineTo(size.width * 0.6, size.height / 2);
    path.lineTo(size.width * 0.65, size.height * 0.3);
    path.lineTo(size.width * 0.7, size.height * 0.6);
    path.lineTo(size.width * 0.75, size.height / 2);
    path.lineTo(size.width, size.height / 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
