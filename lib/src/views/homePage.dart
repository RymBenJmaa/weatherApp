import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/src/models/consolidated_weather.dart';
import 'package:weather_app/src/models/weather.dart';
import 'package:weather_app/src/services/services.dart';
import 'package:weather_app/src/views/introPage.dart';
import 'package:geocoding/geocoding.dart' as geo;

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.weather,
  }) : super(key: key);
  final WeatherData weather;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<bool> isSelected = [true, false];
  late ConsolidatedWeatherData selectedDayWeather;
  Color generalColor = Colors.grey;
  @override
  void initState() {
    selectedDayWeather = widget.weather.consolidatedWeathers.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.indigo,
      onRefresh: () async => Services.fetchWeatherData(
        await geo
            .placemarkFromCoordinates(
              double.parse(widget.weather.latLong.split(',').first),
              double.parse(widget.weather.latLong.split(',').last),
            )
            .then(
              (value) => value.first.locality!,
            ),
      ),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: backgroundColor(),
          ),
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width * .1,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              foregroundColor: generalColor,
              elevation: 0,
              centerTitle: true,
              leading: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => IntroPage(),
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios,
                ),
              ),
              title: Text(
                DateFormat.EEEE().format(
                  (selectedDayWeather.applicableDate),
                ),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: generalColor,
                ),
              ),
            ),
            body: ListView(
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedDayWeather.weatherStateName,
                      style: TextStyle(
                        fontSize: 20,
                        color: generalColor,
                      ),
                    ),
                    ToggleButtons(
                      borderColor: generalColor,
                      fillColor: generalColor,
                      borderWidth: 2,
                      selectedBorderColor: generalColor,
                      selectedColor: selectedDayWeather.weatherStateAbbr == 'lc'
                          ? Colors.white
                          : Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '°C',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '°F',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < isSelected.length; i++) {
                            isSelected[i] = i == index;
                          }
                        });
                      },
                      isSelected: isSelected,
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * .05,
                  ),
                  child: Image.network(
                    'https://www.metaweather.com/static/img/weather/png/'
                    '${selectedDayWeather.weatherStateAbbr}.png',
                    height: MediaQuery.of(context).size.height * .1,
                  ),
                ),
                Center(
                  child: Text(
                    getSelectedTypeTemp(selectedDayWeather.temp),
                    style: TextStyle(
                        fontSize: 30,
                        color: selectedDayWeather.weatherStateAbbr == 's'
                            ? Color(0xff046c7c)
                            : generalColor),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .05,
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Humidity: ',
                        style: TextStyle(
                          fontSize: 20,
                          color: selectedDayWeather.weatherStateAbbr == 'c'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '${selectedDayWeather.humidity}% ',
                        style: TextStyle(
                          fontSize: 20,
                          color: generalColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Pressure: ',
                        style: TextStyle(
                          fontSize: 20,
                          color: selectedDayWeather.weatherStateAbbr == 'c'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '${selectedDayWeather.airPressure} hpa ',
                        style: TextStyle(
                          fontSize: 20,
                          color: generalColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Wind: ',
                        style: TextStyle(
                          fontSize: 20,
                          color: selectedDayWeather.weatherStateAbbr == 'c'
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      TextSpan(
                        text:
                            '${(selectedDayWeather.windSpeed * 1.609).round()} km/h',
                        style: TextStyle(
                          fontSize: 20,
                          color: generalColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .05,
                ),
                Container(
                  height: MediaQuery.of(context).size.width * .35,
                  child: ListView.builder(
                    itemCount: widget.weather.consolidatedWeathers.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, int) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDayWeather =
                                widget.weather.consolidatedWeathers[int];
                          });
                        },
                        child: Card(
                          child: Container(
                            width: MediaQuery.of(context).size.width * .35,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat.E().format(
                                    widget.weather.consolidatedWeathers[int]
                                        .applicableDate,
                                  ),
                                ),
                                Container(
                                  child: Image.network(
                                    'https://www.metaweather.com/static/img/weather/png/'
                                    '${widget.weather.consolidatedWeathers[int].weatherStateAbbr}.png',
                                    height: MediaQuery.of(context).size.height *
                                        .06,
                                  ),
                                ),
                                Text(
                                  getSelectedTypeTemp(
                                        widget.weather.consolidatedWeathers[int]
                                            .minTemp,
                                      ) +
                                      '/' +
                                      getSelectedTypeTemp(
                                        widget.weather.consolidatedWeathers[int]
                                            .maxTemp,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient backgroundColor() {
    switch (selectedDayWeather.weatherStateAbbr) {
      case 'sn':
        generalColor = Colors.white;
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[300]!, Colors.grey],
        );
      case 'sl':
        generalColor = Colors.blue;
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[300]!, Colors.blue],
        );
      case 'h':
        generalColor = Colors.white;
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[300]!, Colors.grey[600]!],
        );
      case 't':
        generalColor = Colors.white;
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[300]!, Colors.grey[800]!],
        );
      case 'hr':
        generalColor = Colors.white;
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey, Colors.blue[800]!],
        );
      case 'lr':
        generalColor = Colors.white;
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[300]!, Colors.grey],
        );
      case 's':
        generalColor = Colors.white;

        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey, Colors.white, Colors.blue],
        );

      case 'hc':
        generalColor = Colors.white;
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[300]!, Colors.grey[800]!],
        );
      case 'lc':
        generalColor = Colors.black;
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[300]!, Colors.white, Colors.yellow],
        );
      case 'c':
        generalColor = Colors.white;
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue, Colors.indigo],
        );
      default:
        generalColor = Colors.white;
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue, Colors.indigo],
        );
    }
  }

  String getSelectedTypeTemp(double temp) {
    return isSelected[0]
        ? temp.round().toString() + '°C'
        : ((temp * 9 / 5) + 32).round().toString() + ' °F';
  }
}
