import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// The app's signature illustration: a small coin-slot robot, drawn
/// with simple shapes (no imported asset/emoji) so it's unique to this
/// app. Used on the empty state and as a small accent on the summary
/// card.
class CoinBotMascot extends StatelessWidget {
  final double size;

  /// Slight variant used when filters currently hide everything —
  /// draws the antenna light off instead of on.
  final bool idle;

  const CoinBotMascot({super.key, this.size = 140, this.idle = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CoinBotPainter(idle: idle),
      ),
    );
  }
}

class _CoinBotPainter extends CustomPainter {
  final bool idle;
  _CoinBotPainter({required this.idle});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPaint = Paint()..color = AppColors.slate;
    final panelPaint = Paint()..color = AppColors.electric;
    final darkPaint = Paint()..color = AppColors.inkLight;
    final antennaPaint = Paint()
      ..color = idle ? AppColors.slate : AppColors.amber;
    final legPaint = Paint()..color = AppColors.inkLight.withOpacity(0.85);
    final coinPaint = Paint()..color = AppColors.amber;

    // Legs
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.30, h * 0.82, w * 0.10, h * 0.13),
          const Radius.circular(4)),
      legPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.60, h * 0.82, w * 0.10, h * 0.13),
          const Radius.circular(4)),
      legPaint,
    );

    // Antenna
    final antennaBase = Offset(w * 0.5, h * 0.14);
    canvas.drawLine(
      Offset(w * 0.5, h * 0.20),
      antennaBase,
      Paint()
        ..color = AppColors.inkLight
        ..strokeWidth = 3,
    );
    canvas.drawCircle(antennaBase, w * 0.035, antennaPaint);

    // Head (rounded square)
    final headRect = Rect.fromLTWH(w * 0.18, h * 0.20, w * 0.64, h * 0.42);
    canvas.drawRRect(
      RRect.fromRectAndRadius(headRect, Radius.circular(w * 0.14)),
      bodyPaint,
    );

    // Face panel
    final panelRect = Rect.fromLTWH(w * 0.26, h * 0.28, w * 0.48, h * 0.24);
    canvas.drawRRect(
      RRect.fromRectAndRadius(panelRect, Radius.circular(w * 0.06)),
      panelPaint,
    );

    // Eyes
  canvas.drawCircle(
  Offset(w * 0.40, h * 0.40),
  w * 0.03,
  Paint()..color = Colors.white,
);

canvas.drawCircle(
  Offset(w * 0.60, h * 0.40),
  w * 0.03,
  Paint()..color = Colors.white,
);

canvas.drawCircle(
  Offset(w * 0.40, h * 0.40),
  w * 0.013,
  darkPaint,
);

canvas.drawCircle(
  Offset(w * 0.60, h * 0.40),
  w * 0.013,
  darkPaint,
);
    // Body (slightly narrower rounded rect)
    final bodyRect = Rect.fromLTWH(w * 0.24, h * 0.60, w * 0.52, h * 0.26);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bodyRect, Radius.circular(w * 0.10)),
      bodyPaint,
    );

    // Coin slot on chest (the "track" detail)
    final slotRect = Rect.fromLTWH(w * 0.43, h * 0.68, w * 0.14, h * 0.035);
    canvas.drawRRect(
      RRect.fromRectAndRadius(slotRect, const Radius.circular(3)),
      darkPaint,
    );

    // Arms
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.12, h * 0.62, w * 0.10, h * 0.18),
          const Radius.circular(6)),
      legPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.78, h * 0.62, w * 0.10, h * 0.18),
          const Radius.circular(6)),
      legPaint,
    );

    // A coin hovering near the slot, mid-deposit
    canvas.drawCircle(Offset(w * 0.5, h * 0.88), w * 0.055, coinPaint);
    final coinTextPaint = TextPainter(
      text: TextSpan(
        text: '\$',
        style: TextStyle(
          color: AppColors.inkLight,
          fontSize: w * 0.05,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    coinTextPaint.paint(
      canvas,
      Offset(w * 0.5 - coinTextPaint.width / 2,
          h * 0.88 - coinTextPaint.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _CoinBotPainter oldDelegate) =>
      oldDelegate.idle != idle;
}
