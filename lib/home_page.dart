import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'src/widgets.dart';
import 'src/auth_func.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Tracker'),
        actions: [
          AuthFunc(
            loggedIn: appState.loggedIn,
            signOut: appState.signOut,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Header('Welcome to Budget Tracker!'),
          const Paragraph(
            'Track your income and expenses, monitor your budget, and manage your finances with ease.',
          ),
          const SizedBox(height: 24),
          if (!appState.loggedIn)
            const Paragraph(
              'Please sign in to view and manage your budget.',
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                IconAndDetail(
                    Icons.account_balance_wallet, 'Your balance: \$0.00'),
                IconAndDetail(Icons.arrow_downward, 'Total expenses: \$0.00'),
                IconAndDetail(Icons.arrow_upward, 'Total income: \$0.00'),
              ],
            ),
        ],
      ),
    );
  }
}
