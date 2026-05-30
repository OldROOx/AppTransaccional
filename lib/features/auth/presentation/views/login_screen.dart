import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/assets/app_assets.dart';
import '../../../../core/routes/app_navigator.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../viewmodels/auth_viewmodel.dart';

/// Pantalla de Login. Llama al backend real (/api/auth/login).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // Pre-llenamos con el usuario demo que ya existe en el backend.
  final _userCtrl = TextEditingController(text: 'admin');
  final _passCtrl = TextEditingController(text: 'admin123');

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<AuthViewModel>();
    final ok = await vm.login(
      username: _userCtrl.text.trim(),
      password: _passCtrl.text.trim(),
    );

    if (!mounted) return;

    if (ok) {
      AppNavigator.toOpticsList(context);
    } else {
      final cs = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage),
          backgroundColor: cs.errorContainer,
          showCloseIcon: true,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final isLoading = context.watch<AuthViewModel>().isLoading;

    return Scaffold(
      body: Container(
        // Gradiente con colores del tema (NO hardcodeado).
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [cs.primary, cs.primaryContainer, cs.surface],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo desde assets. Si la imagen no se encuentra
                        // (por ejemplo durante el primer build), cae al icono.
                        ClipOval(
                          child: Image.asset(
                            AppAssets.logo,
                            width: 96,
                            height: 96,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => CircleAvatar(
                              radius: 38,
                              backgroundColor: cs.primaryContainer,
                              child: Icon(Icons.remove_red_eye,
                                  size: 42, color: cs.onPrimaryContainer),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'OptiScale',
                          textAlign: TextAlign.center,
                          style: text.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Inicia sesión para continuar',
                          textAlign: TextAlign.center,
                          style: text.bodyMedium
                              ?.copyWith(color: cs.onSurfaceVariant),
                        ),
                        const SizedBox(height: 28),
                        AppTextField(
                          controller: _userCtrl,
                          label: 'Usuario',
                          icon: Icons.person_outline,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Ingresa tu usuario'
                              : null,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: _passCtrl,
                          label: 'Contraseña',
                          icon: Icons.lock_outline,
                          obscureText: true,
                          validator: (v) => (v == null || v.length < 4)
                              ? 'Mínimo 4 caracteres'
                              : null,
                        ),
                        const SizedBox(height: 28),
                        AppButton(
                          label: 'Iniciar sesión',
                          icon: Icons.login,
                          isLoading: isLoading,
                          onPressed: _onSubmit,
                        ),
                        const SizedBox(height: 20),
                        // Separador "o" entre login y registro.
                        Row(
                          children: [
                            Expanded(
                              child: Divider(color: cs.outlineVariant),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'o',
                                style: text.bodySmall
                                    ?.copyWith(color: cs.onSurfaceVariant),
                              ),
                            ),
                            Expanded(
                              child: Divider(color: cs.outlineVariant),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Botón de registro mucho más visible: outlined con icono.
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(52),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            side: BorderSide(color: cs.primary, width: 1.5),
                            foregroundColor: cs.primary,
                          ),
                          onPressed: isLoading
                              ? null
                              : () => AppNavigator.toRegister(context),
                          icon: const Icon(Icons.person_add_alt_1),
                          label: const Text(
                            'Crear cuenta nueva',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
