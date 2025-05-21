import 'package:flutter/material.dart';
import 'package:rate_master/shared/theme/theme.dart';

/// A primary button that handles loading state and disabled state.
///
/// Example:
/// ```dart
/// PrimaryButton(
///   label: 'Login',
///   isLoading: false,
///   onPressed: () => doLogin(),
/// )
/// ```
class PrimaryButton extends StatelessWidget {
  /// The text to display inside the button.
  final String label;

  /// Called when the button is tapped. If null, the button is disabled.
  final VoidCallback? onPressed;

  /// Whether to show a loading spinner instead of the label.
  final bool isLoading;

  /// Creates a [PrimaryButton].
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 15),
          backgroundColor: AppColors.accent,
          shape: const StadiumBorder()
        ),
        child: isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}
