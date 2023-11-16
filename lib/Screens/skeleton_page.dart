import 'package:flutter/material.dart';
import 'package:wifi_geo_map/Screens/home_page.dart';
import 'package:wifi_geo_map/Screens/settings_page.dart';
import 'package:wifi_geo_map/Screens/userprofile_page.dart';
import 'package:wifi_geo_map/utils/custom_inkwell.dart';
import 'package:wifi_geo_map/utils/custom_sizedbox.dart';

class SkeletonPage extends StatefulWidget {
  final bool isSearching;
  final Widget child;
  const SkeletonPage(
      {super.key, required this.isSearching, required this.child});

  @override
  State<SkeletonPage> createState() => _SkeletonPageState();
}

class _SkeletonPageState extends State<SkeletonPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bool isSearching = widget.isSearching;
    final Widget customChild = widget.child;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assests/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.08,
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.08,
                ),
                child: isSearching
                    ? InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF8183),
                            border: Border.all(
                              color: const Color(0xFF000000),
                              width: 3,
                            ),
                          ),
                          child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                                hintText: '  Search for a user',
                                hintStyle: TextStyle(
                                  fontFamily: 'JetBrains Mono',
                                  fontStyle: FontStyle.normal,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.search,
                                  size: 30,
                                  color: Color(0xFF000000),
                                )),
                          ),
                        ),
                      )
                    : const CustomSizedBox(height: 0.07, width: 1),
              ),
              CustomSizedBox(
                height: 0.74,
                width: 1,
                child: customChild,
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFF000000),
                      width: 3.0,
                    ),
                  ),
                ),
                child: const CustomSizedBox(
                  height: 0.1,
                  width: 1,
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomInkWell(
                          icon: Icons.settings, pageName: SettingsPage()),
                      CustomInkWell(icon: Icons.home, pageName: HomePage()),
                      CustomInkWell(
                          icon: Icons.person, pageName: UserPage()),
                    ],
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
