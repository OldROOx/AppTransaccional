import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/network/api_client.dart';
import 'core/routes/app_router.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'features/optics/data/datasources/optics_remote_datasource.dart';
import 'features/optics/data/repositories/optics_repository_impl.dart';
import 'features/optics/domain/usecases/create_product_usecase.dart';
import 'features/optics/domain/usecases/delete_product_usecase.dart';
import 'features/optics/domain/usecases/get_products_usecase.dart';
import 'features/optics/domain/usecases/update_product_usecase.dart';
import 'features/optics/presentation/viewmodels/optics_viewmodel.dart';

/// Composition Root (Inyección de dependencias MANUAL).
///
/// Aquí se arma el grafo completo de dependencias UNA sola vez al arrancar
/// la app, en este orden:
///
///   ApiClient (Singleton de http)
///     └─ DataSources         (saben de HTTP)
///         └─ Repositories     (implementan los contratos del dominio)
///             └─ UseCases     (una acción de negocio cada uno)
///                 └─ ViewModels  (estado de las pantallas)
///                     └─ MultiProvider expone los VMs a la UI
///
/// Esta es la única clase de la app que conoce el grafo completo;
/// el resto de capas dependen sólo de las interfaces de la capa que les sigue.
void main() {
  // ---- Núcleo ----
  final apiClient = ApiClient();

  // ---- Feature AUTH ----
  final authRemote = AuthRemoteDataSource(apiClient);
  final authRepo = AuthRepositoryImpl(authRemote);
  final loginUseCase = LoginUseCase(authRepo);
  final registerUseCase = RegisterUseCase(authRepo);

  // ---- Feature OPTICS ----
  final opticsRemote = OpticsRemoteDataSource(apiClient);
  final opticsRepo = OpticsRepositoryImpl(opticsRemote);
  final getProducts = GetProductsUseCase(opticsRepo);
  final createProduct = CreateProductUseCase(opticsRepo);
  final updateProduct = UpdateProductUseCase(opticsRepo);
  final deleteProduct = DeleteProductUseCase(opticsRepo);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(
            loginUseCase: loginUseCase,
            registerUseCase: registerUseCase,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => OpticsViewModel(
            getProducts: getProducts,
            createProduct: createProduct,
            updateProduct: updateProduct,
            deleteProduct: deleteProduct,
          ),
        ),
      ],
      child: const OptiScaleApp(),
    ),
  );
}

class OptiScaleApp extends StatelessWidget {
  const OptiScaleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OptiScale Transaccional',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Navegación 1.0: ruta inicial + onGenerateRoute centralizado.
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
