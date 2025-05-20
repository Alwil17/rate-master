import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rate_master/screens/about/widgets/bullet_button_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'widgets/bullet_item.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _launchUrl(String urlToOpen) async {
    final Uri url = Uri.parse(urlToOpen);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: PhosphorIcon(PhosphorIconsRegular.arrowLeft,
                color: Theme.of(context).iconTheme.color),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(locale.about)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Text(
              "🎯 ${locale.aboutApp}",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(locale.appDescription,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            Text(
              '🛠️ ${locale.functionalities}',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                BulletItem(text: locale.addReviewFrom1To5),
                BulletItem(text: locale.leaveAComment),
                BulletItem(text: locale.viewStats),
                BulletItem(text: locale.editPreferences),
                BulletItem(text: locale.deleteAccount),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              '🔐 ${locale.datasPrivateAndSecure}',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text(
              '📄 ${locale.learnMore}',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            BulletButtonItem(
              text: locale.privacyPolicy,
              onClick: () => _launchUrl(
                  'https://alwil17.github.io/rate-master/privacy-policy.html'),
            ),
            BulletButtonItem(
              text: locale.termsAndConditions,
              onClick: () => _launchUrl(
                  'https://alwil17.github.io/rate-master/terms-and-conditions.html'),
            ),
            BulletButtonItem(
              text: locale.childProtection,
              onClick: () => _launchUrl(
                  'https://alwil17.github.io/rate-master/child-protection.html'),
            ),
            BulletButtonItem(
              text: locale.accountDeletion,
              onClick: () => _launchUrl(
                  'https://alwil17.github.io/rate-master/delete-account.html'),
            )
          ],
        ),
      ),
    );
  }
}
