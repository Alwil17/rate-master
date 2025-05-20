import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/providers/auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rate_master/providers/rating_provider.dart';
import 'package:rate_master/routes/routes.dart';
import 'package:rate_master/screens/profile/widgets/profile_option_card.dart';
import 'package:rate_master/screens/settings/widgets/share_app_dialog.dart';
import 'package:rate_master/shared/theme/theme.dart';

import 'widgets/profile_vector.dart';
import 'widgets/stats_summary.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final AuthProvider _authProvider;
  late final RatingProvider _ratingProvider;

  @override
  void initState() {
    super.initState();

    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _ratingProvider = Provider.of<RatingProvider>(context, listen: false);

    // Fetch all reviews for current user
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ratingProvider.fetchMyReviews(_authProvider.user!.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

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

          // back button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.topLeft,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(8),
                    elevation: 1,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: PhosphorIcon(PhosphorIconsRegular.caretLeft, color: Theme.of(context).iconTheme.color,),
                ),
              ),
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
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
                  const SizedBox(height: 8),
                  _buildEditButton()
                ],
              ),
            ),
          ),

          // 3) The edit button, overlapping the avatar
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + 290,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Consumer2<AuthProvider, RatingProvider>(
                    builder: (ctx, auth, ratings, _) {
                      // Stats
                      final totalReviews = ratings.userReviews.length;
                      final reviewsWithComments = ratings.userReviews
                          .where((r) => r.comment!.trim().isNotEmpty)
                          .toList();
                      final commentCount = reviewsWithComments.length;
                      final avgRating = ratings.userReviews.isNotEmpty
                          ? ratings.userReviews.map((r) => r.value).reduce((a, b) => a + b) /
                          ratings.userReviews.length
                          : 0.0;

                      return StatsSummary(
                        reviewsCount: totalReviews,
                        averageRating: avgRating,
                        commentsCount: commentCount,
                      );
                    },
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.6,
                      // Ajust cards height to fit the screen
                      children: [
                        ProfileOptionCard(
                            title: locale.learnMore,
                            subtitle: locale.about,
                            icon: PhosphorIconsFill.info,
                            onTap: () => context.pushNamed(APP_PAGES.about.toName)),
                        ProfileOptionCard(
                            title: locale.share,
                            subtitle: locale.share,
                            icon: PhosphorIconsFill.shareNetwork,
                            onTap: () => _showShareDialog(context)),
                        ProfileOptionCard(
                            title: locale.close,
                            subtitle: locale.close,
                            icon: PhosphorIconsFill.x,
                            onTap: () => _showExitConfirmationDialog(context)),
                        ProfileOptionCard(
                            title: locale.disconnect,
                            subtitle: locale.seeYouSoon,
                            icon: PhosphorIconsRegular.signOut,
                            onTap: () => _showDisconnectConfirmationDialog(context)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    final locale = AppLocalizations.of(context)!;
    return ElevatedButton.icon(
      icon: const Icon(Icons.edit, color: Colors.white),
      label: Text(
        locale.editMyProfile,
        style: const TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        shape: StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
      onPressed: null,
    );
  }

  Widget _buildPlaceholder() {
    return Image.asset(
      'assets/images/avatar.png',
      width: 120,
      height: 120,
      fit: BoxFit.cover,
    );
  }

  Future<void> _showShareDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ShareAppDialog();
      },
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final locale = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(locale.confirmExit),
          content: Text(locale.confirmExitMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(locale.cancel),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop(); // Ferme l'application
              },
              child: Text(locale.exit),
            ),
          ],
        );
      },
    );
  }

  void _showDisconnectConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final locale = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(locale.confirmDisconnect),
          content: Text(locale.confirmDisconnectMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(locale.cancel),
            ),
            TextButton(
              onPressed: () async {
                await _authProvider.logout();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(locale.disconnectedSuccessfully)),
                );
                context.goNamed(APP_PAGES.splash.toName);
                /*if (response["status"] == 200) {
                  await prefs.clear();
                  context.goNamed(APP_PAGES.splash.toName);
                }*/
              },
              child: Text(locale.yes),
            ),
          ],
        );
      },
    );
  }

}
