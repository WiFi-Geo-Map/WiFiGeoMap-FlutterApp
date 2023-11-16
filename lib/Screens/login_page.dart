import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_geo_map/provider/googel_signin.dart';
import 'package:wifi_geo_map/utils/custom_sizedbox.dart';
import 'package:wifi_geo_map/utils/custom_text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  IconData currentIcon = Icons.wifi;
  int iconIndex = 0;
  List<IconData> iconList = [
    Icons.wifi,
    Icons.wifi_1_bar,
    Icons.wifi_2_bar,
    Icons.wifi,
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
            child: const CustomText(text: "Welcome User!", size: 60),
          ),
          const CustomSizedBox(height: 0.1, width: 1),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1),
            child: const CustomText(
                text: "Login Using IITH email",
                size: 23,
                weight: FontWeight.w600),
          ),
          CustomSizedBox(
            height: 0.27,
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
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFF000000),
                width: 3,
              ),
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.8, 50),
                  shadowColor: Colors.black),
              icon: const Icon(Icons.g_mobiledata_outlined, size: 50),
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin();
              },
              label: const CustomText(text: "Google Sign-in", size: 20),
            ),
          )
        ]),
      ),
    );
  }
}
