import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';

import 'firebase_options.dart';
import 'app_state.dart';
import 'home_page.dart';
import 'src/register_page.dart'; // import your register page
import 'src/email_link_signin_page.dart'; // import email link signin page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Handle email link authentication for web platform
  if (kIsWeb) {
    await _handleEmailLinkAuthentication();
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ApplicationState(),
      child: const BudgetTrackerApp(),
    ),
  );
}

Future<void> _handleEmailLinkAuthentication() async {
  try {
    // Check if the URL contains an email link
    final url = Uri.base.toString();

    // Handle email verification links
    if (url.contains('mode=verifyEmail')) {
      print('🔍 Processing email verification link...');
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload(); // This updates the emailVerified status
        print('✅ User reloaded, email verified: ${user.emailVerified}');
      }
      return;
    }

    // Handle email sign-in links (existing code)
    if (FirebaseAuth.instance.isSignInWithEmailLink(url)) {
      // Try to get the email from localStorage (where it was stored when sending the link)
      final email = _getEmailFromStorage();

      if (email != null) {
        // Complete the sign-in with the email link
        final userCredential = await FirebaseAuth.instance.signInWithEmailLink(
          email: email,
          emailLink: url,
        );

        print(
            '✅ Successfully signed in with email link: ${userCredential.user?.email}');

        // Clear the stored email
        _clearStoredEmail();
      } else {
        print('⚠️ Email not found in storage for email link authentication');
      }
    }
  } catch (e) {
    print('❌ Error handling email link authentication: $e');
  }
}

String? _getEmailFromStorage() {
  // For web, we can use window.localStorage to store the email
  // This is a simplified implementation - in a real app, you'd use proper storage
  try {
    return null; // Placeholder - would implement proper storage
  } catch (e) {
    return null;
  }
}

void _clearStoredEmail() {
  // Clear the stored email
  try {
    // Implementation for clearing stored email
  } catch (e) {
    print('Error clearing stored email: $e');
  }
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'sign-in',
          builder: (context, state) => SignInScreen(
            actions: [
              ForgotPasswordAction((context, email) {
                final uri = Uri(
                  path: '/sign-in/forgot-password',
                  queryParameters: {'email': email},
                );
                context.push(uri.toString());
              }),
              AuthStateChangeAction((context, state) {
                final user = switch (state) {
                  SignedIn s => s.user,
                  UserCreated c => c.credential.user,
                  _ => null,
                };
                if (user == null) return;
                if (state is UserCreated) {
                  user.updateDisplayName(user.email!.split('@')[0]);
                }
                if (!user.emailVerified) {
                  user.sendEmailVerification();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please check your inbox to verify your email.',
                      ),
                    ),
                  );
                }
                context.pushReplacement('/');
              }),
            ],
            footerBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: [
                    const Divider(),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => context.push('/sign-in/email-link'),
                      child: const Text('Sign in with email link'),
                    ),
                  ],
                ),
              );
            },
            // Optionally add a button or link to register here in your SignInScreen UI
          ),
          routes: [
            GoRoute(
              path: 'forgot-password',
              builder: (context, state) {
                final email = state.uri.queryParameters['email'];
                return ForgotPasswordScreen(email: email, headerMaxExtent: 200);
              },
            ),
            GoRoute(
              path: 'email-link',
              builder: (context, state) => const EmailLinkSignInPage(),
            ),
          ],
        ),
        // Add a route for the register page
        GoRoute(
          path: 'register',
          builder: (context, state) => RegisterPage(),
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) => ProfileScreen(
            providers: const [],
            actions: [
              SignedOutAction((context) {
                context.pushReplacement('/');
              }),
            ],
          ),
        ),
      ],
    ),
  ],
);

class BudgetTrackerApp extends StatelessWidget {
  const BudgetTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Budget Tracker',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routerConfig: _router,
    );
  }
}
