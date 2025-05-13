import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/providers/category_provider.dart';
import 'package:rate_master/providers/tag_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FilterBottomSheet extends StatefulWidget {
  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  int selectedCat = 0;
  List<String> selectedTags = [];
  String ascendingString = 'Ascending';

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter by Tags section
          _buildTitle(locale.filterByCategory, Icons.filter_alt),
          const SizedBox(height: 8),
          // Wrap with Consumer to access the CategoryProvider
          Consumer<CategoryProvider>(
            builder: (context, categoryProvider, child) {
               return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categoryProvider.categorys.map((category) {
                    final isSelected = selectedCat == category.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(category.name),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            if (isSelected) {
                              selectedCat = 0; // Deselect
                            } else {
                              selectedCat = category.id; // Select new one
                            }
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Filter by Tags section
          _buildTitle(locale.filterByTag, Icons.filter_alt),
          const SizedBox(height: 8),
          // Wrap with Consumer to access the TagProvider
          Consumer<TagProvider>(
            builder: (context, tagProvider, child) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: tagProvider.tags.map((tag) {
                    final isSelected = selectedTags.contains(tag.name);
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(tag.name),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        selected: isSelected,
                        onSelected: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              if (tag.name == 'All') {
                                selectedTags.clear();
                                selectedTags.add(tag.name);
                              } else {
                                selectedTags.remove('All');
                                selectedTags.add(tag.name);
                              }
                            } else {
                              selectedTags.remove(tag.name);
                            }
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Sort Order section
          _buildTitle(locale.sortOrder, Icons.swap_vert),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildClickableSortOption(locale.ascending, Icons.arrow_upward_sharp),
              _buildClickableSortOption(
                  locale.descending, Icons.arrow_downward_sharp),
            ],
          ),
          const SizedBox(height: 16),

          // Apply Button
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'selectedCat': selectedCat,
                  'selectedTags': selectedTags,
                  'isAscending': ascendingString == 'Ascending',
                });
              },
              child: Text(locale.applyFilters),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(String label, IconData icon) {
    return Text.rich(TextSpan(children: [
      WidgetSpan(
          child: Icon(
        icon,
        size: 20,
      )),
      WidgetSpan(
          child: SizedBox(
        width: 5,
      )),
      TextSpan(
          text: label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    ]));
  }

  // Build clickable text for Sort By options
  Widget _buildClickableSortOption(String label, IconData icon) {
    return InkWell(
      onTap: () {
        setState(() {
          ascendingString = label;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text.rich(
          TextSpan(children: [
            WidgetSpan(
                child: Icon(
              icon,
              size: 20,
            )),
            WidgetSpan(
                child: SizedBox(
              width: 3,
            )),
            TextSpan(
                text: label,
                style: TextStyle(
                    fontSize: 15,
                    color:
                        (ascendingString == label) ? Colors.blue : Colors.black,
                    fontWeight: (ascendingString == label)
                        ? FontWeight.bold
                        : FontWeight.normal)),
          ]),
        ),
      ),
    );
  }
}
