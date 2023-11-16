import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wifi_geo_map/utils/custom_sizedbox.dart';
import 'package:wifi_geo_map/utils/custom_text.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  IconData currentIcon = Icons.wifi;
  int iconIndex = 0;
  List<IconData> iconList = [
    Icons.wifi,
    Icons.wifi_1_bar,
    Icons.wifi_2_bar,
    Icons.wifi_password
  ];

  @override
  void initState() {
    super.initState();
    startAnimation();
  }

  void startAnimation() {
    Timer.periodic(const Duration(milliseconds: 770), (timer) {
      setState(() {
        currentIcon = iconList[iconIndex];
        iconIndex = (iconIndex + 1) % iconList.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assests/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          const CustomSizedBox(height: 0.17, width: 1),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1),
            child: const CustomText(text: "Loading...", size: 50),
          ),
          const CustomSizedBox(height: 0.12, width: 1),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1),
            child: const CustomText(
                text: "Please enable location services",
                size: 28,
                weight: FontWeight.w600),
          ),
          CustomSizedBox(
            height: 0.40,
            width: 1,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                currentIcon,
                key: ValueKey<IconData>(currentIcon),
                size: 100,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}