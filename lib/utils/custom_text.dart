import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight weight;
  final TextAlign align;

  const CustomText({
    super.key,
    required this.text,
    this.size = 30,
    this.color = const Color(0xFF1F2D33),
    this.weight = FontWeight.normal,
    this.align = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        fontSize: size,
        color: color,
        fontWeight: weight,
        fontFamily: 'JetBrains Mono',
        fontStyle: FontStyle.normal,
      ),
    );
  }
}
