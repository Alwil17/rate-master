import 'package:flutter/material.dart';

class AuthFormCard extends StatelessWidget {
  final Widget child;

  const AuthFormCard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );
  }
}
