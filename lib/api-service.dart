import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Map<String, String>>> fetchData() async {
  var url = Uri.parse('http://localhost:4000/getTimes');

  try {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);

      List<Map<String, String>> registros = data.map((item) {
        return {
          'Tiempo': item['time'].toString(),
        };
      }).toList();

      return registros;
    } else {
      print('Error: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error fetching data: $e');
    return [];
  }
}
