import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sends a verification email to the current user
  Future<void> sendVerificationEmail(BuildContext context) async {
    final user = _auth.currentUser;

    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("📩 Verification email sent. Please check your inbox.")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed to send verification email: $e")),
        );
      }
    } else if (user != null && user.emailVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Your email is already verified.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ No user signed in.")),
      );
    }
  }

  /// Refreshes the user's status from Firebase
  Future<void> reloadUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
    }
  }

  /// Checks if the user's email is verified
  bool isEmailVerified() {
    final user = _auth.currentUser;
    return user?.emailVerified ?? false;
  }

  /// Refreshes verification status - call this after user clicks verification link
  Future<bool> refreshVerificationStatus() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.reload();
        return user.emailVerified;
      }
      return false;
    } catch (e) {
      print('Error refreshing verification status: $e');
      return false;
    }
  }
}
