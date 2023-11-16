import 'package:flutter/material.dart';
import 'package:wifi_geo_map/Screens/skeleton_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return const SkeletonPage(isSearching: false, child: Center(child: Text("user Page"),));
  }
}