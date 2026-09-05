import 'package:flutter/material.dart';
import 'package:kranti_ganesh_mandal/core/auth/auth_controller.dart';
import 'package:kranti_ganesh_mandal/core/constants/app_colors.dart';
import 'package:kranti_ganesh_mandal/core/locale/l10n_extensions.dart';
import 'package:kranti_ganesh_mandal/core/widgets/login_text_field.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final l10n = context.l10n;
    setState(() => _isLoading = true);

    final error = await AuthController.instance.login(
      mobileInput: _mobileController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      final message = switch (error) {
        'invalidMobile' => l10n.invalidMobile,
        'invalidPassword' => l10n.invalidPassword,
        'invalidCredentials' => l10n.invalidCredentials,
        'accountInactive' => l10n.accountInactive,
        _ => l10n.loginFailed,
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: const Color(0xFF14100E),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Image.asset(
                'assets/images/ganesha_splash.png',
                fit: BoxFit.contain,
                height: 200,
                cacheHeight: 400,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.temple_hindu_rounded,
                  size: 120,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.splashTitleMarathi,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 32),
              LoginTextField(
                controller: _mobileController,
                label: l10n.mobileNumber,
                keyboardType: TextInputType.phone,
                maxLength: 10,
              ),
              const SizedBox(height: 12),
              LoginTextField(
                controller: _passwordController,
                label: l10n.password,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isLoading ? null : _login,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          l10n.login,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
