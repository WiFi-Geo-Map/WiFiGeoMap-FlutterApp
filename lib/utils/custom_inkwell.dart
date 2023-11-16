import 'package:flutter/material.dart';

class CustomInkWell extends StatelessWidget {
  final IconData icon;
  final Widget pageName;

  const CustomInkWell({
    Key? key,
    required this.icon,
    required this.pageName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
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
