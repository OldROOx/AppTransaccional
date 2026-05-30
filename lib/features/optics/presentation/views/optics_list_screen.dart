import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/assets/app_assets.dart';
import '../../../../core/routes/app_navigator.dart';
import '../../../../core/session/session_manager.dart';
import '../../../../core/state/view_state.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../domain/entities/optic_product_entity.dart';
import '../viewmodels/optics_viewmodel.dart';

/// Pantalla principal del inventario.
///
/// Usa CustomScrollView con SliverAppBar (banner desde assets), un ListView
/// horizontal de chips para filtrar por categoría, y una SliverGrid de cards
/// con Stack para badges. Las cards aparecen con un fade+slide-up sutil.
///
/// Flujo de navegación simplificado y directo:
///   - tap en card           → form en modo EDITAR
///   - icono basurero card   → diálogo de confirmar y borrar
///   - FAB "Nuevo"           → form en modo CREAR
///
/// Todo el color sale del Theme, no hay Colors.<nombre> hardcodeados.
class OpticsListScreen extends StatefulWidget {
  const OpticsListScreen({super.key});

  @override
  State<OpticsListScreen> createState() => _OpticsListScreenState();
}

class _OpticsListScreenState extends State<OpticsListScreen> {
  @override
  void initState() {
    super.initState();
    // Diferimos la llamada para no tocar Provider durante build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OpticsViewModel>().fetchProducts();
    });
  }

  void _logout() {
    context.read<AuthViewModel>().logout();
    AppNavigator.toLogin(context);
  }

  Future<void> _refresh() => context.read<OpticsViewModel>().fetchProducts();

  /// Navega al formulario en modo crear.
  Future<void> _openCreate() async {
    final saved = await AppNavigator.toOpticsForm(context);
    if (saved == true && mounted) {
      final cs = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Producto agregado'),
          backgroundColor: cs.tertiaryContainer,
        ),
      );
    }
  }

  /// Navega al formulario en modo editar con el producto seleccionado.
  Future<void> _openEdit(OpticProductEntity product) async {
    final saved = await AppNavigator.toOpticsForm(context, product: product);
    if (saved == true && mounted) {
      final cs = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Producto actualizado'),
          backgroundColor: cs.tertiaryContainer,
        ),
      );
    }
  }

  /// Pregunta al usuario y borra el producto si confirma.
  Future<void> _confirmDelete(OpticProductEntity product) async {
    final cs = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dCtx) => AlertDialog(
        title: const Text('¿Eliminar producto?'),
        content: Text('Esta acción no se puede deshacer.\n\n${product.name}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dCtx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: cs.error,
              foregroundColor: cs.onError,
            ),
            onPressed: () => Navigator.of(dCtx).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final ok =
    await context.read<OpticsViewModel>().deleteProduct(product.id!);
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Producto eliminado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OpticsViewModel>();
    final cs = Theme.of(context).colorScheme;
    final user = SessionManager().currentUser;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          slivers: [
            // ---------- SliverAppBar con banner desde assets ----------
            SliverAppBar(
              expandedHeight: 180,
              pinned: true,
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              actions: [
                IconButton(
                  tooltip: 'Cerrar sesión',
                  icon: const Icon(Icons.logout),
                  onPressed: _logout,
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Inventario óptico',
                  style: TextStyle(color: cs.onPrimary),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      AppAssets.banner,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            cs.primary.withValues(alpha: 0.85),
                            cs.primaryContainer.withValues(alpha: 0.70),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Hola, ${user?.name.split(' ').first ?? 'usuario'}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: cs.onPrimary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ..._buildBodySlivers(vm, cs),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreate,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo'),
      ),
    );
  }

  List<Widget> _buildBodySlivers(OpticsViewModel vm, ColorScheme cs) {
    if (vm.state == ViewState.loading && vm.products.isEmpty) {
      return [
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    if (vm.state == ViewState.error && vm.products.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: cs.error),
                const SizedBox(height: 16),
                Text(
                  vm.errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: cs.onSurface),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _refresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reintentar'),
                ),
              ],
            ),
          ),
        ),
      ];
    }

    if (vm.products.isEmpty) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppAssets.emptyState,
                    width: 160,
                    height: 160,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.inventory_2_outlined,
                      size: 96,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No hay productos registrados',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Toca el botón + para agregar el primero',
                    style:
                    Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ];
    }

    return [
      SliverToBoxAdapter(child: _CategoryChips()),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 100),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.82,
          ),
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final product = vm.visibleProducts[index];
              return _ProductCard(
                product: product,
                onTap: () => _openEdit(product),
                onDelete: () => _confirmDelete(product),
              );
            },
            childCount: vm.visibleProducts.length,
          ),
        ),
      ),
    ];
  }
}

// ---------------------------------------------------------------------------
// Subwidgets internos a esta pantalla
// ---------------------------------------------------------------------------

/// Lista horizontal de chips para filtrar por categoría. Usa ListView.
class _CategoryChips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OpticsViewModel>();
    final cs = Theme.of(context).colorScheme;
    final categories = vm.categories;

    if (categories.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: const Text('Todas'),
              selected: vm.selectedCategory == null,
              onSelected: (_) => vm.selectCategory(null),
              selectedColor: cs.primaryContainer,
            ),
          ),
          for (final cat in categories)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(cat),
                selected: vm.selectedCategory == cat,
                onSelected: (_) => vm.selectCategory(
                  vm.selectedCategory == cat ? null : cat,
                ),
                selectedColor: cs.primaryContainer,
              ),
            ),
        ],
      ),
    );
  }
}

/// Tarjeta visual de un producto. Card + Stack (con badge de categoría y
/// botón de eliminar posicionados), íconos y tipografía del tema.
/// Aparece con un fade+slide-up sutil (TweenAnimationBuilder).
class _ProductCard extends StatelessWidget {
  final OpticProductEntity product;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ProductCard({
    required this.product,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 12),
            child: child,
          ),
        );
      },
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // Header con icono.
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            cs.primaryContainer,
                            cs.secondaryContainer,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          _iconForCategory(product.category),
                          size: 56,
                          color: cs.onPrimaryContainer,
                        ),
                      ),
                    ),
                    // Badge de categoría arriba a la derecha.
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: cs.surface.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          product.category,
                          style: text.labelSmall?.copyWith(
                            color: cs.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    // Botón de eliminar arriba a la izquierda.
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Material(
                        color: cs.surface.withValues(alpha: 0.85),
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: onDelete,
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: cs.error,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: text.titleMedium?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForCategory(String category) {
    final c = category.toLowerCase();
    if (c.contains('armaz')) return Icons.visibility;
    if (c.contains('contacto') || c.contains('lente')) return Icons.lens;
    if (c.contains('sol')) return Icons.wb_sunny;
    return Icons.remove_red_eye;
  }
}