import 'package:flutter/material.dart';

class NavbarExpandingWidget extends StatefulWidget {
  const NavbarExpandingWidget({super.key});

  @override
  State<NavbarExpandingWidget> createState() => _NavbarExpandingWidgetState();
}

class _NavbarExpandingWidgetState extends State<NavbarExpandingWidget>
    with TickerProviderStateMixin {
  int selectedItem = 0;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0, 1),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: Color(0x0F000000),
              offset: Offset(
                0,
                4,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _menuButton(Icons.home, 'Home', 0, selectedItem),
              _menuButton(Icons.abc, 'Test', 1, selectedItem),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuButton(IconData icon, String label, int id, int selected){
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => setState(() => selectedItem = id),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: selected == id ? 88.0 : 41.0,
        decoration: BoxDecoration(
          color: selectedItem == id ? Color(0xFFD0E9FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(9, 7, 9, 7),
          child: Row(
            children: [
              Icon(
                icon,
                size: 23,
              ),
              if (selected == id)
                Padding(
                  padding: EdgeInsets.fromLTRB(6, 0, 7, 0),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Color(0xFF0F0F0F),
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
