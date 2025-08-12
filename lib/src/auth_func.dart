import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets.dart'; // assumes StyledButton is defined here

class AuthFunc extends StatelessWidget {
  const AuthFunc({super.key, required this.loggedIn, required this.signOut});

  final bool loggedIn;
  final void Function() signOut;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 8),
          child: StyledButton(
            onPressed: () {
              if (!loggedIn) {
                context.push('/sign-in');
              } else {
                signOut();
              }
            },
            child: Text(!loggedIn ? 'Sign In' : 'Logout'),
          ),
        ),
        Visibility(
          visible: loggedIn,
          child: Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 8),
            child: StyledButton(
              onPressed: () {
                context.push('/profile');
              },
              child: const Text('Profile'),
            ),
          ),
        ),
      ],
    );
  }
}
