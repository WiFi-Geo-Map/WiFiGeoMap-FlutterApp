import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';

void main() {
  runApp(const MyApp());
}

/// Example app for wifi_scan plugin.
class MyApp extends StatefulWidget {
  /// Default constructor for [MyApp] widget.
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];
  StreamSubscription<List<WiFiAccessPoint>>? subscription;
  bool shouldCheckCan = true;

  bool get isStreaming => subscription != null;

  Future<void> _startScan(BuildContext context) async {
    // check if "can" startScan
    if (shouldCheckCan) {
      // check if can-startScan
      final can = await WiFiScan.instance.canStartScan();
      // if can-not, then show error
      if (can != CanStartScan.yes) {
        if (mounted) kShowSnackBar(context, "Cannot start scan: $can");
        return;
      }
    }

    // call startScan API
    final result = await WiFiScan.instance.startScan();
    if (mounted) kShowSnackBar(context, "startScan: $result");
    // reset access points.
    setState(() => accessPoints = <WiFiAccessPoint>[]);
  }

  Future<bool> _canGetScannedResults(BuildContext context) async {
    if (shouldCheckCan) {
      // check if can-getScannedResults
      final can = await WiFiScan.instance.canGetScannedResults();
      // if can-not, then show error
      if (can != CanGetScannedResults.yes) {
        if (mounted) kShowSnackBar(context, "Cannot get scanned results: $can");
        accessPoints = <WiFiAccessPoint>[];
        return false;
      }
    }
    return true;
  }

  Future<void> _getScannedResults(BuildContext context) async {
    if (await _canGetScannedResults(context)) {
      // get scanned results
      final results = await WiFiScan.instance.getScannedResults();
      setState(() => accessPoints = results);
    }
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
  void dispose() {
    super.dispose();
    // stop subscription for scanned results
    _stopListeningToScanResults();
  }

  // build toggle with label
  Widget _buildToggle({
    String? label,
    bool value = false,
    ValueChanged<bool>? onChanged,
    Color? activeColor,
  }) =>
      Row(
        children: [
          if (label != null) Text(label),
          Switch(value: value, onChanged: onChanged, activeColor: activeColor),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Wifi details fetcher'),
          actions: [
            _buildToggle(
                label: "Check can?",
                value: shouldCheckCan,
                onChanged: (v) => setState(() => shouldCheckCan = v),
                activeColor: Colors.purple)
          ],
        ),
        body: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.perm_scan_wifi),
                      label: const Text('SCAN'),
                      onPressed: () async => _startScan(context),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('GET'),
                      onPressed: () async => _getScannedResults(context),
                    ),
                    _buildToggle(
                      label: "STREAM",
                      value: isStreaming,
                      onChanged: (shouldStream) async => shouldStream
                          ? await _startListeningToScanResults(context)
                          : _stopListeningToScanResults(),
                    ),
                  ],
                ),
                const Divider(),
                Flexible(
                  child: Center(
                    child: accessPoints.isEmpty
                        ? const Text("NO SCANNED RESULTS")
                        : ListView.builder(
                            itemCount: accessPoints.length,
                            itemBuilder: (context, i) =>
                                _AccessPointTile(accessPoint: accessPoints[i])),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Show tile for AccessPoint.
///
/// Can see details when tapped.
class _AccessPointTile extends StatelessWidget {
  final WiFiAccessPoint accessPoint;

  const _AccessPointTile({Key? key, required this.accessPoint})
      : super(key: key);

  // build row that can display info, based on label: value pair.
  Widget _buildInfo(String label, dynamic value) => Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          children: [
            Text(
              "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(child: Text(value.toString()))
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final title = accessPoint.ssid.isNotEmpty ? accessPoint.ssid : "**EMPTY**";
    final signalIcon = accessPoint.level >= -80
        ? Icons.signal_wifi_4_bar
        : Icons.signal_wifi_0_bar;
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: Icon(signalIcon),
      title: Text(title),
      subtitle: Text(accessPoint.capabilities),
      onTap: () => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfo("BSSDI", accessPoint.bssid),
              _buildInfo("Capability", accessPoint.capabilities),
              _buildInfo("frequency", "${accessPoint.frequency}MHz"),
              _buildInfo("level", accessPoint.level),
              _buildInfo("standard", accessPoint.standard),
              _buildInfo(
                  "centerFrequency0", "${accessPoint.centerFrequency0}MHz"),
              _buildInfo(
                  "centerFrequency1", "${accessPoint.centerFrequency1}MHz"),
              _buildInfo("channelWidth", accessPoint.channelWidth),
              _buildInfo("isPasspoint", accessPoint.isPasspoint),
              _buildInfo(
                  "operatorFriendlyName", accessPoint.operatorFriendlyName),
              _buildInfo("venueName", accessPoint.venueName),
              _buildInfo("is80211mcResponder", accessPoint.is80211mcResponder),
            ],
          ),
        ),
      ),
    );
  }
}

/// Show snackbar.
void kShowSnackBar(BuildContext context, String message) {
  if (kDebugMode) print(message);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}


// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:wifi_geo_map/provider/googel_signin.dart';

// import '../provider/controller.dart';

// class UserPage extends StatefulWidget {
//   const UserPage({super.key});

//   @override
//   State<UserPage> createState() => _UserPageState();
// }

// class _UserPageState extends State<UserPage> {
//   final user = FirebaseAuth.instance.currentUser!;

//   ControllerPage controll() => const ControllerPage();

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Column(children: [
//         AppBar(
//           flexibleSpace: Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.blueGrey,
//                   Color.fromARGB(255, 132, 174, 207),
//                   Color.fromARGB(255, 223, 103, 143),
//                 ],
//               ),
//             ),
//           ),
//           elevation: 0.0,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(
//               bottom: Radius.circular(15),
//             ),
//           ),
//           title: const Text(
//             "Profile",
//             style: TextStyle(
//               fontSize: 30,
//               fontFamily: 'Poppins',
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         Container(
//           padding:
//               EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
//           child: Column(
//             children: [
//               SizedBox(
//                 width: 120,
//                 height: 120,
//                 child: CircleAvatar(
//                   backgroundImage: NetworkImage(user.photoURL!),
//                 ),
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.025),
//               Text(
//                 user.displayName!,
//                 style: const TextStyle(
//                   fontSize: 25,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//               Text(
//                 user.email!,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.normal,
//                 ),
//               ),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//               SizedBox(
//                   width: 200,
//                   child: ElevatedButton(
//                     style: ButtonStyle(
//                       backgroundColor:
//                           MaterialStateProperty.all<Color>(Colors.yellow),
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                         RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(18.0),
//                           side: const BorderSide(color: Colors.red),
//                         ),
//                       ),
//                     ),
//                     onPressed: () {},
//                     child: const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 15.0),
//                       child: Text(
//                         "Edit Details",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   )),
//               SizedBox(height: MediaQuery.of(context).size.height * 0.05),
//               SizedBox(
//                 width: 200,
//                 child: ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor:
//                         MaterialStateProperty.all<Color>(Colors.yellow),
//                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                       RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(18.0),
//                         side: const BorderSide(color: Colors.red),
//                       ),
//                     ),
//                   ),
//                   onPressed: () {
//                     final provider = Provider.of<GoogleSignInProvider>(context,
//                         listen: false);
//                     provider.logout();
//                     Timer(const Duration(milliseconds: 1800), () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ControllerPage(),
//                         ),
//                       );
//                       Navigator.pop(context);
//                     });
//                   },
//                   child: const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 15.0),
//                     child: Text(
//                       "Log out",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         )
//       ]),
//     );
//   }
// }
