import 'package:flutter/material.dart';
import 'package:wifi_geo_map/Screens/loading_page.dart';
import 'package:wifi_geo_map/Screens/skeleton_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SkeletonPage(isSearching: false, child: LoadingPage(isNeeded: false,));
  }
}