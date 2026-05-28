import 'package:http/http.dart' as http;

class ApiClient {
  // Singleton pattern para una única instancia
  ApiClient._privateConstructor();
  static final ApiClient instance = ApiClient._privateConstructor();

  final http.Client client = http.Client();
  
  
  final String baseUrl = 'https://backendapptransaccional.onrender.com/api'; 
}