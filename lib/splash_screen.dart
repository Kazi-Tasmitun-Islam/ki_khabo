import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart' show KiKhaboApp;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final AnimationController _scaleCtrl;
  late final Animation<double> _fade;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _scale = CurvedAnimation(
      parent: _scaleCtrl,
      curve: const Cubic(0.25, 0.46, 0.45, 0.94),
    );

    _fadeCtrl.forward();
    _scaleCtrl.forward();

    // Navigate to Login after progress finishes
    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _scaleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: theme.scaffoldBackgroundColor,
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon (using Material icon instead of the HTML path)
                  Icon(
                    Icons.fastfood_rounded,
                    size: 96,
                    color: KiKhaboApp.kPrimary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Ki Khabo',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: KiKhaboApp.kPrimary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Rounded progress bar that fills over ~2.5s
                  _AnimatedLoadingBar(
                    duration: const Duration(milliseconds: 2500),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AnimatedLoadingBar extends StatelessWidget {
  const _AnimatedLoadingBar({required this.duration});
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgBar = theme.brightness == Brightness.dark
        ? const Color(0xFF374151) // gray-700-ish
        : const Color(0xFFE5E7EB); // gray-200-ish

    return Container(
      width: 192, // ~w-48
      height: 8, // ~h-2
      decoration: BoxDecoration(
        color: bgBar,
        borderRadius: BorderRadius.circular(9999),
      ),
      clipBehavior: Clip.hardEdge,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: duration,
        curve: Curves.easeInOut,
        builder: (context, value, _) {
          return Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: value,
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: KiKhaboApp.kPrimary,
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
