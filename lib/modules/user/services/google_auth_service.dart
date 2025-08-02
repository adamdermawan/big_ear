
// import 'package:google_sign_in/google_sign_in.dart';

// class GoogleAuthService {
//   // Create a single instance to use throughout the class
//   static final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: [
//       'email',
//       'profile',
//       'openid',
//     ],
//     serverClientId: '102342047116-dcp6olquftfoi73g5724mmpj6vuapudn.apps.googleusercontent.com',
//   );

//   static Future<GoogleSignInAccount?> signIn() async {
//     try {
//       print('🔄 Starting Google Sign-In...');
//       // 
//       // Clear any cached sign-in state
//       //await _googleSignIn.signOut();
      
//       final GoogleSignInAccount? account = await _googleSignIn.signIn();
      
//       if (account != null) {
//         print('✅ Google Sign-In successful: ${account.email}');
        
//         // Test authentication
//         final GoogleSignInAuthentication auth = await account.authentication;
//         print('🔑 Access Token: ${auth.accessToken != null ? "✅ Got it" : "❌ Missing"}');
//         print('🔑 ID Token: ${auth.idToken != null ? "✅ Got it" : "❌ Missing"}');
        
//         if (auth.idToken == null) {
//           print('⚠️ Warning: ID Token is null - this might cause backend issues');
//         }
        
//         return account;
//       } else {
//         print('❌ Google Sign-In cancelled by user');
//         return null;
//       }
//     } catch (error) {
//       print('❌ Google Sign-In Error: $error');
//       print('❌ Error type: ${error.runtimeType}');
//       return null;
//     }
//   }

//   static Future<void> signOut() async {
//     try {
//       await _googleSignIn.signOut();
//       print('✅ Google sign-out successful');
//     } catch (error) {
//       print('❌ Google sign-out error: $error');
//       throw error; // Re-throw so caller can handle it
//     }
//   }

//   static Future<bool> isSignedIn() async {
//     try {
//       final currentUser = await _googleSignIn.signInSilently();
//       return currentUser != null;
//     } catch (error) {
//       print('❌ Error checking sign-in status: $error');
//       return false;
//     }
//   }

//   static Future<GoogleSignInAccount?> getCurrentUser() async {
//     try {
//       return await _googleSignIn.signInSilently();
//     } catch (error) {
//       print('❌ Error getting current user: $error');
//       return null;
//     }
//   }

//   static Future<String?> getIdToken() async {
//     try {
//       final GoogleSignInAccount? account = await _googleSignIn.signInSilently();
//       if (account != null) {
//         final GoogleSignInAuthentication auth = await account.authentication;
//         print('🔑 Retrieved ID token: ${auth.idToken != null ? "✅" : "❌"}');
//         return auth.idToken;
//       }
//       return null;
//     } catch (error) {
//       print('❌ Error getting ID token: $error');
//       return null;
//     }
//   }
// }