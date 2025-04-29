import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rate_master/models/item.dart';
import 'package:rate_master/routes/routes.dart';
import 'package:rate_master/shared/widgets/chips/category_chip.dart';
import 'package:rate_master/shared/widgets/chips/tag_chip.dart';

class ItemCardHorizontal extends StatelessWidget {
  final Item item;

  const ItemCardHorizontal({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: SizedBox(
        height: 100,
        child: Row(
          children: [
            // Image / placeholder
            SizedBox(
              width: 100,
              height: 100,
              child: _buildImage(),
            ),

            // Espace et contenu texte
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ligne de chips (catégorie + tags)
                    Row(
                      children: [
                        for (var category in item.categories) ...[
                          CategoryChip(label: category.name),
                          const SizedBox(width: 8),
                        ],
                        const SizedBox(width: 8),
                        for (var tag in item.tags) ...[
                          TagChip(label: tag.name),
                          const SizedBox(width: 8),
                        ]
                      ],
                    ),
                    // Titre
                    Text(
                      item.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                        fontSize: 14
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Description
                    Text(
                      item.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),

                    // Étoiles + note
                    Row(
                      children: [
                        ..._buildStarIcons(item.avgRating.toInt()),
                        const SizedBox(width: 8),
                        Text(
                          item.avgRating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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

  /// Génère la liste d'icônes étoiles (plein/vide) pour une note sur 5
  List<Widget> _buildStarIcons(int fullStars) {
    const totalStars = 5;
    return List.generate(totalStars, (i) {
      if (i < fullStars) {
        return PhosphorIcon(PhosphorIconsDuotone.starHalf, size: 15);
      } else {
        return PhosphorIcon(PhosphorIconsDuotone.star,
            size: 15, color: Colors.amber);
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
          color: Colors.white,
        ),
      ),
    );
  }
}
