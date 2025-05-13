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


  Future<List<String>?> _openFilterSheet(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) => FilterBottomSheet()
    );

    if (result != null) {
      // Apply filters depending on results
      final selectedCat = result['selectedCat'] as int?;
      final selectedTags = List<String>.from(result['selectedTags'] ?? []);
      final isAscending = result['isAscending'] as bool;

      // Trigger fetch from the provider (which uses the service)
      await Provider.of<ItemProvider>(context, listen: false).fetchItemsFiltered(
        categoryId: selectedCat,
        tags: selectedTags,
        ascending: isAscending,
      );

      // Optionally reset the search query
      setState(() {
        query = "";
      });
    }
    return null;
  }
}
