import 'package:flutter/material.dart';

import '../../features/optics/domain/entities/optic_product_entity.dart';
import 'app_routes.dart';
import 'route_arguments.dart';

/// Navegador tipado.
///
/// En vez de escribir strings sueltos y argumentos sin tipo:
///   `Navigator.pushNamed(ctx, '/optics/form', arguments: producto)`
///
/// usamos métodos con firma tipada:
///   `AppNavigator.toOpticsForm(ctx, product: producto)`
///
/// Ventaja: el IDE autocompleta, el compilador atrapa typos y los argumentos
/// quedan documentados. Si mañana renombras la ruta, sólo cambias un lugar.
class AppNavigator {
  AppNavigator._();

  /// Reemplaza la pila por Login (se usa al hacer logout).
  static Future<T?> toLogin<T>(BuildContext ctx) {
    return Navigator.of(ctx)
        .pushNamedAndRemoveUntil<T>(AppRoutes.login, (_) => false);
  }

  /// Va a Register desde Login.
  static Future<T?> toRegister<T>(BuildContext ctx) {
    return Navigator.of(ctx).pushNamed<T>(AppRoutes.register);
  }

  /// Reemplaza Login por la lista de productos (tras iniciar sesión).
  static Future<T?> toOpticsList<T>(BuildContext ctx) {
    return Navigator.of(ctx)
        .pushReplacementNamed<T, dynamic>(AppRoutes.opticsList);
  }

  /// Va al formulario. Si pasas un [product] es edición; si no, creación.
  /// Devuelve `true` si se guardó algo (para refrescar la lista si quieres).
  ///
  /// Nota: usamos `pushNamed` SIN genérico concreto y casteamos el resultado
  /// manualmente. Si pones `pushNamed<bool>`, Flutter intenta castear el
  /// `MaterialPageRoute<dynamic>` que devuelve onGenerateRoute a
  /// `Route<bool?>` y truena en runtime con un TypeError.
  static Future<bool?> toOpticsForm(
      BuildContext ctx, {
        OpticProductEntity? product,
      }) async {
    final result = await Navigator.of(ctx).pushNamed(
      AppRoutes.opticsForm,
      arguments: OpticsFormArguments(product: product),
    );
    return result as bool?;
  }

  /// Cierra la pantalla actual con un resultado tipado opcional.
  static void back<T>(BuildContext ctx, [T? result]) {
    Navigator.of(ctx).pop(result);
  }
}