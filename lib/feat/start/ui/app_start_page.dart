import 'package:finances_control/core/route/path/app_route_path.dart';
import 'package:finances_control/feat/start/vm/app_start_state.dart';
import 'package:finances_control/feat/start/vm/app_start_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppStartPage extends StatefulWidget {
  const AppStartPage({super.key});

  @override
  State<AppStartPage> createState() => _AppStartPageState();
}

class _AppStartPageState extends State<AppStartPage> {
  static const _nativeSplashBackground = Color(0xFF00C853);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppStartViewModel>().check();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppStartViewModel, AppStartState>(
      listener: (context, state) {
        if (state.status == AppStartStatus.onboarding) {
          Navigator.pushReplacementNamed(context, AppRoutePath.onboarding.path);
        }

        if (state.status == AppStartStatus.home) {
          Navigator.pushReplacementNamed(context, AppRoutePath.homePage.path);
        }
      },
      child: const Scaffold(
        backgroundColor: _nativeSplashBackground,
        body: Center(
          child: CustomPaint(
            size: Size(108, 108),
            painter: _LogoPainter(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final Color color;

  const _LogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final chartPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final chartPath = Path()
      ..moveTo(size.width * 0.15, size.height * 0.75)
      ..lineTo(size.width * 0.15, size.height * 0.38)
      ..lineTo(size.width * 0.33, size.height * 0.18)
      ..lineTo(size.width * 0.50, size.height * 0.35)
      ..lineTo(size.width * 0.68, size.height * 0.15)
      ..lineTo(size.width * 0.85, size.height * 0.35)
      ..lineTo(size.width * 0.85, size.height * 0.75);

    canvas.drawPath(chartPath, chartPaint);

    final basePaint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.08, size.height * 0.83),
      Offset(size.width * 0.92, size.height * 0.83),
      basePaint,
    );

    final crownPath = Path()
      ..moveTo(size.width * 0.68, size.height * 0.05)
      ..lineTo(size.width * 0.68, size.height * 0.14)
      ..lineTo(size.width * 0.78, size.height * 0.14)
      ..lineTo(size.width * 0.78, size.height * 0.05)
      ..lineTo(size.width * 0.88, size.height * 0.12)
      ..lineTo(size.width * 0.78, size.height * 0.20)
      ..lineTo(size.width * 0.78, size.height * 0.11)
      ..lineTo(size.width * 0.68, size.height * 0.11)
      ..lineTo(size.width * 0.68, size.height * 0.20)
      ..close();

    final crownPaint = Paint()..color = color.withValues(alpha: 0.85);
    canvas.drawPath(crownPath, crownPaint);
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) =>
      oldDelegate.color != color;
}
