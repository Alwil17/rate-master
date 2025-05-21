// Flutter/Dart SDK
import 'package:flutter/material.dart';
// Third-party packages
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
// Localizations
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// A back button for authentication screens.
///
/// Example:
/// ```dart
/// AuthBackButton()
/// ```
class AuthBackButton extends StatelessWidget {
  /// Creates an [AuthBackButton].
  const AuthBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Align(
          alignment: Alignment.topLeft,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(8),
              elevation: 1,
            ),
            onPressed: () => context.pop(),
            child: PhosphorIcon(
              PhosphorIconsRegular.caretLeft,
              color: Theme.of(context).iconTheme.color,
              semanticLabel: AppLocalizations.of(context)!.goBack,
            ),
          ),
        ),
      ),
    );
  }
}
