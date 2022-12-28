import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton(
      {Key? key,
      required this.title,
      required this.color,
      required this.onPressed,
      required this.textColor,
      required this.fontSize})
      : super(key: key);

  final Color color;
  final String title;
  final Color textColor;
  final double fontSize;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.04),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.width * 0.05,
          child: Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
