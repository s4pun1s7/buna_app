import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      debugPrint('Google sign-in: started');
      if (kIsWeb) {
        debugPrint('Google sign-in: running on web');
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
        final result = await _auth.signInWithPopup(googleProvider);
        debugPrint('Google sign-in: signInWithPopup complete');
        final idToken = await result.user?.getIdToken();
        final accessToken = result.credential is OAuthCredential
            ? (result.credential as OAuthCredential).accessToken
            : null;
        await _saveCredentials(idToken, accessToken);
        return result;
      } else {
        debugPrint('Google sign-in: running on mobile');
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        debugPrint(
          'Google sign-in: googleUser = ' + (googleUser?.email ?? 'null'),
        );
        if (googleUser == null) {
          debugPrint('Google sign-in: user cancelled');
          return null;
        }
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        debugPrint('Google sign-in: got authentication');
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        debugPrint('Google sign-in: credential created');
        final result = await _auth.signInWithCredential(credential);
        debugPrint('Google sign-in: signInWithCredential complete');
        // Save credentials
        await _saveCredentials(googleAuth.idToken, googleAuth.accessToken);
        return result;
      }
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      rethrow;
    }
  }

  /// Sign in anonymously
  Future<UserCredential> signInAnonymously() async {
    final result = await _auth.signInAnonymously();
    // Save credentials (anonymous users only have a Firebase ID token)
    final idToken = await result.user?.getIdToken();
    await _saveCredentials(idToken, null);
    return result;
  }

  /// Save credentials (idToken, accessToken) to SharedPreferences
  Future<void> _saveCredentials(String? idToken, String? accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    if (idToken != null) {
      await prefs.setString('auth_id_token', idToken);
    }
    if (accessToken != null) {
      await prefs.setString('auth_access_token', accessToken);
    }
  }

  /// Retrieve saved credentials
  static Future<Map<String, String?>> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final idToken = prefs.getString('auth_id_token');
    final accessToken = prefs.getString('auth_access_token');
    return {'idToken': idToken, 'accessToken': accessToken};
  }

  /// Clear saved credentials
  static Future<void> clearSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_id_token');
    await prefs.remove('auth_access_token');
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await clearSavedCredentials();
  }

  /// Get current user
  User? get currentUser => _auth.currentUser;

  /// Handle Google sign-in redirect result (web only)
  Future<UserCredential?> getGoogleRedirectResult() async {
    if (kIsWeb) {
      try {
        final result = await _auth.getRedirectResult();
        if (result.user != null) {
          debugPrint(
            'Google sign-in: redirect result user = \\${result.user!.email}',
          );
          return result;
        }
      } catch (e) {
        debugPrint('Google sign-in redirect error: \\${e.toString()}');
        rethrow;
      }
    }
    return null;
  }
}
