import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rate_master/shared/theme/theme.dart';

PreferredSizeWidget globalAppBar(BuildContext context, VoidCallback? onRefresh){
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    leading: Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: Image.asset(
          "assets/images/avatar.png"
        ),
      ),
    ),
    actions: [
      IconButton(
        style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColors.accent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        icon: PhosphorIcon(PhosphorIconsRegular.arrowClockwise, color: Colors.white),
        onPressed: onRefresh,
      ),
      IconButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColors.accent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        icon: PhosphorIcon(PhosphorIconsRegular.bellSimpleRinging, color: Colors.white),
        onPressed: () {},
      ),
    ],
  );
}
