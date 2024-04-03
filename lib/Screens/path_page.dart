import 'package:flutter/material.dart';
import 'provider/googel_signin.dart';
import 'firebase_options.dart';

class ShortestPathPage extends StatefulWidget {
  @override
  _ShortestPathPageState createState() => _ShortestPathPageState();
}

class _ShortestPathPageState extends State<ShortestPathPage> {
  final _bs1Controller = TextEditingController();
  final _bs2Controller = TextEditingController();
  final _bs3Controller = TextEditingController();
  final _inten1Controller = TextEditingController();
  // final _inten2Controller = TextEditingController();
  // final _inten3Controller = TextEditingController();
  final _destController = TextEditingController();

  List<String> _shortestPath = [];

  Future<void> _processInput() async {
    final bs1 = _bs1Controller.text;
    final bs2 = _bs2Controller.text;
    final bs3 = _bs3Controller.text;
    final inten1 = int.parse(_inten1Controller.text);
    // final inten2 = int.parse(_inten2Controller.text);
    // final inten3 = int.parse(_inten3Controller.text);
    final dest = _destController.text;

    try {
      // Fetch data from Firebase Firestore
      final snapshot = await FirebaseFirestore.instance.collection('regions').doc('$bs1-$inten1').get();
      print(snapshot.data());
      if (snapshot.exists) {
        final data = snapshot.data()!;
        // Assuming your Firestore document structure matches the expected JSON format
        setState(() {
          _shortestPath = List<String>.from(data['shortest_path']);
        });
      } else {
        // Handle document not found
      }
    } catch (e) {
      // Handle errors
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shortest Path'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _bs1Controller,
              decoration: InputDecoration(
                labelText: 'BSSID 1',
              ),
            ),
            TextField(
              controller: _inten1Controller,
              decoration: InputDecoration(
                labelText: 'inten1',
              ),
            ),
            // Other text fields...
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _processInput,
              child: Text('Get Shortest Path'),
            ),
            SizedBox(height: 16.0),
            if (_shortestPath.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shortest Path:'),
                  SizedBox(height: 8.0),
                  ..._shortestPath.map((step) => Text('- $step')).toList(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
