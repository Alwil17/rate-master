import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/providers/item_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rate_master/shared/widgets/item_card/item_card_horizontal.dart';

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

    final filteredItems = itemProvider.items.where(
          (item) => item.name.toLowerCase().contains(query.toLowerCase()),
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: locale.makeASearch,
            border: InputBorder.none,
          ),
          onChanged: (value) => setState(() => query = value),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredItems.length,
        itemBuilder: (_, i) => ItemCardHorizontal(item: filteredItems[i]),
      ),
    );
  }
}
