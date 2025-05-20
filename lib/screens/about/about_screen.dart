import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  void _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('À propos')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const Text(
              '🎯 À propos de RateMaster',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'RateMaster est une application qui vous permet de noter et commenter vos expériences avec des produits, des lieux ou des services.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              '🛠️ Fonctionnalités principales :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Ajouter une note de 1 à 5'),
            const Text('• Laisser un commentaire'),
            const Text('• Consulter des statistiques d’évaluation'),
            const Text('• Supprimer votre compte à tout moment'),
            const SizedBox(height: 24),
            const Text(
              '🔐 Vos données sont privées et stockées en toute sécurité.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            const Text(
              '📄 Pour en savoir plus :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('• Politique de confidentialité'),
              onTap: () => _openUrl('https://alwil17.github.io/rate-master/privacy-policy.html'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('• Conditions générales d’utilisation'),
              onTap: () => _openUrl('https://alwil17.github.io/rate-master/terms.html'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('• Suppression de compte'),
              onTap: () => _openUrl('https://alwil17.github.io/rate-master/child-protection.html'),
            ),
          ],
        ),
      ),
    );
  }
}