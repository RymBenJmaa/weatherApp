import 'dart:convert';

import 'package:weather_app/src/models/cities.dart';
import 'package:weather_app/src/models/consolidated_weather.dart';
import 'package:weather_app/src/models/location.dart';
import 'package:weather_app/src/models/sources.dart';
import 'package:weather_app/src/models/weather.dart';
import 'package:http/http.dart' as http;

class Services {
  static List<LocationData> parseLocations(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<LocationData>((json) => LocationData.fromJson(json)).toList();
  }

  static List<ConsolidatedWeatherData> parseConsolidatedWeatherData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ConsolidatedWeatherData>((json) => ConsolidatedWeatherData.fromJson(json)).toList();
  }

  static WeatherData parseWeatherData(String responseBody) {
    final Map<String, dynamic> parsed = jsonDecode(responseBody);

    return WeatherData.fromJson(parsed);
  }

  static List<SourcesData> parseSourcesData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<SourcesData>((json) => SourcesData.fromJson(json)).toList();
  }

  static List<City> parseCities(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<City>((json) => City.fromJson(json)).toList();
  }

  static Future<List<City>> fetchCities() async {
    var url = Uri.parse('https://raw.githubusercontent.com/lutangar/cities.json/master/cities.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return parseCities(response.body);
    } else {
      throw Exception('Unable to fetch cities from the REST API');
    }
  }

  static Future<List<LocationData>> fetchData(String city) async {
    var url = Uri.parse('https://www.metaweather.com/api/location/search/?query=$city');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return parseLocations(response.body);
    } else {
      throw Exception('Unable to fetch location from the REST API');
    }
  }

  static Future<WeatherData> fetchWeatherData(String city) async {
    List<LocationData> location = await fetchData(city);
    if (location.isEmpty) {
      throw Exception('Unavailable city weather');
    } else {
      var url = Uri.parse('https://www.metaweather.com/api/location/${location.first.woeid}');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return parseWeatherData(response.body);
      } else {
        throw Exception('Unable to fetch weather from the REST API');
      }
    }
  }
}
