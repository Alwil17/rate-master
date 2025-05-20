import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BulletButtonItem extends StatelessWidget {
  final String text;
  final VoidCallback onClick;

  const BulletButtonItem(
      {super.key, required this.text, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            PhosphorIcon(PhosphorIconsFill.circle,
                size: 6, color: Theme.of(context).iconTheme.color),
            const SizedBox(width: 8),
            Expanded(
                child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
            )),
          ],
        ),
      ),
    );
  }
}
