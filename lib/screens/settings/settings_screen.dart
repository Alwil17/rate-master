import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/providers/auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rate_master/shared/theme/theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.settings),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Compte
          Text(locale.account, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _buildSettingTileContainer([
            _buildSettingTile(
              user?.name ?? 'Utilisateur',
              user?.email ?? '',
              PhosphorIconsDuotone.user,
              null,
            )
          ]),

          const SizedBox(height: 24),

          // Apparence
          Text(locale.appearance,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _buildSettingTileContainer([
            SwitchListTile(
              secondary: const Icon(Icons.brightness_6),
              title: Text(locale.darkMode),
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {

              },
            ),
            _buildSettingTile(
              locale.language,
              null,
              PhosphorIconsDuotone.globe, () {},
            ),
          ]),
          const SizedBox(height: 24),

          // À propos
          Text(locale.about, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _buildSettingTileContainer([
            _buildSettingTile(
              locale.appVersion,
              "1.0.0",
              PhosphorIconsRegular.info,
              null,
            ),
            _buildSettingTile(
              locale.privacyPolicy,
              null,
              PhosphorIconsRegular.shieldWarning,
              null,
            ),
            _buildSettingTile(
              locale.contactSupport,
              null,
              PhosphorIconsRegular.headset,
              null,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingTileContainer(List<Widget> childs) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: AppColors.accent, width: 0.5),
      ),
      child: Column(
        children: childs,
      ),
    );
  }

  Widget _buildSettingTile(String title, String? subtitle,
      PhosphorIconData icon, VoidCallback? onTap) {
    return ListTile(
      onTap: onTap,
      leading: PhosphorIcon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: onTap != null
          ? PhosphorIcon(PhosphorIconsRegular.caretRight)
          : null,
    );
  }
}
