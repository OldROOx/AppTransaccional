import '../../domain/entities/optic_product_entity.dart';
import '../../domain/repositories/optics_repository.dart';
import '../datasources/optics_remote_datasource.dart';
import '../models/optic_product_model.dart';

class OpticsRepositoryImpl implements OpticsRepository {
  final OpticsRemoteDataSource _remote;
  OpticsRepositoryImpl(this._remote);

  @override
  Future<List<OpticProductEntity>> getProducts() => _remote.getProducts();

  @override
  Future<OpticProductEntity> createProduct(OpticProductEntity product) {
    return _remote.create(OpticProductModel.fromEntity(product));
  }

  @override
  Future<OpticProductEntity> updateProduct(
      String id, OpticProductEntity product) {
    return _remote.update(id, OpticProductModel.fromEntity(product));
  }

  @override
  Future<void> deleteProduct(String id) => _remote.delete(id);
}
