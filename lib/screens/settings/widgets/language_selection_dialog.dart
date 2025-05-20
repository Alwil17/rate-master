import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rate_master/shared/theme/theme.dart';

class LanguageSelectionDialog extends StatefulWidget {
  final String defaultLocale;

  const LanguageSelectionDialog({super.key, required this.defaultLocale});

  @override
  _LanguageSelectionDialogState createState() =>
      _LanguageSelectionDialogState();
}

class _LanguageSelectionDialogState extends State<LanguageSelectionDialog> {
  String selecttedlanguage = '';

  @override
  void initState() {
    super.initState();
    if (widget.defaultLocale.isNotEmpty) {
      selecttedlanguage = widget.defaultLocale;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sort by section
          const SizedBox(height: 10),
          _buildTitle(context,
              AppLocalizations.of(context)!
                  .selectThe(AppLocalizations.of(context)!.language),
              PhosphorIconsRegular.flagCheckered),
          const SizedBox(height: 8),
          ...AppLocalizations.supportedLocales.map((e) {
            return RadioListTile<String>(
              title: Text(
                  AppLocalizations.of(context)!.languageValue(e.languageCode)),
              value: e.languageCode,
              groupValue: selecttedlanguage,
              onChanged: (String? value) {
                setState(() {
                  selecttedlanguage = value ?? widget.defaultLocale;
                });
              },
            );
          }),
          const SizedBox(height: 16),

          // Apply Button
          _buildCancelAndEndButtons(),
        ],
      ),
    );
  }

  Widget _buildTitle(
      BuildContext context, String label, PhosphorIconData icon) {
    return Text.rich(TextSpan(children: [
      WidgetSpan(
          child: PhosphorIcon(
        icon,
        size: 24,
      )),
      WidgetSpan(
          child: SizedBox(
        width: 8,
      )),
      TextSpan(
          text: label,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold, fontSize: 22)),
    ]));
  }

  Widget _buildCancelAndEndButtons() {
    final locale = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        /// Edit button
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),

        const SizedBox(width: 12),

        /// End button
        ElevatedButton.icon(
          icon: const PhosphorIcon(PhosphorIconsRegular.floppyDisk, color: Colors.white),
          label: Text(locale.end,
              style: const TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () => Navigator.pop(context, selecttedlanguage),
        ),
      ],
    );
  }
}
