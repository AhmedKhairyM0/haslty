import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future showCustomDialog(
    BuildContext context, {
    String? title,
    Widget? content,
    List<Widget>? actions,
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: title != null ? Text(title) : null, //${cubit.expense.title}
            content: content,
            actions: actions,
          );
        });
  }

  static showCustomSnackBar(BuildContext context, String title) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(title),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  static toAndFinish(BuildContext context, String routeName) =>
      Navigator.pushNamedAndRemoveUntil(
        context,
        routeName,
        (_) => false,
      );

  static to(BuildContext context, String routeName) => Navigator.pushNamed(
        context,
        routeName,
      );


static Future reportBugs({
  required String subject,
  required String body,
}) async {
  String url =
      'mailto:expensetracker.app0@gmail.com?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';
  if (await canLaunch(url)) {
    await launch(url);
  }
}
}
