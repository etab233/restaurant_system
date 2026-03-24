import 'package:http/http.dart' as http;
import 'package:restaurants_system/constants.dart';

class SearchServices {
  Future<http.Response> search({required String query})async {
    final url = Uri.parse("${Constants.baseUrl}/search?q=$query");
    return await http.get(
      url,
      headers: {
        'Accept': 'application/json',
      },
    );
  }
}
