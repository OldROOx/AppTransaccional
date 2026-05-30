import '../repositories/optics_repository.dart';

class DeleteProductUseCase {
  final OpticsRepository _repository;
  DeleteProductUseCase(this._repository);

  Future<void> call(String id) => _repository.deleteProduct(id);
}
