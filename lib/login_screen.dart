import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'main.dart' show KiKhaboApp;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    // Faster fade/slide
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.035),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOutCubic));

    // Start fade AFTER the Hero/route transition completes.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final route = ModalRoute.of(context);
      final anim = route?.animation;
      if (anim == null || anim.status == AnimationStatus.completed) {
        _fadeCtrl.forward();
      } else {
        anim.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _fadeCtrl.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtle = theme.brightness == Brightness.dark
        ? KiKhaboApp.kSubtleDark
        : KiKhaboApp.kSubtleLight;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        automaticallyImplyLeading: false, // <-- no back button
        title: const Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560, minHeight: 480),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Hero brand (arrives first)
                  const Hero(
                    tag: 'brand-hero',
                    child: Material(
                      color: Colors.transparent,
                      child: _BrandLogoTitle(iconSize: 64, titleSize: 24),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Everything below fades/slides in together (including footer line)
                  FadeTransition(
                    opacity: _fade,
                    child: SlideTransition(
                      position: _slide,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _EmailOrPhoneField(),
                          const SizedBox(height: 16),
                          const _PasswordField(),
                          const SizedBox(height: 8),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                /* TODO: Forgot password */
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: subtle,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              child: const Text('Forgot Password?'),
                            ),
                          ),
                          const SizedBox(height: 8),

                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {
                                /* TODO: login */
                              },
                              child: const Text('Login'),
                            ),
                          ),
                          const SizedBox(height: 18),

                          Row(
                            children: [
                              Expanded(
                                child: Divider(color: theme.dividerColor),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  'Or login with',
                                  style: TextStyle(color: subtle, fontSize: 13),
                                ),
                              ),
                              Expanded(
                                child: Divider(color: theme.dividerColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {
                                /* TODO: Google sign-in */
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: theme.colorScheme.surface,
                                side: BorderSide(
                                  color: theme.brightness == Brightness.dark
                                      ? const Color(0xFF44403C)
                                      : const Color(0xFFD6D3D1),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.string(
                                    _googleSvg,
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('Google'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Footer line is now part of the fade/slide group
                          Center(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account? ",
                                  style: TextStyle(fontSize: 14),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(
                                    context,
                                  ).pushNamed('/signup'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: KiKhaboApp.kPrimary,
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  child: const Text('Sign up'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
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

/// Fitted brand (matches splash hero widget) to avoid overflow during flight.
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
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              fontSize: titleSize,
              height: 1.1,
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

class _EmailOrPhoneField extends StatelessWidget {
  const _EmailOrPhoneField();
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(hintText: 'Email or Phone'),
    );
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField();
  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscure,
      decoration: InputDecoration(
        hintText: 'Password',
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscure = !_obscure),
          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
        ),
      ),
    );
  }
}

const String _googleSvg = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
<path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"></path>
<path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"></path>
<path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z" fill="#FBBC05"></path>
<path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"></path>
</svg>
''';
