import 'package:flutter/material.dart';
import 'package:rate_master/generated/assets.dart';

class AuthHeaderImage extends StatelessWidget {
  const AuthHeaderImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Image.asset(
        Assets.imagesShootingStar,
        height: 120,
        fit: BoxFit.contain,
        cacheWidth: 300,
      ),
    );
  }
}
