import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/providers/category_provider.dart';
import 'package:rate_master/providers/tag_provider.dart';

class FilterBottomSheet extends StatefulWidget {
  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  List<String> selectedTags = [];
  List<String> selectedCats = [];
  String sortBy = 'Date';
  String ascendingString = 'Ascending';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter by Tags section
          _buildTitle('Filter by Categories', Icons.filter_alt),
          const SizedBox(height: 8),
          // Wrap with Consumer to access the CategoryProvider
          Consumer<CategoryProvider>(
            builder: (context, categoryProvider, child) {
               return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categoryProvider.categorys.map((category) {
                    final isSelected = selectedCats.contains(category.name);
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
                              selectedCats.clear(); // Deselect
                            } else {
                              selectedCats = [category.name]; // Select new one
                            }
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
              ;
            },
          ),
          const SizedBox(height: 16),

          // Filter by Tags section
          _buildTitle('Filter by Tags', Icons.filter_alt),
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
          _buildTitle('Sort Order', Icons.swap_vert),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildClickableSortOption('Ascending', Icons.arrow_upward_sharp),
              _buildClickableSortOption(
                  'Descending', Icons.arrow_downward_sharp),
              /*_buildSortOrderButton('Ascending', isAscending),
              _buildSortOrderButton('Descending', !isAscending),*/
            ],
          ),
          const SizedBox(height: 16),

          // Apply Button
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, {
                  'selectedTags': selectedTags,
                  'sortBy': sortBy,
                  'isAscending': ascendingString == 'Ascending',
                });
              },
              child: const Text('Apply filters'),
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
  Widget _buildClickableTextOption(String label) {
    return InkWell(
      onTap: () {
        setState(() {
          sortBy = label;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: sortBy == label ? Colors.blue : Colors.black,
            fontWeight: sortBy == label ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
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
