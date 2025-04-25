import 'package:flutter/material.dart';

import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rate_master/models/item.dart';

class ItemCardVertical extends StatelessWidget {
  final Item item;

  const ItemCardVertical({
    Key? key,
    required this.item
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      clipBehavior: Clip.antiAlias, // pour que l'image soit rognée aux coins
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image ou placeholder
          AspectRatio(
            aspectRatio: 16 / 9,
            child: item.imageUrl != null && item.imageUrl!.isNotEmpty
                ? Image.network(
              item.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (ctx, _, __) => _buildPlaceholder(),
              loadingBuilder: (ctx, child, progress) {
                if (progress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
            )
                : _buildPlaceholder(),
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
          const SizedBox(height: 8),
          // Étoiles
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: _buildStarIcons(item.avgRating.toInt()),
            ),
          ),
          const SizedBox(height: 4),
          // Texte de note
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              '${item.avgRating.toStringAsFixed(1)} – ${item.countRating.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ' ')} notes',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  /// Génère la liste d'icônes étoiles (plein/vide) pour une note sur 5
  List<Widget> _buildStarIcons(int fullStars) {
    const totalStars = 5;
    return List.generate(totalStars, (i) {
      if (i < fullStars) {
        return PhosphorIcon(PhosphorIconsDuotone.star, size: 20, color: Colors.amber);
      } else {
        return PhosphorIcon(PhosphorIconsDuotone.starHalf, size: 20, color: Colors.amber);
      }
    });
  }

  /// Placeholder gris avec icône film
  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.movie,
          size: 48,
          color: Colors.white70,
        ),
      ),
    );
  }
}

