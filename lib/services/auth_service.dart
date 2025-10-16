import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_config.dart';
import '../models/user_model.dart';

class AuthService {
  Future<User> login({required String email, required String password}) async {
    // Backend login Anda membaca body JSON
    final response = await http.post(
      ApiConfig.loginUrl(),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    final Map<String, dynamic> data = _decodeResponse(response);
    if (data['status'] == 'success') {
      final dynamic userJson = data['data'] ?? data['user'];
      return User.fromJson((userJson as Map).cast<String, dynamic>());
    }
    throw Exception(data['message'] ?? 'Login gagal');
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      ApiConfig.registerUrl(),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        // Backend Anda mengharapkan body JSON dengan field 'nama'
        "nama": name,
        "email": email,
        "password": password,
      }),
    );

    final Map<String, dynamic> data = _decodeResponse(response);
    if (data['status'] == 'success') {
      return; // API hanya mengembalikan status/message
    }
    throw Exception(data['message'] ?? 'Register gagal');
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    final String body = response.body.trim();
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('HTTP ${response.statusCode}: ${_short(body)}');
    }
    try {
      // Bersihkan kemungkinan BOM/whitespace
      final String cleaned = body.replaceFirst(RegExp(r"^[\uFEFF\u200B]+"), '');
      final dynamic decoded = jsonDecode(cleaned);
      if (decoded is Map) {
        return decoded.cast<String, dynamic>();
      }
      return {"status": "error", "message": "Format JSON tidak sesuai"};
    } catch (_) {
      // Jika bukan JSON, coba heuristik sederhana: status sukses bila ada kata 'success'
      if (body.toLowerCase().contains('success')) {
        return {"status": "success", "data": {}};
      }
      throw Exception('Respon server tidak valid: ${_short(body)}');
    }
  }

  String _short(String s) => s.length > 140 ? s.substring(0, 140) + '…' : s;
}
