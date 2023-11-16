import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_geo_map/Screens/skeleton_page.dart';
import 'package:wifi_geo_map/provider/controller.dart';
import 'package:wifi_geo_map/provider/googel_signin.dart';
import 'package:wifi_geo_map/utils/custom_container.dart';
import 'package:wifi_geo_map/utils/custom_sizedbox.dart';
import 'package:wifi_geo_map/utils/custom_text.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final user = FirebaseAuth.instance.currentUser!;
  ControllerPage controll() => const ControllerPage();

  @override
  Widget build(BuildContext context) {
    return SkeletonPage(
        isSearching: false,
        child: SingleChildScrollView(
          child: Column(children: [
            Column(
              children: [
                CustomSizedBox(
                  width: 0.5,
                  height: 0.24,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.photoURL!),
                  ),
                ),
                const CustomSizedBox(
                  height: 0.03,
                  width: 1,
                ),
                CustomText(
                  text: user.displayName!,
                  size: 25,
                  weight: FontWeight.bold,
                ),
                const CustomSizedBox(
                  height: 0.015,
                  width: 1,
                ),
                CustomText(
                  text: user.email!.split('@')[0],
                  size: 25,
                ),
                const CustomSizedBox(
                  height: 0.05,
                  width: 1,
                ),
                const CustomContainer(
                  height: 0.14,
                  width: 0.8,
                  color: Color(0xFF93D3D3),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: CustomText(text: 'Your Loaction'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 18.0),
                        child: CustomText(text: 'CLH2 Grid(x,y)', weight: FontWeight.w600),
                      ),

                    ],
                  ),
                ),
                const CustomSizedBox(height: 0.05, width: 1),
                const CustomContainer(
                  height: 0.18,
                  width: 0.8,
                  color: Color(0xFF93D3D3),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: CustomText(text: 'Connected To'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0, left: 18.0),
                        child: Column(
                          children: [
                            CustomText(text: 'Wi-Fi: ',size: 25, weight: FontWeight.w600),
                            CustomSizedBox(height: 0.01, width: 0.5),
                            CustomText(text: 'BSSID: ',size: 25, weight: FontWeight.w600),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                const CustomSizedBox(height: 0.05, width: 1),

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
                            Size(MediaQuery.of(context).size.width * 0.5, 50),
                        shadowColor: Colors.black),
                    icon: const Icon(Icons.logout, size: 30),
                    onPressed: () {
                      final provider = Provider.of<GoogleSignInProvider>(
                          context,
                          listen: false);
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
                    label: const CustomText(text: " Log out", size: 20),
                  ),
                ),
                const CustomSizedBox(height: 0.05, width: 1),
              ],
            )
          ]),
        ));
  }
}
