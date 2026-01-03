import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditrack/core/utils/helper_function.dart';

class AuthService {
  // Create an instance of firebase auth
  final _auth = FirebaseAuth.instance;

  // Auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Login status checker
  bool get isLoggedIn => _auth.currentUser != null;

  /// Sign Up (Create Account)
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
  }) async {
    try {
      // create user in firebase auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      // update user's display name and phone number
      if (user != null) {
        await user.updateDisplayName(name);

        // reload to reflect the change
        await user.reload();
      }
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e);
    } catch (e) {
      throw Exception("An unknown error occured during sign up");
    }
  }

  /// Login
  Future<void> login({required String email, required String password}) async {
    try {
      // login user
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e);
    } catch (e) {
      throw Exception("An unknown error occured during login");
    }
  }

  /// Log out
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Forgot password
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw handleAuthException(e);
    }
  }
}
