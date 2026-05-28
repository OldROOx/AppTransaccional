import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/optic_product.dart';
import '../viewmodels/optics_viewmodel.dart';

class OpticsFormScreen extends StatefulWidget {
  final OpticProduct? product;
  const OpticsFormScreen({super.key, this.product});

  @override
  State<OpticsFormScreen> createState() => _OpticsFormScreenState();
}

class _OpticsFormScreenState extends State<OpticsFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _categoryController = TextEditingController(text: widget.product?.category ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<OpticsViewModel>().state == ViewState.loading;

    return Scaffold(
      appBar: AppBar(title: Text(widget.product == null ? 'Nuevo Producto' : 'Editar Producto')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre del Lente/Armazón'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Categoría'),
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _saveProduct,
                  child: isLoading 
                      ? const CircularProgressIndicator() 
                      : const Text('Guardar', style: TextStyle(fontSize: 18)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final vm = context.read<OpticsViewModel>();
      final newProduct = OpticProduct(
        id: widget.product?.id,
        name: _nameController.text,
        category: _categoryController.text,
        price: double.parse(_priceController.text),
      );

      bool success;
      if (widget.product == null) {
        success = await vm.addProduct(newProduct);
      } else {
        success = await vm.updateProduct(widget.product!.id!, newProduct);
      }

      if (success && mounted) Navigator.pop(context);
    }
  }
}