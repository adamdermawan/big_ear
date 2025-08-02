// lib/modules/items/services/spring_bed_item_service.dart
import 'dart:convert';
import 'package:big_ear/modules/shared/constants/url_path.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:big_ear/modules/items/models/spring_bed_item.dart';
import 'package:big_ear/modules/items/models/review.dart';

class SpringBedItemService {
  final _baseUrl = Uri.parse('${ApiConstants.baseUrl}/items');
  

  // Get token from SharedPreferences directly
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken'); // Use the same key as your login
  }

  Future<Map<String, String>> _getHeaders({bool includeAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (includeAuth) {
      final token = await _getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    
    return headers;
  }

  // Get all spring bed items with reviews and calculated ratings
  Future<List<SpringBedItem>> getAllItemsWithReviews() async {
    try {
      print('🔄 Fetching all items with reviews');
      
      final response = await http.get(
        _baseUrl,
        headers: await _getHeaders(includeAuth: false),
      ).timeout(const Duration(seconds: 30));

      print('📡 Get items response status: ${response.statusCode}');
      print('📡 Get items response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> itemsJson = jsonDecode(response.body);
        return itemsJson.map((json) => SpringBedItem.fromBackendJson(json)).toList();
      } else {
        throw Exception('Failed to load items: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching items: $e');
      throw Exception('Failed to fetch items: $e');
    }
  }

  // Get a specific item by ID with reviews
  Future<SpringBedItem?> getItemByIdWithReviews(int itemId) async {
    try {
      print('🔄 Fetching item: $itemId');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/$itemId'),
        headers: await _getHeaders(includeAuth: false),
      ).timeout(const Duration(seconds: 30));

      print('📡 Get item response status: ${response.statusCode}');
      print('📡 Get item response body: ${response.body}');

      if (response.statusCode == 200) {
        final itemJson = jsonDecode(response.body);
        return SpringBedItem.fromBackendJson(itemJson);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load item: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching item: $e');
      throw Exception('Failed to fetch item: $e');
    }
  }

  // Test connectivity
  Future<bool> testConnection() async {
    try {
      final response = await http.get(
        _baseUrl,
        headers: await _getHeaders(includeAuth: false),
      ).timeout(const Duration(seconds: 10));
      
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Spring bed item service connection test failed: $e');
      return false;
    }
  }
}