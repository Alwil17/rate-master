import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rate_master/routes/routes.dart';
import 'package:rate_master/shared/theme/theme.dart';

PreferredSizeWidget homeAppBar(
    BuildContext context, VoidCallback? onRefresh) {
  return AppBar(
    leading: InkWell(
      onTap: () => context.pushNamed(APP_PAGES.profile.toName),
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: CircleAvatar(
          backgroundColor: Colors.white70,
          child: Image.asset("assets/images/avatar.png"),
        ),
      ),
    ),
    actions: [
      // TODO: Add a notification icon
      /*IconButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColors.accent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        icon: PhosphorIcon(PhosphorIconsRegular.arrowClockwise,
            color: Colors.white),
        onPressed: onRefresh,
      ),*/
      IconButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(AppColors.accent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        icon: PhosphorIcon(PhosphorIconsRegular.bellSimpleRinging,
            color: Colors.white),
        onPressed: () {},
      ),
    ],
  );
}
