import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_geo_map/Screens/loading_page.dart';
import 'package:wifi_geo_map/Screens/skeleton_page.dart';
import 'package:wifi_geo_map/provider/controller.dart';
import 'package:wifi_geo_map/provider/googel_signin.dart';
import 'package:wifi_geo_map/utils/custom_container.dart';
import 'package:wifi_geo_map/utils/custom_sizedbox.dart';
import 'package:wifi_geo_map/utils/custom_text.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SkeletonPage(
        isSearching: false,
        child: Column(
          children: [
            const CustomSizedBox(height: 0.1, width: 1),
            const CustomText(
              text: "Settings",
              size: 50,
            ),
            const CustomSizedBox(height: 0.05, width: 1),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoadingPage(isNeeded: true)),
                );
              },
              child: const CustomContainer(
                height: 0.07,
                width: 0.8,
                color: Color(0xFFFFF8E8),
                child: Center(
                  child: CustomText(
                    text: "Privacy Policy",
                    size: 20,
                  ),
                ),
              ),
            ),
            const CustomSizedBox(height: 0.05, width: 1),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoadingPage(isNeeded: true)),
                );
              },
              child: const CustomContainer(
                height: 0.07,
                width: 0.8,
                color: Color(0xFFFFF8E8),
                child: Center(
                  child: CustomText(
                    text: "About",
                    size: 20,
                  ),
                ),
              ),
            ),
            const CustomSizedBox(height: 0.05, width: 1),
            InkWell(
              onTap: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.logout();
                Timer(const Duration(milliseconds: 900), () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ControllerPage(),
                    ),
                  );
                });
              },
              child: const CustomContainer(
                height: 0.07,
                width: 0.8,
                color: Color(0xFFFFF8E8),
                child: Center(
                  child: CustomText(
                    text: "Log Out",
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
