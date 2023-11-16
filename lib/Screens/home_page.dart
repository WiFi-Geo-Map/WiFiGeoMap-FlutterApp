import 'package:flutter/material.dart';
import 'package:wifi_geo_map/Screens/loading_page.dart';
import 'package:wifi_geo_map/Screens/skeleton_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    return const SkeletonPage(isSearching: true, child: LoadingPage(isNeeded: false,) );
  }
}
