import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'main.dart' show KiKhaboApp;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscure = true;
  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _createAccount() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    // TODO: Hook up to your backend / Firebase
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;
    setState(() => _submitting = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Account created (demo).')));

    // Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtleText = theme.brightness == Brightness.dark
        ? KiKhaboApp.kSubtleDark
        : KiKhaboApp.kSubtleLight;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // <-- no back button
        title: const Text(
          'Sign up',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'Create an account',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),

                      // Full Name
                      TextFormField(
                        controller: _nameCtrl,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'Full Name',
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter your full name'
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Email
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'Email address',
                        ),
                        validator: (v) {
                          final value = v?.trim() ?? '';
                          final emailRegex = RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          );
                          if (value.isEmpty) return 'Please enter your email';
                          if (!emailRegex.hasMatch(value))
                            return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone
                      TextFormField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9+\-\s]'),
                          ),
                        ],
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: 'Mobile number',
                        ),
                        validator: (v) {
                          final value = v?.trim() ?? '';
                          if (value.isEmpty)
                            return 'Please enter your mobile number';
                          if (value.replaceAll(RegExp(r'[^0-9]'), '').length <
                              8) {
                            return 'Enter a valid mobile number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscure,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off_rounded
                                  : Icons.visibility_rounded,
                            ),
                          ),
                        ),
                        validator: (v) {
                          final value = v ?? '';
                          if (value.isEmpty) return 'Please create a password';
                          if (value.length < 6) return 'Minimum 6 characters';
                          return null;
                        },
                        onFieldSubmitted: (_) => _createAccount(),
                      ),
                      const SizedBox(height: 16),

                      // Create Account button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitting ? null : _createAccount,
                          child: _submitting
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Create Account'),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Divider "or"
                      Row(
                        children: [
                          Expanded(child: Divider(color: theme.dividerColor)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'or',
                              style: TextStyle(color: subtleText, fontSize: 13),
                            ),
                          ),
                          Expanded(child: Divider(color: theme.dividerColor)),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Google Sign Up
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            // TODO: Google sign-up flow
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: theme.colorScheme.surface,
                            side: BorderSide(
                              color: theme.brightness == Brightness.dark
                                  ? const Color(0xFF44403C)
                                  : const Color(0xFFD6D3D1),
                            ),
                            minimumSize: const Size.fromHeight(48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.string(
                                _googleSvg,
                                width: 22,
                                height: 22,
                              ),
                              const SizedBox(width: 10),
                              const Text('Sign up with Google'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Already have an account? Log in
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(color: subtleText, fontSize: 14),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/login'),
                            style: TextButton.styleFrom(
                              foregroundColor: KiKhaboApp.kPrimary,
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text('Log in'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer image
            AspectRatio(
              aspectRatio: 390 / 120,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBAsJGmCz7LkywPx7fR76ocR3Vi6kYlYbAaJuoPCzvM7qghJRbTE8FdZr2HZd6Xg5vvriwjBb6ardMLGoDps68B4FSdHAulIbm1XthCIzhNl9QxazzaAFTAji8jpswLJYLD8HwjVjA49ux1zbEJNm595ucoKe-dV3aH0eh-KkQJOI_-qEI65eqNVLupHa4bnaZpTbLVtViZPqfh3PXgDmLwHe34Ps053H658QlF6bfM4QZ3wBnC1l5il_11PnpH_3hObeJsfb_7VIRO',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const String _googleSvg = '''
<svg viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">
<path d="M24 9.5c3.9 0 6.9 1.6 9.1 3.7l6.8-6.8C35.4 2.1 30.1 0 24 0 14.9 0 7.3 5.4 4.1 12.9l7.9 6.2C13.6 13.5 18.3 9.5 24 9.5z" fill="#4285F4"/>
<path d="M46.2 25.4c0-1.7-.2-3.4-.5-5H24v9.5h12.5c-.5 3.1-2.1 5.7-4.6 7.5l7.5 5.8c4.4-4.1 7.3-10 7.3-17.8z" fill="#34A853"/>
<path d="M12 25.8c-.5-1.5-.8-3.1-.8-4.8s.3-3.3.8-4.8l-7.9-6.2C1.5 14.1 0 18.9 0 24s1.5 9.9 4.1 14.2l7.9-6.2z" fill="#FBBC05"/>
<path d="M24 48c6.1 0 11.4-2 15.1-5.4l-7.5-5.8c-2 1.3-4.6 2.1-7.6 2.1-5.7 0-10.4-4-12.1-9.4l-7.9 6.2C7.3 42.6 14.9 48 24 48z" fill="#EA4335"/>
<path d="M0 0h48v48H0z" fill="none"/>
</svg>
''';
