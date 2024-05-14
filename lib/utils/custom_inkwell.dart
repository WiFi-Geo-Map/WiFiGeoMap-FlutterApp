import 'package:flutter/material.dart';

class CustomInkWell extends StatelessWidget {
  final IconData icon;
  final Widget pageName;

  const CustomInkWell({
    super.key,
    required this.icon,
    required this.pageName,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => pageName),
        );
      },
      child: Icon(
        icon,
        size: 32,
        color: const Color(0xFF000000),
      ),
    );
  }
}
