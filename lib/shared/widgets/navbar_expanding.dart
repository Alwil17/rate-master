import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class NavbarExpandingWidget extends StatefulWidget {
  const NavbarExpandingWidget({super.key});

  @override
  State<NavbarExpandingWidget> createState() => _NavbarExpandingWidgetState();
}

class _NavbarExpandingWidgetState extends State<NavbarExpandingWidget>
    with TickerProviderStateMixin {

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0, 1),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
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
          padding: EdgeInsetsDirectional.fromSTEB(10, 20, 10, 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _menuButton(Icons.home, 'Home')
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuButton(IconData icon, String label){
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {},
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: 0 == 0 ? 88.0 : 41.0,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(30),
          shape: BoxShape.rectangle,
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(9, 7, 9, 7),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                icon,
                size: 23,
              ),
              if (0 == 0)
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(6, 0, 7, 0),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.accents[0],
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
