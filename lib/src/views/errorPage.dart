import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/src/services/services.dart';
import 'package:weather_app/src/views/homePage.dart';
import 'package:weather_app/src/views/introPage.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({
    Key? key,
    required this.selectedCity,
  }) : super(key: key);
  final String selectedCity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue,
            Colors.indigo,
          ],
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/weather_error.png',
            height: MediaQuery.of(context).size.height * .2,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .1,
          ),
          Text(
            'Can\'t find valid Data',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .1,
          ),
          TextButton(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
              ),
            ),
            onPressed: () {
              Services.fetchWeatherData(selectedCity.toString()).then(
                  (weather) => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            weather: weather,
                          ),
                        ),
                      ), onError: (error) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => IntroPage(),
                  ),
                );
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Try again',
                  style: TextStyle(
                    color: Colors.indigo,
                  ),
                ),
                Icon(
                  Icons.refresh,
                  color: Colors.indigo,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
