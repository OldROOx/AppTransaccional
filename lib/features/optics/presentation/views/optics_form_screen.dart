import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/routes/app_navigator.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/optic_product_entity.dart';
import '../viewmodels/optics_viewmodel.dart';

/// Formulario que sirve para crear y editar. Si recibe un [product] no nulo,
/// está en modo edición; si no, en modo creación.
class OpticsFormScreen extends StatefulWidget {
  final OpticProductEntity? product;

  const OpticsFormScreen({super.key, this.product});

  bool get isEditing => product != null;

  @override
  State<OpticsFormScreen> createState() => _OpticsFormScreenState();
}

class _OpticsFormScreenState extends State<OpticsFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _categoryCtrl;
  late final TextEditingController _priceCtrl;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _categoryCtrl = TextEditingController(text: p?.category ?? '');
    _priceCtrl =
        TextEditingController(text: p == null ? '' : p.price.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _categoryCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<OpticsViewModel>();
    final entity = OpticProductEntity(
      id: widget.product?.id,
      name: _nameCtrl.text.trim(),
      category: _categoryCtrl.text.trim(),
      price: double.parse(_priceCtrl.text.replaceAll(',', '.')),
    );

    final ok = widget.isEditing
        ? await vm.updateProduct(widget.product!.id!, entity)
        : await vm.createProduct(entity);

    if (!mounted) return;
    if (ok) {
      AppNavigator.back<bool>(context, true);
    } else {
      final cs = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage),
          backgroundColor: cs.errorContainer,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<OpticsViewModel>().isSaving;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Editar producto' : 'Nuevo producto'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [cs.primaryContainer, cs.secondaryContainer],
                    ),
                  ),
                  child: Icon(
                    widget.isEditing
                        ? Icons.edit_note
                        : Icons.add_box_outlined,
                    size: 48,
                    color: cs.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 24),
                AppTextField(
                  controller: _nameCtrl,
                  label: 'Nombre del producto',
                  icon: Icons.label_outline,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Ingresa el nombre';
                    }
                    if (v.trim().length < 3) {
                      return 'Mínimo 3 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _categoryCtrl,
                  label: 'Categoría',
                  icon: Icons.category_outlined,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Ingresa la categoría';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _priceCtrl,
                  label: 'Precio',
                  icon: Icons.attach_money,
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Ingresa el precio';
                    }
                    final parsed = double.tryParse(v.replaceAll(',', '.'));
                    if (parsed == null) return 'Precio no válido';
                    if (parsed < 0) return 'No puede ser negativo';
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                AppButton(
                  label: widget.isEditing ? 'Guardar cambios' : 'Crear producto',
                  icon: Icons.save,
                  isLoading: isSaving,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}