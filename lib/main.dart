import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wifi_geo_map/provider/controller.dart';
import 'provider/googel_signin.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const WiFiGeoMap());
}

class WiFiGeoMap extends StatelessWidget {
  const WiFiGeoMap({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context)=> GoogleSignInProvider(),
     child : GetMaterialApp(
      title: 'WiFi Geo Map',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch:Colors.blueGrey,
      ),
      home: const ControllerPage(),
    ),
  );
}