import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rate_master/routes/routes.dart';

PreferredSizeWidget globalAppBar(BuildContext context, VoidCallback? onRefresh){
  return AppBar(
    elevation: 0,
    leading: IconButton(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Color(0x30056380)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      icon: Icon(Icons.menu, color: Color(0xff056380)),
      onPressed: () {},
    ),
    actions: [
      IconButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Color(0x30056380)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        icon: Icon(Icons.refresh, color: Color(0xff056380)),
        onPressed: onRefresh,
      ),
      IconButton(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Color(0x30056380)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        icon: Icon(Icons.notifications, color: Color(0xff056380)),
        onPressed: () {},
      ),
    ],
  );
}
