import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';
import 'app_state.dart';
import 'home_page.dart';
import 'src/register_page.dart'; // import your register page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ChangeNotifierProvider(
      create: (_) => ApplicationState(),
      child: const BudgetTrackerApp(),
    ),
  );
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
