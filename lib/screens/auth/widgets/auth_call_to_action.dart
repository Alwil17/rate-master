import 'package:flutter/material.dart';
import 'package:rate_master/shared/theme/theme.dart';

/// A widget that displays a call to action for signing up.
///
/// Example:
/// ```dart
/// SignUpOption(
///  label: 'Don\'t have an account?',
///  actionText: 'Sign Up',
///  onPressed: () {
///    context.goNamed(APP_PAGES.signUp.toName);
///  }
/// )
/// ```
class SignUpOption extends StatelessWidget {
  /// The text to display before the action button.
  final String label;
  /// The text to display inside the action button.
  final String actionText;
  /// Called when the button is tapped. If null, the button is disabled.
  final VoidCallback? onPressed;
  /// Creates a [SignUpOption].
  const SignUpOption({super.key, required this.label, required this.actionText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(label),
        TextButton(
          onPressed: onPressed,
          child: Text(actionText,
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: AppColors.blueColor),
          ),
        ),
      ],
    );
  }
}
