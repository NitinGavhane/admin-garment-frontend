import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController(text: 'admin@garment.com');
  final _passCtrl = TextEditingController(text: 'Admin@1234');
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailCtrl.text.trim().isEmpty || _passCtrl.text.isEmpty) return;
    final auth = context.read<AdminAuthProvider>();
    final ok = await auth.login(_emailCtrl.text.trim(), _passCtrl.text);
    if (ok && mounted) Navigator.pushReplacementNamed(context, '/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              AppColors.surface,
              AppColors.bg,
              AppColors.bg,
            ],
            center: const Alignment(0.2, -0.3),
            radius: 1.8,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: AppColors.coralGradient),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        ...AppColors.shadowGlow(AppColors.coral),
                        BoxShadow(color: AppColors.coral.withValues(alpha: 0.15), blurRadius: 40, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: const Center(child: Text('A', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900))),
                  ),
                  const SizedBox(height: 28),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [AppColors.textPrimary, AppColors.coral],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ).createShader(bounds),
                    child: const Text('ADMIN', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: 10)),
                  ),
                  const SizedBox(height: 8),
                  Text('GARMENT STORE', style: TextStyle(color: AppColors.textMuted, fontSize: 10, letterSpacing: 8, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 56),
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.surface, AppColors.surfaceAlt],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(color: AppColors.borderLight, width: 1),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        ...AppColors.shadowLg,
                        BoxShadow(color: AppColors.coral.withValues(alpha: 0.04), blurRadius: 60, offset: const Offset(0, 0)),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailCtrl,
                          style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
                          decoration: InputDecoration(
                            labelText: 'EMAIL',
                            labelStyle: TextStyle(color: AppColors.textMuted, fontSize: 10, letterSpacing: 2.5, fontWeight: FontWeight.w700),
                            prefixIcon: Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.coral.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.email_outlined, color: AppColors.coral, size: 18),
                            ),
                            filled: true,
                            fillColor: AppColors.bgAlt,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppColors.border, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppColors.border, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppColors.coral, width: 1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _passCtrl,
                          obscureText: _obscure,
                          style: TextStyle(color: AppColors.textPrimary, fontSize: 13),
                          decoration: InputDecoration(
                            labelText: 'PASSWORD',
                            labelStyle: TextStyle(color: AppColors.textMuted, fontSize: 10, letterSpacing: 2.5, fontWeight: FontWeight.w700),
                            prefixIcon: Container(
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.coral.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.lock_outlined, color: AppColors.coral, size: 18),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textMuted, size: 18),
                              onPressed: () => setState(() => _obscure = !_obscure),
                            ),
                            filled: true,
                            fillColor: AppColors.bgAlt,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppColors.border, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppColors.border, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppColors.coral, width: 1),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Consumer<AdminAuthProvider>(builder: (_, a, __) =>
                            a.error != null
                                ? Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: AppColors.error.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
                                    ),
                                    child: Row(children: [
                                      Container(
                                        width: 24, height: 24,
                                        decoration: BoxDecoration(
                                          color: AppColors.error.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Icon(Icons.error_outline, color: AppColors.error, size: 14),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(child: Text(a.error!, style: TextStyle(color: AppColors.error, fontSize: 11))),
                                    ]),
                                  )
                                : const SizedBox.shrink()),
                        const SizedBox(height: 24),
                        Consumer<AdminAuthProvider>(builder: (_, a, __) =>
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: a.isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.black,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  elevation: 0,
                                ).copyWith(
                                  backgroundColor: WidgetStateProperty.resolveWith((states) => Colors.transparent),
                                ),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [AppColors.btnColor, AppColors.btnColor80]),
                                    border: Border.all(color: AppColors.btnBorder, width: 1),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: AppColors.shadowGlow(AppColors.btnColor),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    child: a.isLoading
                                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                                        : const Text('SIGN IN', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 5)),
                                  ),
                                ),
                              ),
                            )),
                      ],
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
