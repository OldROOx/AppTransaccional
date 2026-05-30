import 'package:flutter/material.dart';

import '../../features/auth/presentation/views/login_screen.dart';
import '../../features/auth/presentation/views/register_screen.dart';
import '../../features/optics/presentation/views/optics_form_screen.dart';
import '../../features/optics/presentation/views/optics_list_screen.dart';
import 'app_routes.dart';
import 'route_arguments.dart';

/// Router central. Vive aquí toda la lógica de armar páginas y desempacar
/// argumentos tipados, así las vistas no tocan `settings.arguments` directo.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return _page(const LoginScreen(), settings);

      case AppRoutes.register:
        return _page(const RegisterScreen(), settings);

      case AppRoutes.opticsList:
        return _page(const OpticsListScreen(), settings);

      case AppRoutes.opticsForm:
        // Desempacar arguments con tipado seguro:
        final args = settings.arguments as OpticsFormArguments?;
        return _page(OpticsFormScreen(product: args?.product), settings);

      default:
        return _page(const _NotFoundScreen(), settings);
    }
  }

  static MaterialPageRoute<T> _page<T>(Widget child, RouteSettings settings) {
    return MaterialPageRoute<T>(
      settings: settings,
      builder: (_) => child,
    );
  }
}

class _NotFoundScreen extends StatelessWidget {
  const _NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruta no encontrada')),
      body: const Center(child: Text('404 — Esa ruta no existe.')),
    );
  }
}
