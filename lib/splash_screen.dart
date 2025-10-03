import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart' show KiKhaboApp;
import 'login_screen.dart'; // so we can use PageRouteBuilder with custom duration

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
      duration: const Duration(milliseconds: 1200),
    );
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _scale = CurvedAnimation(
      parent: _scaleCtrl,
      curve: const Cubic(0.25, 0.46, 0.45, 0.94),
    );

    _fadeCtrl.forward();
    _scaleCtrl.forward();

    // Navigate with a slower route so the Hero flight isn't “too fast”.
    Timer(const Duration(milliseconds: 2300), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          settings: const RouteSettings(name: '/login'),
          transitionDuration: const Duration(milliseconds: 1200),
          reverseTransitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => const LoginScreen(),
        ),
      );
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
                children: const [
                  // HERO: wraps a fitted brand to avoid overflow during hero flight
                  Hero(
                    tag: 'brand-hero',
                    // Material prevents default “ink” effects during flight
                    child: Material(
                      color: Colors.transparent,
                      child: _BrandLogoTitle(iconSize: 96, titleSize: 32),
                    ),
                  ),
                  SizedBox(height: 24),
                  _AnimatedLoadingBar(duration: Duration(milliseconds: 1800)),
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

/// Re-usable brand. FittedBox keeps it from overflowing in tight hero layouts.
class _BrandLogoTitle extends StatelessWidget {
  const _BrandLogoTitle({required this.iconSize, required this.titleSize});

  final double iconSize;
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.fastfood_rounded,
            size: iconSize,
            color: KiKhaboApp.kPrimary,
          ),
          const SizedBox(height: 8),
          Text(
            'Ki Khabo',
            maxLines: 1, // avoid multi-line wrap during flight
            softWrap: false,
            overflow: TextOverflow.visible,
            style: TextStyle(
              fontSize: titleSize,
              height: 1.1, // tighter line-height to reduce vertical size
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: KiKhaboApp.kPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
