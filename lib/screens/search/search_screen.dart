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
  int? selectedCat;
  List<String> selectedTags = [];
  bool isAscending = true;

  @override
  void initState() {
    super.initState();
    // Load items from backend using current filters
    _fetchFromBackend();
  }

  /// Calls the provider to fetch items with category/tags/ordering
  void _fetchFromBackend() {
    Provider.of<ItemProvider>(context, listen: false).fetchItemsFiltered(
      categoryId: selectedCat,
      tags: selectedTags,
      ascending: isAscending,
    );
  }

  /// Opens the filter bottom sheet and reapplies the backend fetch
  Future<void> _onFilterPressed() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: Colors.white,
      builder: (_) => FilterBottomSheet(
        selectedCat: selectedCat ?? 0,
        selectedTags: selectedTags,
        isAscending: isAscending,
      ),
    );

    if (result != null) {
      setState(() {
        selectedCat = result['selectedCat'] as int?;
        selectedTags = List<String>.from(result['selectedTags'] as List);
        isAscending = result['isAscending'] as bool;
        // Clear the text search so we see the full filtered list
        query = "";
      });
      _fetchFromBackend();
    }
  }


  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Search field: only filters locally on 'name'
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
                  height: 25.0,
                  width: 25.0,
                  child: IconButton(
                    icon: const PhosphorIcon(PhosphorIconsDuotone.funnel),
                    padding: EdgeInsets.zero,
                    onPressed: _onFilterPressed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Results
            Expanded(
              child: Consumer<ItemProvider>(
                builder: (ctx, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (provider.error != null) {
                    return Center(child: Text(provider.error!));
                  }
                  // Local search filter over the backend-filtered items
                  final displayed = provider.items.where((item) {
                    return item.name.toLowerCase()
                        .contains(query.toLowerCase());
                  }).toList();

                  if (displayed.isEmpty) {
                    return Center(child: Text(locale.noItemFound));
                  }
                  return ListView.builder(
                    itemCount: displayed.length,
                    itemBuilder: (_, i) =>
                        ItemCardHorizontal(item: displayed[i]),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
