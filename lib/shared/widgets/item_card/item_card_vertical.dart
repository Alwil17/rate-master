import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rate_master/models/item.dart';
import 'package:rate_master/routes/routes.dart';

class ItemCardVertical extends StatelessWidget {
  final Item item;

  const ItemCardVertical({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(APP_PAGES.itemDetails.toName, pathParameters: {'itemId': "${item.id}"}),
      child: SizedBox(
        width: 150,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 1,
          clipBehavior: Clip.antiAlias,
          // pour que l'image soit rognée aux coins
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image ou placeholder
              AspectRatio(
                aspectRatio: 16 / 9,
                child: _buildImage(),
              ),
              const SizedBox(height: 8),
              // Titre
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  item.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 5),
              // Étoiles
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: _buildStarIcons(item.avgRating.toInt()),
                ),
              ),
              const SizedBox(height: 5),
              // Texte de note
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  '${item.avgRating.toStringAsFixed(1)} – ${item.countRating.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ' ')} note(s)',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Génère la liste d'icônes étoiles (plein/vide) pour une note sur 5
  List<Widget> _buildStarIcons(int fullStars) {
    bool hasHalfStar = (item.avgRating - fullStars) >= 0.5;
    return List.generate(5, (i) {
      if (i < fullStars) {
        // full star
        return const PhosphorIcon(PhosphorIconsDuotone.star, size: 20, color: Colors.amber);
      } else if (i == fullStars && hasHalfStar) {
        // half star
        return const PhosphorIcon(PhosphorIconsDuotone.starHalf, color: Colors.amber, size: 20);
      } else {
        // empty star
        return PhosphorIcon(PhosphorIconsFill.star, color: Colors.grey[300], size: 20);
      }
    });
  }

  Widget _buildImage() {
    if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
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
