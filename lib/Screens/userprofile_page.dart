import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wifi_geo_map/Screens/skeleton_page.dart';
import 'package:wifi_geo_map/provider/controller.dart';
import 'package:wifi_geo_map/provider/googel_signin.dart';
import 'package:wifi_geo_map/utils/custom_container.dart';
import 'package:wifi_geo_map/utils/custom_sizedbox.dart';
import 'package:wifi_geo_map/utils/custom_text.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final user = FirebaseAuth.instance.currentUser!;
  ControllerPage controll() => const ControllerPage();
  String _wifi = 'Unknown';
  String _bssid = 'Unknown';
  String _classroom = 'Unknown';
  final NetworkInfo _networkInfo = NetworkInfo();

  @override
  void initState() {
    super.initState();
    _initNetworkInfo();
    _sendHttpRequest();
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonPage(
      isSearching: false,
      child: SingleChildScrollView(
        child: Column(
          children: [
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
                 CustomContainer(
                  height: 0.14,
                  width: 0.8,
                  color: const Color(0xFF93D3D3),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: CustomText(text: 'Your Location'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 18.0),
                        child: CustomText(
                          text: "Classroom $_classroom",
                          weight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const CustomSizedBox(height: 0.05, width: 1),
                CustomContainer(
                  height: 0.18,
                  width: 0.8,
                  color: const Color(0xFFFF8183),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: CustomText(text: 'Connected To'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 18.0),
                        child: Column(
                          children: [
                            CustomText(
                              text: 'Wi-Fi: $_wifi',
                              size: 20,
                              weight: FontWeight.w600,
                            ),
                            const CustomSizedBox(height: 0.01, width: 0.5),
                            CustomText(
                              text: 'BSSID: $_bssid',
                              size: 19,
                              weight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const CustomSizedBox(height: 0.015, width: 1),
                ElevatedButton(
                  onPressed: () {
                    _initNetworkInfo();
                    _sendHttpRequest(); 
                  },
                  child: const Text("Refresh"),
                ),
                const CustomSizedBox(height: 0.03, width: 1),
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
                      shadowColor: Colors.black,
                    ),
                    icon: const Icon(Icons.logout, size: 30),
                    onPressed: () {
                      final provider = Provider.of<GoogleSignInProvider>(
                        context,
                        listen: false,
                      );
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
                const CustomSizedBox(height: 0.03, width: 1),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _initNetworkInfo() async {
    String? wifiName, wifiBSSID;

    // Request location permissions
    final locationStatus = await Permission.location.request();
    if (locationStatus.isGranted) {
      try {
        if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
          wifiName = await _networkInfo.getWifiName();
          wifiBSSID = await _networkInfo.getWifiBSSID();
        } else {
          wifiName = await _networkInfo.getWifiName();
          wifiBSSID = await _networkInfo.getWifiBSSID();
        }
      } on PlatformException catch (e) {
        stdout.writeln(e.toString());
        wifiName = 'Failed to get Wifi Name';
        wifiBSSID = 'Failed to get Wifi BSSID';
      }
    } else {
      wifiName = 'Location permission not granted';
      wifiBSSID = 'Location permission not granted';
    }

    setState(() {
      _wifi = wifiName!;
      _bssid = wifiBSSID!;
    });
  }

  Future<void> _sendHttpRequest() async {
    final url = Uri.parse('http://192.168.50.146:5000/process_input');
    final body = jsonEncode({
      'intensity': 65,
      'bssid': _bssid.toString(),
    });

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );

      if (response.statusCode == 200) {
         stdout.writeln('Response: ${response.body}');
      } else {
         stdout.writeln('Request failed with status: ${response.statusCode}');
      }

      setState(() {
        _classroom = response.body.split(",")[1].split('"')[3];
      });
    } catch (e) {
      stdout.writeln('Error during HTTP request: $e');
    }
  }
}
