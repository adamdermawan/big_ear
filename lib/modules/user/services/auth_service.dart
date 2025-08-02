import 'dart:convert';
import 'package:big_ear/modules/shared/constants/url_path.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final _baseUrl = Uri.parse('${ApiConstants.baseUrl}/auth');
  static const String _tokenKey = 'authToken';
  static const String _userKey = 'userData';
  static const String _guestModeKey = 'isGuestMode';
  static const String _userTypeKey = 'userType'; 

  // Token management
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
    await prefs.remove(_userKey);
    await prefs.remove(_guestModeKey);
    await prefs.remove(_userTypeKey);
  }

  // Guest mode management
  Future<void> setGuestMode(bool isGuest) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_guestModeKey, isGuest);
    if (isGuest) {
      await prefs.setString(_userTypeKey, 'guest');
      // Clear any existing auth data when entering guest mode
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
    }
  }

  Future<bool> isGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_guestModeKey) ?? false;
  }

  Future<String> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTypeKey) ?? 'guest';
  }

  Future<void> setUserType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userTypeKey, type);
  }

  // User data management
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    if (userData != null) {
      return jsonDecode(userData);
    }
    return null;
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(userData));
  }

  // Check if user is authenticated (NOT guest)
  Future<bool> isAuthenticated() async {
    final isGuest = await isGuestMode();
    if (isGuest) return false;
    
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Check if user can write reviews (must be logged in, not guest)
  Future<bool> canWriteReviews() async {
    final isGuest = await isGuestMode();
    if (isGuest) return false;
    
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Get headers for API calls
  Future<Map<String, String>> getHeaders({bool includeAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (includeAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }

  // Login as guest
  Future<Map<String, dynamic>> loginAsGuest() async {
    try {
      // Clear any existing auth data
      await removeToken();
      
      // Set guest mode
      await setGuestMode(true);
      await setUserType('guest');
      
      print('✅ Logged in as guest');
      
      return {
        'success': true,
        'message': 'Logged in as guest',
        'userType': 'guest',
        'user': {
          'name': 'Guest',
          'email': 'guest@local',
          'type': 'guest'
        }
      };
    } catch (e) {
      print('❌ Guest login error: $e');
      throw Exception('Failed to login as guest: $e');
    }
  }

  // Login method
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('🔄 Attempting login to: $_baseUrl/login');
      print('📧 Email: $email');
      
      // First clear guest mode
      await setGuestMode(false);
      
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: await getHeaders(),
        body: jsonEncode({
          'email': email.trim().toLowerCase(), 
          'password': password
        }),
      ).timeout(const Duration(seconds: 30));
      
      print('📡 Login response status: ${response.statusCode}');
      print('📡 Login response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Save token if it exists
        if (data['token'] != null) {
          await saveToken(data['token']);
          await setUserType('regular');
          print('✅ Token saved successfully');
        }
        
        // Save user data if it exists
        if (data['user'] != null) {
          await saveUserData(data['user']);
          print('✅ User data saved successfully');
        }
        
        return data;
      } else if (response.statusCode == 401) {
        throw Exception('Invalid credentials');
      } else if (response.statusCode == 404) {
        throw Exception('Login endpoint not found. Check your server URL.');
      } else {
        throw Exception('Server error: ${response.statusCode} - ${response.body}');
      }
    } on http.ClientException catch (e) {
      print('❌ Network error: $e');
      throw Exception('Network error: Cannot connect to server. Please check your internet connection and server status.');
    } on FormatException catch (e) {
      print('❌ JSON parsing error: $e');
      throw Exception('Invalid response from server');
    } catch (e) {
      print('❌ Login error: $e');
      throw Exception('Login failed: $e');
    }
  }

  // Google Sign In
  Future<Map<String, dynamic>> loginWithGoogle(Map<String, dynamic> googleData) async {
    try {
      print('🔄 Attempting Google login');
      
      // First clear guest mode
      await setGuestMode(false);
      
      final response = await http.post(
        Uri.parse('$_baseUrl/google-signin'),
        headers: await getHeaders(),
        body: jsonEncode(googleData),
      ).timeout(const Duration(seconds: 30));
      
      print('📡 Google login response status: ${response.statusCode}');
      print('📡 Google login response body: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        
        // Save token if it exists
        if (data['token'] != null) {
          await saveToken(data['token']);
          await setUserType('google');
          print('✅ Google login token saved successfully');
        }
        
        // Save user data if it exists
        if (data['user'] != null) {
          await saveUserData(data['user']);
          print('✅ Google user data saved successfully');
        }
        
        return data;
      } else {
        throw Exception('Google login failed: ${response.body}');
      }
    } catch (e) {
      print('❌ Google login error: $e');
      throw Exception('Google login failed: $e');
    }
  }

  // Register method
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      print('🔄 Attempting registration to: $_baseUrl/register');
      print('📧 Email: $email');
      print('👤 Name: $name');
      
      // First clear guest mode
      await setGuestMode(false);
      
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: await getHeaders(),
        body: jsonEncode({
          'name': name.trim(),
          'email': email.trim().toLowerCase(),
          'password': password
        }),
      ).timeout(const Duration(seconds: 30));
      
      print('📡 Register response status: ${response.statusCode}');
      print('📡 Register response body: ${response.body}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Save token if it exists
        if (data['token'] != null) {
          await saveToken(data['token']);
          await setUserType('regular');
          print('✅ Registration successful, token saved');
        }
        
        // Save user data if it exists
        if (data['user'] != null) {
          await saveUserData(data['user']);
          print('✅ User data saved successfully');
        }
        
        return data;
      } else if (response.statusCode == 409) {
        throw Exception('Email already exists');
      } else if (response.statusCode == 400) {
        throw Exception('Invalid registration data');
      } else if (response.statusCode == 404) {
        throw Exception('Registration endpoint not found. Check your server URL.');
      } else {
        throw Exception('Server error: ${response.statusCode} - ${response.body}');
      }
    } on http.ClientException catch (e) {
      print('❌ Network error: $e');
      throw Exception('Network error: Cannot connect to server. Please check your internet connection and server status.');
    } on FormatException catch (e) {
      print('❌ JSON parsing error: $e');
      throw Exception('Invalid response from server');
    } catch (e) {
      print('❌ Register error: $e');
      throw Exception('Registration failed: $e');
    }
  }

  // NEW: Update user profile
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String email,
  }) async {
    try {
      print('🔄 Attempting profile update');
      print('📧 New Email: $email');
      print('👤 New Name: $name');
      
      final response = await http.put(
        Uri.parse('$_baseUrl/profile'),
        headers: await getHeaders(includeAuth: true),
        body: jsonEncode({
          'name': name.trim(),
          'email': email.trim().toLowerCase(),
        }),
      ).timeout(const Duration(seconds: 30));
      
      print('📡 Profile update response status: ${response.statusCode}');
      print('📡 Profile update response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        
        // Update stored user data
        await saveUserData(userData);
        print('✅ Profile updated successfully');
        
        return {
          'success': true,
          'user': userData,
          'message': 'Profile updated successfully'
        };
      } else if (response.statusCode == 401) {
        throw Exception('Authentication required');
      } else if (response.statusCode == 409) {
        throw Exception('Email is already taken');
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Invalid data');
      } else {
        throw Exception('Server error: ${response.statusCode} - ${response.body}');
      }
    } on http.ClientException catch (e) {
      print('❌ Network error: $e');
      throw Exception('Network error: Cannot connect to server');
    } on FormatException catch (e) {
      print('❌ JSON parsing error: $e');
      throw Exception('Invalid response from server');
    } catch (e) {
      print('❌ Profile update error: $e');
      throw Exception('Profile update failed: $e');
    }
  }

  // NEW: Change password
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      print('🔄 Attempting password change');
      
      final response = await http.put(
        Uri.parse('$_baseUrl/change-password'),
        headers: await getHeaders(includeAuth: true),
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      ).timeout(const Duration(seconds: 30));
      
      print('📡 Password change response status: ${response.statusCode}');
      print('📡 Password change response body: ${response.body}');
      
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('✅ Password changed successfully');
        
        return {
          'success': true,
          'message': responseData['message'] ?? 'Password changed successfully'
        };
      } else if (response.statusCode == 401) {
        final errorData = jsonDecode(response.body);
        if (errorData['error'] == 'Current password is incorrect') {
          throw Exception('Current password is incorrect');
        }
        throw Exception('Authentication required');
      } else if (response.statusCode == 400) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Invalid data');
      } else {
        throw Exception('Server error: ${response.statusCode} - ${response.body}');
      }
    } on http.ClientException catch (e) {
      print('❌ Network error: $e');
      throw Exception('Network error: Cannot connect to server');
    } on FormatException catch (e) {
      print('❌ JSON parsing error: $e');
      throw Exception('Invalid response from server');
    } catch (e) {
      print('❌ Password change error: $e');
      throw Exception('Password change failed: $e');
    }
  }

  // Logout method
  Future<void> logout() async {
    await removeToken();
    print('✅ User logged out');
  }

  // Make authenticated requests to other endpoints
  Future<http.Response> authenticatedRequest({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    final headers = await getHeaders(includeAuth: true);
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    
    try {
      switch (method.toUpperCase()) {
        case 'GET':
          return await http.get(uri, headers: headers).timeout(const Duration(seconds: 30));
        case 'POST':
          return await http.post(uri, headers: headers, body: body != null ? jsonEncode(body) : null).timeout(const Duration(seconds: 30));
        case 'PUT':
          return await http.put(uri, headers: headers, body: body != null ? jsonEncode(body) : null).timeout(const Duration(seconds: 30));
        case 'DELETE':
          return await http.delete(uri, headers: headers).timeout(const Duration(seconds: 30));
        default:
          throw Exception('Unsupported HTTP method: $method');
      }
    } catch (e) {
      print('❌ Authenticated request error: $e');
      rethrow;
    }
  }

  // Test connectivity to your server
  Future<bool> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl} + /test'),
      ).timeout(const Duration(seconds: 10));
      
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Connection test failed: $e');
      return false;
    }
  }
}