// // lib/modules/user/services/google_sign_in_service.dart
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'auth_service.dart';

// class GoogleSignInService {
//   final AuthService _authService = AuthService();
  
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: [
//       'email',
//       'profile',
//     ],
//     // Add this for Android - replace with your actual client ID from Google Console
//     // You need to get this from Google Cloud Console
//     // clientId: 'your-client-id.apps.googleusercontent.com',
//   );

//   Future<Map<String, dynamic>?> signInWithGoogle() async {
//     try {
//       // Sign out first to ensure clean state
//       await _googleSignIn.signOut();
      
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
//       if (googleUser == null) {
//         // User cancelled the sign-in
//         return null;
//       }

//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
//       // Prepare data for backend
//       final googleData = {
//         'email': googleUser.email,
//         'name': googleUser.displayName ?? '',
//         'googleId': googleUser.id,
//         'photoUrl': googleUser.photoUrl ?? '',
//         'accessToken': googleAuth.accessToken,
//         'idToken': googleAuth.idToken,
//       };

//       // Send to backend through AuthService
//       final result = await _authService.loginWithGoogle(googleData);
      
//       return result;
//     } catch (error) {
//       print('Google Sign-In error: $error');
//       throw Exception('Google Sign-In failed: $error');
//     }
//   }

//   Future<void> signOut() async {
//     try {
//       await _googleSignIn.signOut();
//       await _authService.logout();
//       print('✅ Google sign out successful');
//     } catch (error) {
//       print('❌ Google sign out error: $error');
//       throw Exception('Google sign out failed: $error');
//     }
//   }

//   Future<bool> isSignedIn() async {
//     return await _googleSignIn.isSignedIn();
//   }

//   Future<GoogleSignInAccount?> getCurrentUser() async {
//     return _googleSignIn.currentUser;
//   }
// }