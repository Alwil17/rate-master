import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/providers/app_state_provider.dart';
import 'package:rate_master/providers/auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rate_master/routes/routes.dart';
import 'package:rate_master/screens/settings/widgets/language_selection_dialog.dart';
import 'package:rate_master/shared/constants/constants.dart';
import 'package:rate_master/shared/theme/theme.dart';
import 'package:rate_master/shared/widgets/expanding_bottom_nav.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(locale.settings),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      bottomNavigationBar: ExpandingBottomNav(items: Constants.navItems),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Compte
          Text(locale.account, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _buildSettingTileContainer([
            _buildSettingTile(
              context.read<AuthProvider>().user?.name ?? 'Utilisateur',
              context.read<AuthProvider>().user?.email ?? '',
              PhosphorIconsDuotone.user, () => context.pushNamed(APP_PAGES.profile.toName),
            )
          ]),

          const SizedBox(height: 24),

          // Apparence
          Text(locale.appearance,
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _buildSettingTileContainer([
            SwitchListTile(
              secondary: const PhosphorIcon(PhosphorIconsRegular.circleHalf),
              title: Text(locale.darkMode),
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {},
            ),
            _buildSettingTile(
              locale.language,
              null,
              PhosphorIconsRegular.globe,
              () => _showLanguageDialog(context),
            ),
          ]),
          const SizedBox(height: 24),

          // À propos
          Text(locale.about, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          _buildSettingTileContainer([
            _buildSettingTile(
              locale.appVersion,
              context.read<AppStateProvider>().appVersion,
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
      trailing:
          onTap != null ? PhosphorIcon(PhosphorIconsRegular.caretRight) : null,
    );
  }

  void _showLanguageDialog(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
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
