import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rate_master/models/item.dart';

class ItemDetailBody extends StatefulWidget {
  final Item item;

  const ItemDetailBody({Key? key, required this.item}) : super(key: key);

  @override
  _ItemDetailBodyState createState() => _ItemDetailBodyState();
}

class _ItemDetailBodyState extends State<ItemDetailBody>
    with SingleTickerProviderStateMixin {
  int _currentPage = 0; // Indice de la page actuelle
  late PageController _pageController; // Contrôleur du PageView

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    return Expanded(
        child: ClipRRect(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(30), topLeft: Radius.circular(30)),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Boutons pour naviguer entre les pages
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavButton(locale.about, 0),
                    _buildNavButton(locale.reviews, 1),
                  ],
                ),
              ),

              // Contenu du PageView
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentPage =
                          index; // Met à jour l'indice de la page actuelle
                    });
                  },
                  children: [
                    // Page "À propos"
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Address",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff056380),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Page "Départements"
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: _buildSecteurList())),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  // Widget pour une ligne de contact avec icône et texte
  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Color(0x30056380),
          child: Icon(icon, color: Color(0xff056380)),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  // Widget pour les boutons de navigation
  Widget _buildNavButton(String label, int pageIndex) {
    return ElevatedButton(
      onPressed: () {
        _pageController.animateToPage(
          pageIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      style: ElevatedButton.styleFrom(
        fixedSize: Size(145, 30),
        backgroundColor:
            _currentPage == pageIndex ? Color(0xff056380) : Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _currentPage == pageIndex ? Colors.white : Color(0xff056380),
        ),
      ),
    );
  }
}
