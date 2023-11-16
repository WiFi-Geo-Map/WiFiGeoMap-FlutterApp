import 'package:flutter/material.dart';

class CustomSizedBox extends StatelessWidget {
  final double height;
  final double width;
  final Widget? child;

  const CustomSizedBox({
    super.key,
    required this.height,
    required this.width,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * height,
      width: MediaQuery.of(context).size.width * width,
      child: child,
    );
  }
}
