import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rate_master/models/user.dart';
import 'package:rate_master/routes/routes.dart';
import 'package:rate_master/shared/theme/theme.dart';


Widget _buildImage(BuildContext context, User user) {
  if (user.imageUrl != null && user.imageUrl!.isNotEmpty) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.blueGrey[900]
          : Colors.grey[300],
      child: Image.network(
        user.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          // fallback to default asset
          return _buildPlaceholder();
        },
        loadingBuilder: (_, child, progress) =>
        progress == null ? child : const Center(child: CircularProgressIndicator()),
      ),
    );
  } else {
    return _buildPlaceholder();
  }
}

Widget _buildPlaceholder() {
  return Image.asset(
    'assets/images/avatar.png',
    width: 120,
    height: 120,
    fit: BoxFit.cover,
  );
}

PreferredSizeWidget homeAppBar(
    BuildContext context, User user, VoidCallback? onRefresh) {
  return AppBar(
    leading: InkWell(
      onTap: () => context.pushNamed(APP_PAGES.profile.toName),
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: _buildImage(context, user),
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
        onPressed: () => context.pushNamed(APP_PAGES.notifications.toName),
      ),
    ],
  );
}
