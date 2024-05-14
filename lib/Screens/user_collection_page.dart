import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:wifi_scan/wifi_scan.dart';

class UserCollectionPage extends StatefulWidget {
  const UserCollectionPage({super.key});

  @override
  State<UserCollectionPage> createState() => _UserCollectionPageState();
}

class _UserCollectionPageState extends State<UserCollectionPage> {
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;

  int _activeTileIndex = -1;

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

  void _setActiveTileIndex(int index) {
    setState(() {
      _activeTileIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, int>> top3 = buildTop3List(accessPoints);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data collection screen'),
      ),
      body: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HexagonOffsetGrid.oddPointy(
                columns: 8,
                rows: 8,
                buildTile: (row, col) => HexagonWidgetBuilder(
                  color: row+col == _activeTileIndex ? Colors.yellow : Colors.orangeAccent,
                  elevation: 2,
                ),
                buildChild: (col, row) {
                  return Text('$col, $row');
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTop3ListWidget(top3),
        ],
      ),
    );
  }

  Widget _buildTop3ListWidget(List<Map<String, int>> top3) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top 3 BSSIDs and intensities:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: top3.map((ap) {
            return Text(
              '${ap.keys.first}: ${ap.values.first}',
              style: const TextStyle(fontSize: 14),
            );
          }).toList(),
        ),
      ],
    );
  }

  List<Map<String, int>> buildTop3List(List<WiFiAccessPoint> accessPoints) {
    accessPoints.sort((a, b) => b.level.compareTo(a.level));

    final top3 = accessPoints.take(3).toList();

    List<Map<String, int>> result = [];

    for (var ap in top3) {
      result.add({ap.bssid: ap.level});
    }

    return result;
  }
}

class HoneycombTile extends StatelessWidget {
  final int index;
  final bool isActive;
  final Function(int) setActiveTileIndex;
  final List<WiFiAccessPoint> accessPoints;

  const HoneycombTile({
    super.key,
    required this.index,
    required this.isActive,
    required this.setActiveTileIndex,
    required this.accessPoints,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setActiveTileIndex(index);
      },
      child: Container(
        color: isActive ? Colors.green : Colors.blue,
        child: Center(
          child: Text(
            'Tile ${index + 1}',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
