// Flutter/Dart SDK
import 'package:flutter/material.dart';
// Third-party packages
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';
// Internal packages
import 'package:rate_master/providers/auth_provider.dart';
import 'package:rate_master/routes/routes.dart';
import 'package:rate_master/shared/widgets/utils.dart';
// Localizations
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      await EasyLoading.show(status: locale.loading);
      final authProvider = context.read<AuthProvider>();
      // Call the delete account API or perform the deletion logic here
      final response =  await authProvider.deleteAccount();

      if (response) {
        await EasyLoading.showSuccess(AppLocalizations.of(context)!.deleteAccountSuccess);
        // return back to login
        context.goNamed(APP_PAGES.splash.toName);
      } else {
        Utils.showError(context, authProvider.error ?? "");
      }

      await EasyLoading.dismiss();
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
