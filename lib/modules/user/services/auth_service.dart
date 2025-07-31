import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // 👇 IMPORTANT: Replace with your computer's local IP address
  // Find your IP by running 'ipconfig' (Windows) or 'ifconfig' (Mac/Linux)
  static const String _baseUrl = "http://192.168.100.194:8081/api/auth";
  static const String _tokenKey = 'authToken';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<Map<String, String>> _getHeaders({bool includeAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    
    if (includeAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: await _getHeaders(),
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await saveToken(data['token']); // Save token locally
        return data;
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      print('Login error: $e');
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: await _getHeaders(),
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      print('Register response status: ${response.statusCode}');
      print('Register response body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await saveToken(data['token']); // Save token locally
        return data;
      } else {
        throw Exception('Failed to register: ${response.body}');
      }
    } catch (e) {
      print('Register error: $e');
      throw Exception('Network error: $e');
    }
  }

  // Method to make authenticated requests to other endpoints
  Future<http.Response> authenticatedRequest({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    final headers = await _getHeaders(includeAuth: true);
    final uri = Uri.parse('http://192.168.1.10:8081$endpoint');

    switch (method.toUpperCase()) {
      case 'GET':
        return await http.get(uri, headers: headers);
      case 'POST':
        return await http.post(uri, headers: headers, body: body != null ? jsonEncode(body) : null);
      case 'PUT':
        return await http.put(uri, headers: headers, body: body != null ? jsonEncode(body) : null);
      case 'DELETE':
        return await http.delete(uri, headers: headers);
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
  }

  Future<void> logout() async {
    await removeToken();
  }
}