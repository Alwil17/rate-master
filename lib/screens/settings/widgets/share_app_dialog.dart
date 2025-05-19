import 'package:flutter/material.dart';
import 'package:rate_master/generated/assets.dart';
import 'package:rate_master/shared/constants/constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShareAppDialog extends StatefulWidget {
  static const double _padding = 20;

  const ShareAppDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<ShareAppDialog> createState() => _ShareAppDialogState();
}

class _ShareAppDialogState extends State<ShareAppDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.center,
        child: contentBox(context),
      ),
    );
  }

  Widget contentBox(context) {
    return Container(
      padding: const EdgeInsets.all(ShareAppDialog._padding),
      margin: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(ShareAppDialog._padding),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 10),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              Assets.imagesShootingStar,
              height: 175,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            Constants.appName,
            style: TextStyle(
                fontSize: 24,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                color: Color(0xff056380)),
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.share,
            style: TextStyle(fontSize: 18, fontFamily: 'OpenSans'),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff79a5b4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  icon: Icon(Icons.close, color: Color(0xff056380)),
                  label: Text(
                    AppLocalizations.of(context)!.cancel,
                    style:
                        const TextStyle(fontSize: 18, color: Color(0xff056380)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final shareResult = await SharePlus.instance.share(
                      ShareParams(
                        text:
                            "${AppLocalizations.of(context)!.shareMessage} : https://play.google.com/store/apps/details?id=com.grey.rate_master",
                      ),
                    );
                    if (shareResult.status == ShareResultStatus.success) {
                      // Handle success
                      print("succeed");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffd9e8ee),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  icon: Icon(Icons.share, color: Color(0xff056380)),
                  label: Text(
                    AppLocalizations.of(context)!.share,
                    style:
                        const TextStyle(fontSize: 18, color: Color(0xff056380)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
