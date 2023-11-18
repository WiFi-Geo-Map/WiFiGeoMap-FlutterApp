
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class CheckApi {
  static Future<void> checkConnection() async {
    try {
      final url = Uri.parse('http://192.168.50.146:5000/process_input');
      final body = jsonEncode({
        'intensity': 65,
        'bssid': '38:17:c3:f2:50:22',
      });

      final response = await http.post(url, body: body, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        stdout.writeln(response.body);
      } else {
        stdout.writeln(response.body);
      }
    } catch (e) {
      stdout.writeln(e.toString());
    }
  }
}
