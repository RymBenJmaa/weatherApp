class ConsolidatedWeatherData {
  ///Internal identifier for the forecast
  final int id;

  ///Date that the forecast or observation pertains to
  final DateTime applicableDate;

  ///Text description of the weather state
  final String weatherStateName;

  ///One or two letter abbreviation of the weather state
  final String weatherStateAbbr;

  ///Current wind speed (mph)
  final double windSpeed;

  ///Current wind direction in degrees
  final double windDirection;

  ///Compass point of the wind direction
  final String windDirectionCompass;

  ///Current temperature (centigrade)
  final double temp;

  ///Minimun temperature of the day (centigrade)
  final double minTemp;

  ///Maximum temperature of the day (centigrade)
  final double maxTemp;

  ///Current air pressure (mbar)
  final double airPressure;

  ///Current humidity percentage
  final int humidity;

  ///Current visibility in miles
  final double visibility;

  ///Interpretation of the level to which the forecasters agree with each other - 100% being a complete consensus. (percentage)
  final int predictability;

  ConsolidatedWeatherData({
    required this.id,
    required this.applicableDate,
    required this.weatherStateName,
    required this.weatherStateAbbr,
    required this.windSpeed,
    required this.windDirection,
    required this.windDirectionCompass,
    required this.temp,
    required this.minTemp,
    required this.maxTemp,
    required this.airPressure,
    required this.humidity,
    required this.visibility,
    required this.predictability,
  });
  factory ConsolidatedWeatherData.fromJson(Map<String, dynamic> json) {
    return ConsolidatedWeatherData(
      id: json['id'] ?? -1,
      applicableDate: DateTime.parse(json['applicable_date'] ?? DateTime.now()),
      weatherStateName: json['weather_state_name'] ?? '',
      weatherStateAbbr: json['weather_state_abbr'] ?? '',
      windSpeed: json['wind_speed'] ?? -1,
      windDirection: json['wind_direction'] ?? -1,
      windDirectionCompass: json['wind_direction_compass'] ?? '',
      minTemp: json['min_temp'] ?? -99,
      maxTemp: json['max_temp'] ?? -99,
      temp: json['the_temp'] ?? -99,
      airPressure: json['air_pressure'] ?? -1,
      humidity: json['humidity'] ?? -1,
      visibility: json['visibility'] ?? -1,
      predictability: json['predictability'] ?? -1,
    );
  }
  static List<ConsolidatedWeatherData> listFromJson(Map<String, dynamic> json) {
    Iterable list = json['consolidated_weather'];
    List<ConsolidatedWeatherData> consolidatedWeather = list.map((i) => ConsolidatedWeatherData.fromJson(i)).toList();

    return consolidatedWeather;
  }
}
