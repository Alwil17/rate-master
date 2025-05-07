import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/providers/item_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rate_master/shared/widgets/item_card/item_card_horizontal.dart';

import 'widgets/filter_bottom_sheet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final itemProvider = Provider.of<ItemProvider>(context);

    final filteredItems = itemProvider.items
        .where(
          (item) => item.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Search field
                Expanded(
                  child: TextField(
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: locale.makeASearch,
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => setState(() => query = value),
                  ),
                ),
                const SizedBox(width: 8),
                // Filter button (3 dots)
                SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: IconButton(
                    icon: const PhosphorIcon(PhosphorIconsDuotone.funnel),
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                  ),
                ),
                SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: IconButton(
                    icon: const PhosphorIcon(
                        PhosphorIconsDuotone.slidersHorizontal),
                    padding: EdgeInsets.zero,
                    onPressed: () => _openFilterSheet(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredItems.length,
                itemBuilder: (_, i) =>
                    ItemCardHorizontal(item: filteredItems[i]),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _openFilterSheet1(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Variables de filtre locales
            String? selectedCategory;
            double minRating = 0;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Filtres", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 16),

                  // Catégorie (dropdown)
                  DropdownButton<String>(
                    value: selectedCategory,
                    isExpanded: true,
                    hint: Text("Catégorie"),
                    items: ["Film", "Série", "Livre"]
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (val) {
                      setModalState(() => selectedCategory = val);
                    },
                  ),

                  // Note minimale
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Note minimale: ${minRating.toInt()}"),
                      Slider(
                        min: 0,
                        max: 5,
                        divisions: 5,
                        value: minRating,
                        onChanged: (val) {
                          setModalState(() => minRating = val);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: appliquer les filtres à ton provider ou localement
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.filter_alt),
                    label: Text("Appliquer"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<List<String>?> _openFilterSheet(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      builder: (context) => FilterBottomSheet(),
    );

    if (result != null) {
      setState(() {
        // Appliquer les filtres et tri en fonction des résultats
        final selectedTags = result['selectedTags'];
        final sortBy = result['sortBy'];
        final isAscending = result['isAscending'];

        print(selectedTags);
        print(sortBy);
        print(isAscending);
        // Utilisez ces valeurs pour filtrer et trier vos cartes
      });
    }
  }
}
