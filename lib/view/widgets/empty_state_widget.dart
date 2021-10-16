import 'package:expense_tracker/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    Key? key,
    required this.image,
    required this.caption,
    this.isSvg = false,
  }) : super(key: key);

  final String image;
  final String caption;

  final bool isSvg;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Builder(builder: (context) {
              if (isSvg) {
                return SvgPicture.asset(
                  image,
                  width: 300,
                  height: 500,
                );
              }
              return Image.asset(
                image,
                width: 300,
                height: 500,
              );
            }),
            Text(
              caption,
              style: const TextStyle(
                fontSize: 22,
                color: Palette.kSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
