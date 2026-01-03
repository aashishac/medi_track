import 'package:firebase_auth/firebase_auth.dart';

Exception handleAuthException(FirebaseAuthException e) {
  switch (e.code) {
    case "user-not-found":
      return Exception("No user found with this email");

    case "wrong-password":
      return Exception("Incorrect password provided");

    case "email-already-in-use":
      return Exception("An account already exists for this email");

    case "invalid-email":
      return Exception("The email address is not valid.");

    case "weak-password":
      return Exception("This password is too week");
    default:
      return Exception(e.message ?? "Authentication failed");
  }
}
