import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  NetworkHelper(this.url);
  final Uri url;

  Future<dynamic> getData() async {
    try {
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        String data = response.body;
        return jsonDecode(data);
      } else {
        print(
            'Failed to load weather data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      return null;
    }
  }
}
