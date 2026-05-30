import '../../../../core/network/api_client.dart';
import '../models/optic_product_model.dart';

/// Fuente de datos remota de productos ópticos.
/// Es la única clase del feature `optics` que conoce los endpoints concretos.
class OpticsRemoteDataSource {
  final ApiClient _api;
  OpticsRemoteDataSource(this._api);

  Future<List<OpticProductModel>> getProducts() async {
    final data = await _api.get('/optics');
    final list = data as List;
    return list
        .map((e) => OpticProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<OpticProductModel> create(OpticProductModel product) async {
    final data = await _api.post('/optics', product.toJson());
    return OpticProductModel.fromJson(data as Map<String, dynamic>);
  }

  Future<OpticProductModel> update(String id, OpticProductModel product) async {
    final data = await _api.put('/optics/$id', product.toJson());
    return OpticProductModel.fromJson(data as Map<String, dynamic>);
  }

  Future<void> delete(String id) async {
    await _api.delete('/optics/$id');
  }
}
