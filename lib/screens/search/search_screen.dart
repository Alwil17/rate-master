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
    // Initially load all filters
    _doFetch();
  }

  void _doFetch() {
    Provider.of<ItemProvider>(context, listen: false).fetchItemsFiltered(
      query: query,
      categoryId: selectedCat,
      tags: selectedTags,
      ascending: isAscending,
    );
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
                    onPressed: () async {
                      final result = await _openFilterSheet(context);
                      if (result != null) {
                        setState(() {
                          selectedCat = result['selectedCat'];
                          selectedTags = result['selectedTags'];
                          isAscending = result['isAscending'];
                        });
                        _doFetch();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<ItemProvider>(
                builder: (ctx, provider, _) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (provider.error != null) {
                    return Center(child: Text(provider.error!));
                  }
                  if (provider.items.isEmpty) {
                    return Center(child: Text(locale.noItemFound));
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.items.length,
                    itemBuilder: (_, i) =>
                        ItemCardHorizontal(item: provider.items[i]),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> _openFilterSheet(BuildContext ctx) =>
      showModalBottomSheet<Map<String, dynamic>>(
        context: ctx,
        backgroundColor: Colors.white,
        builder: (_) => FilterBottomSheet(
          selectedCat: selectedCat ?? 0,
          selectedTags: selectedTags,
          isAscending: isAscending,
        ),
      );
}
