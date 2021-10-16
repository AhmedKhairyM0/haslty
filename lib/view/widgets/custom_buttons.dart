import 'package:flutter/material.dart';

class GeneralButton extends StatelessWidget {
  const GeneralButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.splashColor = Colors.white60,
  }) : super(key: key);

  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color splashColor;
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: double.infinity,
      height: 40,
      buttonColor: backgroundColor,
      splashColor: splashColor,
      child: ElevatedButton(
        child: Text(label,
            style: Theme.of(context)
                .textTheme
                .button!
                .copyWith(color: Colors.white)),
        onPressed: onPressed,
      ),
    );
  }
}



class CircleButton extends StatelessWidget {
  const CircleButton({
    Key? key,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: color,
        radius: 25,
      ),
    );
  }
}
