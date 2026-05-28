import 'package:flutter/material.dart';
import '../../optics/views/optics_list_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_circle, size: 100, color: Colors.teal),
              const SizedBox(height: 32),
              const TextField(decoration: InputDecoration(labelText: 'Usuario')),
              const SizedBox(height: 16),
              const TextField(decoration: InputDecoration(labelText: 'Contraseña'), obscureText: true),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => const OpticsListScreen()),
                ),
                child: const Text('Iniciar Sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}