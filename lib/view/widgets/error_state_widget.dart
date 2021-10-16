import 'package:expense_tracker/core/core.dart';
import 'package:expense_tracker/core/utils/utils.dart';
import 'package:expense_tracker/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    Key? key,
    required this.errorMessage,
  }) : super(key: key);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context)!.titleReportBugs,
            style: const TextStyle(fontSize: 22, color: Palette.kRefuseColor),
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.contentReportBugs,
            style:
                const TextStyle(fontSize: 22, color: Palette.kSecondaryColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          OutlinedButton(
            child: Text(AppLocalizations.of(context)!.report,
                style: const TextStyle(fontSize: 18)),
            onPressed: () async {
              await Utils.reportBugs(subject: errorMessage, body: errorMessage);
            },
          ),
        ],
      ),
    );
  }
}
