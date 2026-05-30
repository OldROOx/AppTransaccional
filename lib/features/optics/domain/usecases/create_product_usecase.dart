import '../entities/optic_product_entity.dart';
import '../repositories/optics_repository.dart';

class CreateProductUseCase {
  final OpticsRepository _repository;
  CreateProductUseCase(this._repository);

  Future<OpticProductEntity> call(OpticProductEntity product) =>
      _repository.createProduct(product);
}
