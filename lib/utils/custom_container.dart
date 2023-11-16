import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final Widget? child;

  const CustomContainer({
    super.key,
    required this.height,
    required this.width,
    required this.color,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      width: MediaQuery.of(context).size.width * width,
      height: MediaQuery.of(context).size.height * height,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF000000),
          width: 3,
        ),
      color: color,
      ),
      child: child,
    );
  }
}
