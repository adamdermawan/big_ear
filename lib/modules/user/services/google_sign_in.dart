// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class GoogleSignInService {
//   static const String _baseUrl = "http://192.168.1.10:8081/api/auth"; // Update with your IP
  
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: [
//       'email',
//       'profile',
//     ],
//   );

//   Future<Map<String, dynamic>?> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
//       if (googleUser == null) {
//         // User cancelled the sign-in
//         return null;
//       }

//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
//       // You can either:
//       // 1. Send the Google token to your backend for verification
//       // 2. Or register/login the user directly with their Google info
      
//       // Option 2: Register/login with Google info
//       final response = await http.post(
//         Uri.parse('$_baseUrl/google-signin'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email': googleUser.email,
//           'name': googleUser.displayName ?? '',
//           'googleId': googleUser.id,
//           'photoUrl': googleUser.photoUrl ?? '',
//         }),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return jsonDecode(response.body);
//       } else {
//         throw Exception('Failed to authenticate with Google: ${response.body}');
//       }
//     } catch (error) {
//       print('Google Sign-In error: $error');
//       throw Exception('Google Sign-In failed: $error');
//     }
//   }

//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//   }
// }