import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/models/user.dart';
import 'package:rate_master/providers/auth_provider.dart';

import 'widgets/profile_vector.dart';

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

          Positioned(
            top: 150,
            right: 0,
            left: 0,
            child: Consumer<AuthProvider>(
              builder: (ctx, rp, _) {
                if (rp.) {
                  return const Center(child: CircularProgressIndicator());
                } else if (rp.error != null) {
                  return Center(child: Text(rp.error!));
                }

                final reviewsWithComments = rp.reviews.where((r) => r.comment!.trim().isNotEmpty).toList();

                if (reviewsWithComments.isEmpty) {
                  return Center(child: Text(locale.noReviewsYet));
                }

                return _buildImage();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(User user) {
    if (user.imageUrl != null && item.imageUrl!.isNotEmpty) {
      return Image.network(
        item.imageUrl!,
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
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.movie,
          size: 48,
          color: Colors.white,
        ),
      ),
    );
  }
}
