import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wifi_geo_map/Screens/path_page.dart';
import 'package:wifi_geo_map/Screens/skeleton_page.dart';
import 'package:wifi_geo_map/utils/custom_sizedbox.dart';
import 'package:wifi_geo_map/utils/custom_text.dart';
import 'package:wifi_scan/wifi_scan.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;

  Future<void> _startScan(BuildContext context) async {
    await WiFiScan.instance.canStartScan();
    await WiFiScan.instance.startScan();
    setState(() => accessPoints = <WiFiAccessPoint>[]);
  }

  Future<bool> _canGetScannedResults(BuildContext context) async {
    await WiFiScan.instance.canGetScannedResults();

    return true;
  }

  Future<void> _startListeningToScanResults(BuildContext context) async {
    if (await _canGetScannedResults(context)) {
      subscription = WiFiScan.instance.onScannedResultsAvailable
          .listen((result) => setState(() => accessPoints = result));
    }
  }

  void _stopListeningToScanResults() {
    subscription?.cancel();
    setState(() => subscription = null);
  }

  @override
  void initState() {
    super.initState();
    _startScan(context);
    _startListeningToScanResults(context);

    Timer.periodic(const Duration(seconds: 180), (timer) {
      _startScan(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _stopListeningToScanResults();
  }

  @override
  Widget build(BuildContext context) {
    return SkeletonPage(
      isSearching: true,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.08,
          vertical: MediaQuery.of(context).size.height * 0.03,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomText(
                text: 'List of Access Points',
                size: 40,
              ),
              const CustomSizedBox(height: 0.03, width: 1),
              Table(
                border: TableBorder.symmetric(
                  outside: const BorderSide(
                    color: Colors.black,
                    width: 3,
                  ),
                  inside: const BorderSide(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                children: buildTableRows(),
              ),
              const CustomSizedBox(height: 0.05, width: 1),
              InkWell(
                onTap: () {
                  Map<int, List<String>> top3 = buildTop3List();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PathPage(top3: top3,)),
                  );
                },
                child: const Icon(
                  Icons.location_on,
                  size: 45,
                  color: Color(0xFF000000),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<TableRow> buildTableRows() {
    List<TableRow> rows = [];

    rows.add(
      TableRow(
        children: [
          'Name',
          'BSSID',
          'Strength',
        ]
            .map(
              (header) => TableCell(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.03,
                    top: MediaQuery.of(context).size.height * 0.01,
                    bottom: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: CustomText(
                    text: header,
                    size: 19,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );

    for (WiFiAccessPoint element in accessPoints) {
      rows.add(
        TableRow(
          children: [
            element.ssid,
            element.bssid,
            " ${element.level.toString()} dBm",
          ]
              .map(
                (data) => TableCell(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.03,
                      bottom: MediaQuery.of(context).size.height * 0.025,
                    ),
                    child: CustomText(
                      text: data,
                      size: 17,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    }

    return rows;
  }

  Map<int, List<String>> buildTop3List() {
    accessPoints.sort((a, b) => b.level.compareTo(a.level));

    final top3 = accessPoints.take(3).toList();
    List<String> bssids = [];
    int strength = 0;
    for (var ap in top3) {
      bssids.add(ap.bssid);
      strength += ap.level;
    }

    return {strength ~/ 3 : bssids};
  }
}
