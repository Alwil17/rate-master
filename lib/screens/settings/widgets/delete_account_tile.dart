import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rate_master/providers/auth_provider.dart';

class DeleteAccountTile extends StatelessWidget {
  const DeleteAccountTile({super.key});

  void deleteAccount(BuildContext context) async {
    final locale = AppLocalizations.of(context)!;
    // Implement the delete account functionality here
    // For example, show a confirmation dialog and then proceed with the deletion
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(locale.deleteAccount),
        content: Text(locale.deleteAccountConfirmation),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(locale.cancel)),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text(locale.delete)),
        ],
      ),
    ) ?? false;

    if (shouldDelete) {
      // Call the delete account API or perform the deletion logic here
      await Provider.of<AuthProvider>(context).deleteAccount();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(locale.deleteAccountSuccess)),
      );
      // Navigate to the login screen or perform any other action
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        side: BorderSide(
          color: Colors.red,
          width: 1,
        ),
      ),
      child: ListTile(
        leading: PhosphorIcon(PhosphorIconsRegular.trash, color: Colors.red,),
        title: Text(AppLocalizations.of(context)!.deleteAccount, style: TextStyle(color: Colors.red)),
        subtitle: Text(AppLocalizations.of(context)!.permanentDelete, style: TextStyle(color: Colors.red)),
        onTap: () => deleteAccount(context),
      ),
    );
  }
}
