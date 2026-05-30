/// Rutas centralizadas a los assets de la app.
///
/// Tenerlas aquí evita strings sueltos como `'assets/images/logo.png'`
/// repartidos por la UI: si renombras un archivo solo cambias un lugar.
class AppAssets {
  AppAssets._();

  static const String _images = 'assets/images';

  static const String logo = '$_images/logo.png';
  static const String banner = '$_images/banner.jpg';
  static const String emptyState = '$_images/empty_state.png';
}
