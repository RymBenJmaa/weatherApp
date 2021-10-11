import 'package:weather_app/src/models/consolidated_weather.dart';
import 'package:weather_app/src/models/location.dart';
import 'package:weather_app/src/models/sources.dart';

class WeatherData extends LocationData {
  ///Time in location
  final DateTime time;

  ///Sunrise time in location
  final DateTime sunRise;

  ///Sunset time in location
  final DateTime sunSet;

  ///Name of the timezone that the location is in
  final String timezoneName;

  ///Parent location
  final LocationData parent;

  ///Weather forecast of the location
  final List<ConsolidatedWeatherData> consolidatedWeathers;

  ///Sources of the Weather forecast of the location
  final SourcesData sources;
  WeatherData({
    title,
    locationType,
    latLong,
    distance,
    woeid,
    required this.sunRise,
    required this.sunSet,
    required this.time,
    required this.timezoneName,
    required this.parent,
    required this.consolidatedWeathers,
    required this.sources,
  }) : super(
            distance: distance ?? -1,
            latLong: latLong ?? '',
            locationType: locationType ?? '',
            title: title ?? '',
            woeid: woeid ?? -1);

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      time: DateTime.parse(json['time'] ?? DateTime.now()),
      sunSet: DateTime.parse(json['sun_set'] ?? DateTime.now()),
      sunRise: DateTime.parse(json['sun_rise'] ?? DateTime.now()),
      timezoneName: json['timezone_name'] ?? '',
      title: json['title'] ?? '',
      woeid: json['woeid'] ?? '',
      parent: LocationData.fromJson(
        json['parent'],
      ),
      consolidatedWeathers: ConsolidatedWeatherData.listFromJson(json),
      sources: SourcesData.fromJson(
        json['sources'][0],
      ),
    );
  }
}
