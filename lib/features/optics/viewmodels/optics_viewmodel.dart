import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../models/optic_product.dart';

enum ViewState { idle, loading, error }

class OpticsViewModel extends ChangeNotifier {
  final ApiClient _api = ApiClient.instance;
  
  List<OpticProduct> _products = [];
  List<OpticProduct> get products => _products;

  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  // GET
  Future<void> fetchProducts() async {
    _setState(ViewState.loading);
    try {
      final response = await _api.client.get(Uri.parse('${_api.baseUrl}/optics'));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        _products = data.map((e) => OpticProduct.fromJson(e)).toList();
        _setState(ViewState.idle);
      } else {
        _setError('Error al cargar productos');
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  // POST
  Future<bool> addProduct(OpticProduct product) async {
    _setState(ViewState.loading);
    try {
      final response = await _api.client.post(
        Uri.parse('${_api.baseUrl}/optics'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );
      if (response.statusCode == 201) {
        await fetchProducts();
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // PUT
  Future<bool> updateProduct(String id, OpticProduct product) async {
    _setState(ViewState.loading);
    try {
      final response = await _api.client.put(
        Uri.parse('${_api.baseUrl}/optics/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(product.toJson()),
      );
      if (response.statusCode == 200) {
        await fetchProducts();
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // DELETE
  Future<void> deleteProduct(String id) async {
    try {
      final response = await _api.client.delete(Uri.parse('${_api.baseUrl}/optics/$id'));
      if (response.statusCode == 200) {
        _products.removeWhere((p) => p.id == id);
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    }
  }

  void _setState(ViewState state) {
    _state = state;
    notifyListeners();
  }

  void _setError(String msg) {
    _errorMessage = msg;
    _setState(ViewState.error);
  }
}