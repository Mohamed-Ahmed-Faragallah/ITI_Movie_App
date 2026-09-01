import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? error;

  Future<void> register({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    error = await _authService.registerWithEmail(
      email: email,
      password: password,
    );

    isLoading = false;
    notifyListeners();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    error = await _authService.loginWithEmail(
      email: email,
      password: password,
    );

    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }
}