import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/providers/app_state_provider.dart';
import 'package:rate_master/providers/auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rate_master/routes/routes.dart';
import 'package:rate_master/screens/settings/widgets/delete_account_tile.dart';
import 'package:rate_master/screens/settings/widgets/language_selection_dialog.dart';
import 'package:rate_master/shared/constants/constants.dart';
import 'package:rate_master/shared/widgets/expanding_bottom_nav.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateProvider>();
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(locale.settings),
        centerTitle: true,
        leading: IconButton(
          icon: PhosphorIcon(PhosphorIconsRegular.arrowLeft,
              color: Theme.of(context).iconTheme.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      bottomNavigationBar: ExpandingBottomNav(items: Constants.navItems),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Compte
          Text(locale.account, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _buildSettingTileContainer(context, [
            _buildSettingTile(
              context.read<AuthProvider>().user?.name ?? 'Utilisateur',
              context.read<AuthProvider>().user?.email ?? '',
              PhosphorIconsDuotone.user,
              () => context.pushNamed(APP_PAGES.profile.toName),
            )
          ]),

          const SizedBox(height: 20),

          // Apparence
          Text(locale.appearance,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _buildSettingTileContainer(context, [
            SwitchListTile(
              secondary: const PhosphorIcon(PhosphorIconsRegular.circleHalf),
              title: Text(locale.darkMode),
              value: appState.isDarkMode,
              onChanged: (value) {
                // Toggle theme
                appState.isDarkMode = value;
              },
            ),
            _buildSettingTile(
              locale.language,
              null,
              PhosphorIconsRegular.globe,
              () => _showLanguageDialog(context),
            ),
          ]),
          const SizedBox(height: 20),

          // À propos
          Text(locale.about, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _buildSettingTileContainer(context,[
            _buildSettingTile(
              locale.appVersion,
              appState.appVersion,
              PhosphorIconsRegular.info,
              null,
            ),
            _buildSettingTile(
              locale.learnMore,
              null,
              PhosphorIconsRegular.info,
                  () => context.pushNamed(APP_PAGES.about.toName),
            ),
            _buildSettingTile(
              locale.contactSupport,
              null,
              PhosphorIconsRegular.headset,
              null,
            ),
          ]),
          const SizedBox(height: 20),
          // Other options
          Text(locale.otherOptions, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          DeleteAccountTile(),
        ],
      ),
    );
  }

  Widget _buildSettingTileContainer(BuildContext context,List<Widget> childs) {
    return Card(
      shape: Theme.of(context).cardTheme.shape,
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
      trailing:
          onTap != null ? PhosphorIcon(PhosphorIconsRegular.caretRight) : null,
    );
  }

  void _showLanguageDialog(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        // <-- SEE HERE
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      isScrollControlled: true,
      builder: (context) => LanguageSelectionDialog(
        defaultLocale: context.read<AppStateProvider>().locale,
      ),
    );

    if (result != null) {
      // 1) Save to the provider
      context.read<AppStateProvider>().locale = result;
    }
  }
}
