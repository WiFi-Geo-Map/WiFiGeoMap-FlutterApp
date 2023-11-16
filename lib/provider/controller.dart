import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wifi_geo_map/Screens/home_page.dart';
import 'package:wifi_geo_map/Screens/loading_page.dart';
import 'package:wifi_geo_map/Screens/login_page.dart';

class ControllerPage extends StatelessWidget {
  const ControllerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPage();
          } else if (snapshot.hasData) {
            return const HomePage();
          } else if (snapshot.hasError) {
            return const Center(
              child: Center(
                child: Text("Something went wrong"),
              ),
            );
          }else{
          return const LoginPage();
          }
        },
      ),
    );
  }
}
