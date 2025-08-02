// lib/modules/items/services/review_service.dart
import 'dart:convert';
import 'package:big_ear/modules/shared/constants/url_path.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:big_ear/modules/items/models/review.dart';

class ReviewService {
  final _baseUrl = Uri.parse('${ApiConstants.baseUrl}/reviews');

  // Get token from SharedPreferences directly
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken'); // Use the same key as your login
  }

  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
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
  

  // Check if user is authenticated
  Future<bool> isUserAuthenticated() async {
    final token = await _getToken();
    return token != null && token.isNotEmpty;
  }

  // Get all reviews for a specific item
  Future<List<Review>> getReviewsByItemId(int itemId) async {
    try {
      print('🔄 Fetching reviews for item: $itemId');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/springbeditem/$itemId'),
        headers: await _getHeaders(includeAuth: false), // Reviews can be viewed without auth
      ).timeout(const Duration(seconds: 30));

      print('📡 Get reviews response status: ${response.statusCode}');
      print('📡 Get reviews response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> reviewsJson = jsonDecode(response.body);
        return reviewsJson.map((json) => Review.fromBackendJson(json)).toList();
      } else {
        throw Exception('Failed to load reviews: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching reviews: $e');
      throw Exception('Failed to fetch reviews: $e');
    }
  }

  // Create a new review
  Future<Review> createReview({
    required int itemId, 
    required double rating, 
    required String comment
  }) async {
    try {
      // Check if user is authenticated
      final token = await _getToken();
      if (token == null) {
        throw Exception('Authentication required. Please login to submit a review.');
      }

      print('🔄 Creating review for item: $itemId');
      print('⭐ Rating: $rating');
      print('💬 Comment: $comment');
      
      final response = await http.post(
        _baseUrl,
        headers: await _getHeaders(),
        body: jsonEncode({
          'itemId': itemId,
          'rating': rating,
          'comment': comment,
        }),
      ).timeout(const Duration(seconds: 30));

      print('📡 Create review response status: ${response.statusCode}');
      print('📡 Create review response body: ${response.body}');

      if (response.statusCode == 201) {
        final reviewJson = jsonDecode(response.body);
        return Review.fromBackendJson(reviewJson);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication required. Please login to submit a review.');
      } else if (response.statusCode == 400) {
        final errorBody = jsonDecode(response.body);
        throw Exception(errorBody.toString());
      } else {
        throw Exception('Failed to create review: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error creating review: $e');
      rethrow;
    }
  }

  // Update an existing review
  Future<Review> updateReview(int reviewId, double rating, String comment) async {
    try {
      // Check if user is authenticated
      final token = await _getToken();
      if (token == null) {
        throw Exception('Authentication required. Please login to update the review.');
      }

      print('🔄 Updating review: $reviewId');
      print('⭐ New rating: $rating');
      print('💬 New comment: $comment');
      
      final response = await http.put(
        Uri.parse('$_baseUrl/$reviewId'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'rating': rating,
          'comment': comment,
        }),
      ).timeout(const Duration(seconds: 30));

      print('📡 Update review response status: ${response.statusCode}');
      print('📡 Update review response body: ${response.body}');

      if (response.statusCode == 200) {
        final reviewJson = jsonDecode(response.body);
        return Review.fromBackendJson(reviewJson);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication required. Please login to update the review.');
      } else if (response.statusCode == 403) {
        throw Exception('You can only update your own reviews.');
      } else if (response.statusCode == 404) {
        throw Exception('Review not found.');
      } else {
        final errorBody = response.body;
        throw Exception('Failed to update review: $errorBody');
      }
    } catch (e) {
      print('❌ Error updating review: $e');
      rethrow;
    }
  }

  // Delete a review
  Future<void> deleteReview(int reviewId) async {
    try {
      // Check if user is authenticated
      final token = await _getToken();
      if (token == null) {
        throw Exception('Authentication required. Please login to delete the review.');
      }

      print('🔄 Deleting review: $reviewId');
      
      final response = await http.delete(
        Uri.parse('$_baseUrl/$reviewId'),
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 30));

      print('📡 Delete review response status: ${response.statusCode}');
      print('📡 Delete review response body: ${response.body}');

      if (response.statusCode == 204) {
        print('✅ Review deleted successfully');
      } else if (response.statusCode == 401) {
        throw Exception('Authentication required. Please login to delete the review.');
      } else if (response.statusCode == 403) {
        throw Exception('You can only delete your own reviews.');
      } else if (response.statusCode == 404) {
        throw Exception('Review not found.');
      } else {
        final errorBody = response.body;
        throw Exception('Failed to delete review: $errorBody');
      }
    } catch (e) {
      print('❌ Error deleting review: $e');
      rethrow;
    }
  }

  // Get current user's reviews
  Future<List<Review>> getCurrentUserReviews() async {
    try {
      // Check if user is authenticated
      final token = await _getToken();
      if (token == null) {
        throw Exception('Authentication required. Please login to view your reviews.');
      }

      print('🔄 Fetching current user reviews');
      
      final response = await http.get(
        Uri.parse('$_baseUrl/user/my-reviews'),
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 30));

      print('📡 Get user reviews response status: ${response.statusCode}');
      print('📡 Get user reviews response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> reviewsJson = jsonDecode(response.body);
        return reviewsJson.map((json) => Review.fromBackendJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Authentication required. Please login to view your reviews.');
      } else {
        throw Exception('Failed to load user reviews: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching user reviews: $e');
      throw Exception('Failed to fetch user reviews: $e');
    }
  }

  // Check if user has already reviewed an item
  Future<Review?> getUserReviewForItem(int itemId) async {
    try {
      // Check if user is authenticated
      final token = await _getToken();
      if (token == null) {
        return null; // User not authenticated, so no review exists
      }

      final userReviews = await getCurrentUserReviews();
      
      // Find review for specific item
      for (final review in userReviews) {
        if (review.itemId == itemId) {
          return review;
        }
      }
      
      return null; // No review found for this item
    } catch (e) {
      print('❌ Error checking user review for item: $e');
      return null;
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
      print('❌ Review service connection test failed: $e');
      return false;
    }
  }
}