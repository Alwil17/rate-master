import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/models/user.dart';
import 'package:rate_master/providers/auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'widgets/profile_vector.dart';
import 'widgets/stats_summary.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthProvider _authProvider;

  @override
  void initState() {
    super.initState();

    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // vector icon
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: CustomPaint(
              painter: ProfileVector(),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width, height: 170),
            ),
          ),

          // 2) The avatar, centered horizontally, overlapping the header
          Positioned(
            top: 80, // tweak this to slide up/down
            left: 0,
            right: 0,
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: Image.network(
                        _authProvider.user!.imageUrl ?? '',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          // fallback to default asset
                          return _buildPlaceholder();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _authProvider.user!.name,
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(_authProvider.user!.email,
                      style: Theme.of(context)
                          .textTheme
                          .labelMedium
                          ?.copyWith(fontWeight: FontWeight.normal)),
                ],
              ),
            ),
          ),

          // 3) The edit button, overlapping the avatar
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + 230,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  StatsSummary(
                    reviewsCount: 52,
                    averageRating: 4.8,
                    commentsCount: 45,
                  ),
                  Placeholder()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(User user) {
    if (user.imageUrl != null && user.imageUrl!.isNotEmpty) {
      return Image.network(
        user.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(),
        loadingBuilder: (_, child, progress) => progress == null
            ? child
            : const Center(child: CircularProgressIndicator()),
      );
    } else {
      return _buildPlaceholder();
    }
  }

  /// Placeholder gris avec icône film
  Widget _buildPlaceholder() {
    return Image.asset(
      'assets/images/avatar.png',
      width: 120,
      height: 120,
      fit: BoxFit.cover,
    );
  }
}
