import 'package:flutter/material.dart';

import '../../core/core.dart';

class FractionalExpenses extends StatelessWidget {
  const FractionalExpenses({
    Key? key,
    required this.expenses,
    required this.balance,
    required this.day,
    required this.selectedColor,
  }) : super(key: key);

  final double expenses;
  final double balance;
  final String day;
  final Color selectedColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('\$${expenses.toStringAsFixed(0)}',
            style: Styles.kSubtitleTextStyle),
        _FractionalBar(
          total: balance <= 0 ? 1 : balance,
          value: expenses,
          selectedColor: selectedColor,
        ),
        Text(day, style: Styles.kSubtitleTextStyle),
      ],
    );
  }
}

class _FractionalBar extends StatelessWidget {
  const _FractionalBar({
    Key? key,
    this.widthBar = 10.0,
    this.heightBar = 70.0,
    this.radius = 20.0,
    this.selectedColor = Palette.kPrimaryColor,
    this.unSelectedColor = Palette.kSecondaryColor,
    required this.total,
    required this.value,
  }) : super(key: key);

  final double widthBar;
  final double heightBar;
  final double radius;
  final Color selectedColor;
  final Color? unSelectedColor;
  final double total;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Stack(
        children: [
          Container(
            width: widthBar,
            height: heightBar,
            decoration: BoxDecoration(
              color: unSelectedColor,
              borderRadius: BorderRadius.all(Radius.circular(radius)),
              border: Border.all(color: Palette.kSecondaryColor),
            ),
          ),
          Container(
            width: widthBar,
            height: value / total * heightBar >= heightBar
                ? heightBar
                : value / total * heightBar,
            decoration: BoxDecoration(
              color: selectedColor,
              borderRadius: BorderRadius.all(Radius.circular(radius)),
            ),
          ),
        ],
      ),
    );
  }
}
