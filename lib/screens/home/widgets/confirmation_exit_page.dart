import 'package:flutter/material.dart';

class ConfirmExitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopScope<bool>(
      // Allow pop events to be intercepted
      canPop: false,
      onPopInvokedWithResult: (ctxt, result) async {
        // Show confirmation dialog
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Confirm Exit'),
            content: Text('Are you sure you want to leave the app?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('Cancel')),
              TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('Exit')),
            ],
          ),
        ) ?? false;

        if (shouldExit) {
          // Let the pop happen: first dismiss dialog, then pop route
          Navigator.of(context).pop(true);
        }
        // If shouldExit is false, do nothing and the route stays
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Home')),
        body: Center(child: Text('Press back to see exit confirmation')),
      ),
    );
  }
}
