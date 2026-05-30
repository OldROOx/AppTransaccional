import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/assets/app_assets.dart';
import '../../../../core/routes/app_navigator.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../viewmodels/auth_viewmodel.dart';

/// Pantalla de registro. Llama al backend (/api/auth/register).
/// Tras un registro exitoso, navega directo al inventario (ya quedó logueado).
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<AuthViewModel>();
    final ok = await vm.register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      username: _userCtrl.text.trim(),
      password: _passCtrl.text,
    );

    if (!mounted) return;

    final cs = Theme.of(context).colorScheme;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('¡Cuenta creada con éxito!'),
          backgroundColor: cs.tertiaryContainer,
        ),
      );
      AppNavigator.toOpticsList(context);
    } else {
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Crear cuenta',
            style: TextStyle(color: cs.onPrimary)),
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: cs.onPrimary),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cs.primary, cs.primaryContainer],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AppAssets.logo,
                        width: 96,
                        height: 96,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.person_add_alt_1,
                          size: 72,
                          color: cs.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Únete a OptiScale',
                        style: text.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppTextField(
                        controller: _nameCtrl,
                        label: 'Nombre completo',
                        icon: Icons.person,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Ingresa tu nombre';
                          }
                          if (v.trim().length < 3) {
                            return 'Mínimo 3 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _emailCtrl,
                        label: 'Correo electrónico',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Ingresa tu correo';
                          }
                          if (!v.contains('@') || !v.contains('.')) {
                            return 'Correo no válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _userCtrl,
                        label: 'Nombre de usuario',
                        icon: Icons.alternate_email,
                        validator: (v) =>
                            (v == null || v.trim().length < 3)
                                ? 'Mínimo 3 caracteres'
                                : null,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _passCtrl,
                        label: 'Contraseña',
                        icon: Icons.lock_outline,
                        obscureText: true,
                        validator: (v) => (v == null || v.length < 8)
                            ? 'Mínimo 8 caracteres'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      AppTextField(
                        controller: _pass2Ctrl,
                        label: 'Confirmar contraseña',
                        icon: Icons.lock_reset,
                        obscureText: true,
                        validator: (v) => (v != _passCtrl.text)
                            ? 'Las contraseñas no coinciden'
                            : null,
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        label: 'Registrarse',
                        icon: Icons.person_add,
                        isLoading: isLoading,
                        onPressed: _onSubmit,
                      ),
                    ],
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
