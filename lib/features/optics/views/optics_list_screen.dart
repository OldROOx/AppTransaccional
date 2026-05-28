import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/optics_viewmodel.dart';
import 'optics_form_screen.dart';

class OpticsListScreen extends StatefulWidget {
  const OpticsListScreen({super.key});

  @override
  State<OpticsListScreen> createState() => _OpticsListScreenState();
}

class _OpticsListScreenState extends State<OpticsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OpticsViewModel>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    // UI = f(state)
    final viewModel = context.watch<OpticsViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Inventario Óptico')),
      body: _buildBody(viewModel),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OpticsFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(OpticsViewModel vm) {
    if (vm.state == ViewState.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.state == ViewState.error) {
      return Center(child: Text('Error: ${vm.errorMessage}'));
    }
    if (vm.products.isEmpty) {
      return const Center(child: Text('No hay productos registrados.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: vm.products.length,
      itemBuilder: (context, index) {
        final product = vm.products[index];
        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: const Icon(Icons.remove_red_eye),
            ),
            title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${product.category} - \$${product.price}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => vm.deleteProduct(product.id!),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => OpticsFormScreen(product: product)),
            ),
          ),
        );
      },
    );
  }
}