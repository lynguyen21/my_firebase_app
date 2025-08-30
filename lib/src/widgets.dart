import 'package:flutter/material.dart';

/// A simple heading widget used in the Budget Tracker app.
class Header extends StatelessWidget {
  const Header(this.heading, {super.key});
  final String heading;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          heading,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      );
}

/// A paragraph-style text widget for descriptions or details.
class Paragraph extends StatelessWidget {
  const Paragraph(this.content, {super.key});
  final String content;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          content,
          style: const TextStyle(fontSize: 18, color: Colors.black87),
        ),
      );
}

/// An icon paired with detail text, useful for showing transaction summaries, categories, etc.
class IconAndDetail extends StatelessWidget {
  const IconAndDetail(this.icon, this.detail, {super.key});
  final IconData icon;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.green),
            const SizedBox(width: 8),
            Text(detail, style: const TextStyle(fontSize: 18)),
          ],
        ),
      );
}

/// A styled button consistent across the Budget Tracker app.
class StyledButton extends StatelessWidget {
  const StyledButton({required this.child, required this.onPressed, super.key});

  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.green),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          foregroundColor: Colors.green,
        ),
        onPressed: onPressed,
        child: child,
      );
}
