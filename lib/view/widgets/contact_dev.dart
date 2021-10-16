import 'package:expense_tracker/core/palette.dart';
import 'package:expense_tracker/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactWithDev extends StatelessWidget {
  const ContactWithDev({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.contactUs,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(FontAwesomeIcons.google, color: Colors.red),
              onPressed: () async {
                await urlLaunch("mailto:ahmedkhairym0@gmail.com");
              },
            ),
            IconButton(
              icon: const Icon(FontAwesomeIcons.github),
              onPressed: () async {
                await urlLaunch("https://github.com/AhmedKhairyM0");
              },
            ),
            IconButton(
              icon: Icon(FontAwesomeIcons.linkedin, color: Colors.blue[800]),
              onPressed: () async {
                await urlLaunch(
                    "https://www.linkedin.com/in/ahmed-khairy-a4075b174/");
              },
            ),
          ],
        ),
      ],
    );
  }

  Future urlLaunch(String url, [bool inApp = false]) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceWebView: inApp,
        forceSafariVC: inApp,
        enableJavaScript: true,
      );
    }
  }
}
