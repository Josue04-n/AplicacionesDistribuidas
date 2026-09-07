class ApiConfig {
  // Cambia esta IP y puerto por los de tu API
  //static const String baseUrl = 'http://10.154.217.3:5050'; Josue
  static const String baseUrl = 'http://192.168.1.190:5050';
  static const String apiPath = '/api/medicity/distribuida';

  static String get fullUrl => '$baseUrl$apiPath';
}
