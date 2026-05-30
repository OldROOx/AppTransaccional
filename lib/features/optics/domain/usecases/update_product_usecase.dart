import '../entities/optic_product_entity.dart';
import '../repositories/optics_repository.dart';

class UpdateProductUseCase {
  final OpticsRepository _repository;
  UpdateProductUseCase(this._repository);

  Future<OpticProductEntity> call(String id, OpticProductEntity product) =>
      _repository.updateProduct(id, product);
}
