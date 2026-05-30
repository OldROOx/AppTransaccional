import '../entities/optic_product_entity.dart';
import '../repositories/optics_repository.dart';

class GetProductsUseCase {
  final OpticsRepository _repository;
  GetProductsUseCase(this._repository);

  Future<List<OpticProductEntity>> call() => _repository.getProducts();
}
