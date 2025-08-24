import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendSignInLink(String email) async {
    try {
      ActionCodeSettings actionCodeSettings = ActionCodeSettings(
        url:
            'https://my-firebase-app-8a8bc.firebaseapp.com/signin', // ✅ Use your Firebase auth domain
        handleCodeInApp: true,
        androidPackageName: 'com.example.my_firebase_app',
        androidInstallApp: true,
        androidMinimumVersion: '21',
        iOSBundleId: 'com.example.myFirebaseApp',
      );

      await _auth.sendSignInLinkToEmail(
        email: email,
        actionCodeSettings: actionCodeSettings,
      );

      print("✅ Sign-in link sent to $email");
    } catch (e) {
      print("❌ Error sending sign-in link: $e");
      rethrow;
    }
  }

  Future<UserCredential> signInWithEmailLink(String email, String link) async {
    try {
      if (_auth.isSignInWithEmailLink(link)) {
        return await _auth.signInWithEmailLink(email: email, emailLink: link);
      } else {
        throw Exception("Invalid email sign-in link");
      }
    } catch (e) {
      print("❌ Error signing in with email link: $e");
      rethrow;
    }
  }

  User? get currentUser => _auth.currentUser;

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
