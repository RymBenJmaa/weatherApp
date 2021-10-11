import 'package:weather_app/src/services/services.dart';

class City {
  String country;
  String name;
  String latitude;
  String longitude;

  City({
    required this.country,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory City.fromJson(Map<String, dynamic> parsedJson) {
    return City(
      country: parsedJson['country'] as String,
      name: parsedJson['name'] as String,
      latitude: parsedJson['lat'] as String,
      longitude: parsedJson['lng'] as String,
    );
  }

  static Future<List<String>> getSuggestions(String query) async {
    List<String> matches = <String>[];
    try {
      List<String> citiesNames = <String>[];
      List<City> cities = await Services.fetchCities();
      for (int i = 0; i < cities.length; i++) {
        citiesNames.add(cities[i].name);
      }
      matches.addAll(citiesNames);

      matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    } catch (e) {
      print('>>>>>>>>>> error getting suggestions and parsing cities file \n $e');
    }

    return matches;
  }
}
