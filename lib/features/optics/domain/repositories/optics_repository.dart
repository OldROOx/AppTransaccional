import '../entities/optic_product_entity.dart';

/// Contrato del repositorio de productos ópticos.
abstract class OpticsRepository {
  Future<List<OpticProductEntity>> getProducts();
  Future<OpticProductEntity> createProduct(OpticProductEntity product);
  Future<OpticProductEntity> updateProduct(
      String id, OpticProductEntity product);
  Future<void> deleteProduct(String id);
}
