import 'package:flutter/foundation.dart';

import '../../../../core/state/view_state.dart';
import '../../domain/entities/optic_product_entity.dart';
import '../../domain/usecases/create_product_usecase.dart';
import '../../domain/usecases/delete_product_usecase.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/update_product_usecase.dart';

/// ViewModel del feature `optics`. Centraliza:
///  - Estado de la lista (loading / success / error).
///  - La lista actual de productos.
///  - Filtrado por categoría seleccionada.
///  - Estado independiente para guardado (isSaving) para que el formulario
///    no afecte el estado de la pantalla de lista.
class OpticsViewModel extends ChangeNotifier {
  final GetProductsUseCase _getProducts;
  final CreateProductUseCase _createProduct;
  final UpdateProductUseCase _updateProduct;
  final DeleteProductUseCase _deleteProduct;

  OpticsViewModel({
    required GetProductsUseCase getProducts,
    required CreateProductUseCase createProduct,
    required UpdateProductUseCase updateProduct,
    required DeleteProductUseCase deleteProduct,
  })  : _getProducts = getProducts,
        _createProduct = createProduct,
        _updateProduct = updateProduct,
        _deleteProduct = deleteProduct;

  // ---------------------- ESTADO ----------------------
  ViewState _state = ViewState.idle;
  ViewState get state => _state;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<OpticProductEntity> _products = [];
  List<OpticProductEntity> get products => _products;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _selectedCategory;
  String? get selectedCategory => _selectedCategory;

  /// Categorías únicas presentes en la lista actual.
  List<String> get categories =>
      {..._products.map((p) => p.category)}.toList()..sort();

  /// Lista filtrada por categoría seleccionada (o todas si es null).
  List<OpticProductEntity> get visibleProducts {
    if (_selectedCategory == null) return _products;
    return _products.where((p) => p.category == _selectedCategory).toList();
  }

  // ---------------------- ACCIONES ----------------------
  Future<void> fetchProducts() async {
    _setState(ViewState.loading);
    try {
      _products = await _getProducts();
      _setState(ViewState.success);
    } catch (e) {
      _errorMessage = e.toString();
      _setState(ViewState.error);
    }
  }

  Future<bool> createProduct(OpticProductEntity product) async {
    _isSaving = true;
    notifyListeners();
    try {
      final created = await _createProduct(product);
      _products = [created, ..._products];
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(String id, OpticProductEntity product) async {
    _isSaving = true;
    notifyListeners();
    try {
      final updated = await _updateProduct(id, product);
      _products = _products.map((p) => p.id == id ? updated : p).toList();
      _isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isSaving = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      await _deleteProduct(id);
      _products = _products.where((p) => p.id != id).toList();
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  void selectCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void _setState(ViewState s) {
    _state = s;
    notifyListeners();
  }
}
