import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/views/login_screen.dart';
import 'features/optics/viewmodels/optics_viewmodel.dart';

void main() {
  runApp(
    // Inyección de dependencias en la raíz del árbol de widgets
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OpticsViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OptiApp Transaccional',
      theme: AppTheme.lightTheme, // Uso de Material 3
      home: const LoginScreen(),  // Navegación 1.0 base
    );
  }
}