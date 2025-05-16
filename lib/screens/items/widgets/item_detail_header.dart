import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:rate_master/models/item.dart';

class ItemDetailHeader extends StatelessWidget {
  final Item item;

  const ItemDetailHeader({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image en haut avec coins arrondis en bas
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          child: SizedBox(
            width: double.infinity,
            height: 250,
            child: _buildImage(context),
          ),
        ),

        // Bouton retour dans le SafeArea
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

        // Titre centré en bas de l'image
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha((0.5 * 255).round()),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              item.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImage(BuildContext context) {
    if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
      return Image.network(
        item.imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(context),
        loadingBuilder: (_, child, progress) =>
        progress == null ? child : const Center(child: CircularProgressIndicator()),
      );
    } else {
      return _buildPlaceholder(context);
    }
  }

  /// Placeholder gris avec icône film
  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.blueGrey[900]
          : Colors.grey[300],
      child: Center(
        child: Icon(
          Icons.movie,
          size: 48,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}
