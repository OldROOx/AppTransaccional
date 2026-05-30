import '../../features/optics/domain/entities/optic_product_entity.dart';

/// Argumentos tipados para `OpticsFormScreen`.
///
/// En Navigator 1.0 los argumentos se pasan como `Object?`. Envolverlos en una
/// clase con tipo concreto evita el casteo a ciegas y los typos: el IDE
/// autocompleta los campos y el compilador atrapa errores.
class OpticsFormArguments {
  /// Si es `null` -> modo creación. Si trae un producto -> modo edición.
  final OpticProductEntity? product;

  const OpticsFormArguments({this.product});
}
