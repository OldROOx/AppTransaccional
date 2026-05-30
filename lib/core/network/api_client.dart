import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../session/session_manager.dart';
import 'api_exception.dart';

/// Cliente HTTP centralizado.
///
/// Cumple dos requisitos clave del proyecto:
///   1. **Una única instancia de http** — Singleton; todos los datasources
///      reutilizan el mismo [http.Client], evitando fugas y conexiones extra.
///   2. **Centraliza** método, headers, parsing y manejo de status codes
///      para que los datasources sean pequeños y no repitan lógica de red.
class ApiClient {
  // ---- Singleton ----
  ApiClient._internal();
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  /// URL base de la API RESTful desplegada en Render.
  static const String baseUrl =
      'https://backendapptransaccional.onrender.com/api';

  /// Único cliente http de la app.
  final http.Client _client = http.Client();

  /// Construye los headers comunes. Si hay token activo en la sesión,
  /// lo agrega como Bearer para las rutas autenticadas.
  Map<String, String> _headers() {
    final h = <String, String>{'Content-Type': 'application/json'};
    final token = SessionManager().token;
    if (token != null && token.isNotEmpty) {
      h['Authorization'] = 'Bearer $token';
    }
    return h;
  }

  Future<dynamic> get(String path) =>
      _send(() => _client.get(Uri.parse('$baseUrl$path'), headers: _headers()));

  Future<dynamic> post(String path, Map<String, dynamic> body) =>
      _send(() => _client.post(
            Uri.parse('$baseUrl$path'),
            headers: _headers(),
            body: jsonEncode(body),
          ));

  Future<dynamic> put(String path, Map<String, dynamic> body) =>
      _send(() => _client.put(
            Uri.parse('$baseUrl$path'),
            headers: _headers(),
            body: jsonEncode(body),
          ));

  Future<dynamic> delete(String path) => _send(
      () => _client.delete(Uri.parse('$baseUrl$path'), headers: _headers()));

  /// Ejecuta la petición y atrapa errores de red comunes.
  Future<dynamic> _send(Future<http.Response> Function() request) async {
    try {
      final response = await request();
      return _process(response);
    } on SocketException {
      throw const ApiException('Sin conexión a internet. Revisa tu red.');
    } on http.ClientException {
      throw const ApiException('Error de comunicación con el servidor.');
    } on FormatException {
      throw const ApiException('Respuesta del servidor con formato inválido.');
    }
  }

  /// Decodifica el JSON y diferencia éxito (2xx) vs error.
  dynamic _process(http.Response response) {
    final hasBody = response.body.isNotEmpty;
    final decoded = hasBody ? jsonDecode(response.body) : null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    String message = 'Error ${response.statusCode}';
    if (decoded is Map && decoded['detail'] != null) {
      message = decoded['detail'].toString();
    } else if (decoded is Map && decoded['message'] != null) {
      message = decoded['message'].toString();
    }
    throw ApiException(message, statusCode: response.statusCode);
  }
}
