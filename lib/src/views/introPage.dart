import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';
import 'package:weather_app/src/services/services.dart';
import 'package:weather_app/src/views/errorPage.dart';
import 'package:weather_app/src/views/homePage.dart';

class IntroPage extends StatefulWidget {
  IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  Location location = Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  LocationData? _locationData;
  List<String> _cities = [];
  @override
  void initState() {
    super.initState();
    getLocation();
    populateCities();
  }

  Future<LocationData?> getLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {}
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {}
    }
    _locationData = await location.getLocation();
    return _locationData;
  }

  void populateCities() {
    Services.fetchCities().then(
      (value) => value.forEach((element) {
        _cities.add(element.name);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.indigo,
      onRefresh: () async {
        setState(() {
          getLocation();
          populateCities();
        });
      },
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .06,
          ),
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
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .05,
                ),
                Center(
                  child: Image.asset(
                    'assets/weather.png',
                    height: MediaQuery.of(context).size.height * .2,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .05,
                ),
                FutureBuilder<List<geo.Placemark>>(
                  future: getLocation().then((value) =>
                      geo.placemarkFromCoordinates(
                          _locationData!.latitude!, _locationData!.longitude!)),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if (snapshot.connectionState != ConnectionState.done)
                      return Text(
                        'Current city: loading...',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      );
                    else
                      return snapshot.hasData
                          ? GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                nextPage(snapshot.data!.first.locality!);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Current city: ',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data!.first.locality!,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          .02,
                                    ),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Text(
                              'Can\'t find current location',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            );
                  },
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .05,
                ),
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text == '') {
                      return const Iterable<String>.empty();
                    }
                    return _cities.where((String option) {
                      return option
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase());
                    }).toSet();
                  },
                  fieldViewBuilder: (context, textEditingController, focusNode,
                          onFieldSubmitted) =>
                      TextFormField(
                    focusNode: focusNode,
                    onFieldSubmitted: (value) => nextPage(value),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    controller: textEditingController,
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      focusColor: Colors.indigo,
                      hintText: 'Search for a different city',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      suffixIcon: Icon(
                        Icons.location_searching,
                        color: Colors.white,
                      ),
                      hoverColor: Colors.indigo,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  optionsMaxHeight: 200,
                  onSelected: (String selection) {
                    nextPage(selection);
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        child: Container(
                          width: MediaQuery.of(context).size.width * .85,
                          child: ListView.builder(
                            padding: EdgeInsets.all(10.0),
                            itemCount: options.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String option = options.elementAt(index);

                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  onSelected(option);
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              .01),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        option,
                                        style: TextStyle(),
                                      ),
                                      ShaderMask(
                                        shaderCallback: (bounds) =>
                                            RadialGradient(
                                          center: Alignment.center,
                                          radius: 0.5,
                                          colors: [Colors.blue, Colors.indigo],
                                          tileMode: TileMode.mirror,
                                        ).createShader(bounds),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void nextPage(String selectedCity) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FutureBuilder(
          future: Services.fetchWeatherData(selectedCity.toString()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) print(snapshot.error);

            if (snapshot.connectionState == ConnectionState.done) {
              return snapshot.hasData
                  ? HomePage(weather: snapshot.data)
                  : ErrorPage(
                      selectedCity: selectedCity,
                    );
            } else {
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .05,
                    ),
                    Text(
                      'Loading ...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        decoration: TextDecoration.none,
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
