import 'package:http/http.dart' as http;
import 'ratesmodel.dart';

Future<RatesModel> fetchRate() async {
  final response = await http.get(Uri.parse(
    'https://openexchangerates.org/api/latest.json?app_id=df73b702ba724a749d30bb821962f07f',
  ));

  if (response.statusCode == 200) {
    print(response.body);
    final result = ratesModelFromJson(response.body);
    return result; 
  } else {
    throw Exception('Failed to load exchange rates'); // ✅ Handle failure case
  }
}
