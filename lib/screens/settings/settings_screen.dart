import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/providers/auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(user?.name ?? 'Utilisateur'),
                  subtitle: Text(user?.email ?? ''),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: Text(locale.changePassword),
                  onTap: () {
                    // Navigation vers change password
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(locale.logout),
                  onTap: () async {
                    await authProvider.logout();
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Apparence
          Text(locale.appearance, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.brightness_6),
                  title: Text(locale.darkMode),
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (value) {
                    // Implémenter changement de thème
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(locale.language),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // Aller vers une page de sélection de langue
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // À propos
          Text(locale.about, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info),
                  title: Text(locale.appVersion),
                  subtitle: const Text("1.0.0"),
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: Text(locale.privacyPolicy),
                  onTap: () {
                    // Ouvrir lien ou page
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.support_agent),
                  title: Text(locale.contactSupport),
                  onTap: () {
                    // Lancer email ou page contact
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
