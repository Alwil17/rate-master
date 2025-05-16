import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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
          }).toList(),
          const SizedBox(height: 16),

          // Apply Button
          Center(
              child: SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff79a5b4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  icon: Icon(Icons.close, color: Color(0xff056380)),
                  label: Text(
                    AppLocalizations.of(context)!.cancel,
                    style:
                        const TextStyle(fontSize: 18, color: Color(0xff056380)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context, selecttedlanguage),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffd9e8ee),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  icon: Icon(Icons.save, color: Color(0xff056380)),
                  label: Text(
                    AppLocalizations.of(context)!.end,
                    style:
                        const TextStyle(fontSize: 18, color: Color(0xff056380)),
                  ),
                )
              ],
            ),
          )),
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
}
