class ApiEndpoints {
  ApiEndpoints._();

  // Switch these based on your current testing device
  static const String _emulator = '10.0.2.2';
  static const String _physical = '192.168.137.1'; // Double check this IP!

  static const String baseUrl = 'http://$_emulator:3000/api';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String userLogin = '/auth/login';
  static const String userRegister = '/auth/register';
}