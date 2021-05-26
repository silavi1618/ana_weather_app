import 'package:ana_weather_app/components/weather_card_component.dart';
import 'package:ana_weather_app/models/weather_info_model.dart';
import 'package:ana_weather_app/services/helper_service.dart';
import 'package:ana_weather_app/services/location_service.dart';
import 'package:ana_weather_app/services/storage_service.dart';
import 'package:ana_weather_app/services/weather_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'ANA Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final maxCityCount = 3;
  bool showAddButton = false;
  WeatherService weatherService = new WeatherService();
  StorageService storageService = new StorageService();
  WeatherInfo currentWeatherInfo = WeatherInfo.empty();
  WeatherInfo cityLookupWeatherInfo = WeatherInfo.empty();
  List<WeatherInfo> savedCitiesWeatherInfo = [];
  final newCityTextController = TextEditingController();

  void updateCurrentLocation() async {
    // await Geolocator.openAppSettings();
    // await Geolocator.openLocationSettings();

    LocationService.getUserLocation().then((Position value) {
      weatherService
          .getWeatherInfoByCordinations(value.latitude, value.longitude)
          .then((weatherInfo) {
        setState(() {
          currentWeatherInfo = weatherInfo;
        });
      }).catchError((onError) {
        showToast(context, onError);
      });
    }).catchError((onError) {
      showToast(context, onError);
    });
  }

  void addNewCity() {
    String cityName = newCityTextController.text;
    if (cityName.trim().length > 0) {
      if (savedCitiesWeatherInfo.length >= maxCityCount) {
        showToast(context, "You have reached the maximum number of cities!");
        return;
      }

      storageService
          .cityExist(cityName)
          .then((bool exist) => {
                if (!exist)
                  {
                    weatherService
                        .getWeatherInfoByCityName(cityName)
                        .then((value) {
                      storageService.addNewCity(value.cityName);

                      setState(() {
                        savedCitiesWeatherInfo.add(value);
                      });

                      showToast(context, "City added successfully");
                    }).catchError((onError) {
                      print(onError);
                      showToast(context, onError);
                    })
                  }
                else
                  {showToast(context, "City already exist!")}
              })
          .catchError((onError) {
        showToast(context, onError);
      });
    }

    // storageService.clear();
  }

  void lookupCity() {
    String cityName = newCityTextController.text;
    if (cityName.trim().length > 0) {
      weatherService.getWeatherInfoByCityName(cityName).then((value) {
        setState(() {
          cityLookupWeatherInfo = value;
        });

        showToast(context, value.cityName + " weather loaded successfully");
      }).catchError((onError) {
        print(onError);
        showToast(context, onError);
      });
    }
  }

  void getSavedCitiesWeatherInfo() {
    List<WeatherInfo> tempSavedCitiesWeatherInfo = [];

    storageService.getAllCities().then((savedCities) {
      // print(savedCities.length);
      // print(savedCities);
      setState(() {
        savedCitiesWeatherInfo = [];
        // print(savedCitiesWeatherInfo);
      });

      savedCities.forEach((cityName) {
        if (cityName != null || cityName != "null" || cityName != "") {
          weatherService.getWeatherInfoByCityName(cityName).then((weatherInfo) {
            setState(() {
              savedCitiesWeatherInfo.add(weatherInfo);
              // print(savedCitiesWeatherInfo);
            });

            tempSavedCitiesWeatherInfo.add(weatherInfo);
          }).catchError((onError) {
            showToast(context, "Error on getting weather info for " + cityName);
          });
        }
      });

      setState(() {
        showAddButton = true;
      });
      // setState(() {
      //   savedCitiesWeatherInfo = tempSavedCitiesWeatherInfo;
      //   print(savedCitiesWeatherInfo);
      // });
    });

    // tempSavedCitiesWeatherInfo = [];
  }

  void removeCity(String cityName) {
    storageService.removeCity(cityName).then((value) {
      getSavedCitiesWeatherInfo();
      showToast(context, "City removed successfully!");
    });
  }

  void refreshWeatherInfo() {
    getSavedCitiesWeatherInfo();
    updateCurrentLocation();
    lookupCity();
    showToast(context, "Updating weather info...");
  }

  List<Widget> getCityWidgets() {
    List<Widget> widgets = [];
    savedCitiesWeatherInfo.forEach((element) {
      widgets.add(new WeatherCard(
        cityName: element.cityName,
        main: element.main,
        isRemovable: true,
        onRemove: () => removeCity(element.cityName),
      ));
    });
    return widgets;
  }

  void initState() {
    super.initState();
    updateCurrentLocation();
    getSavedCitiesWeatherInfo();
  }

  @override
  void dispose() {
    newCityTextController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: ListView(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        children: [
          Container(
            padding: EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
            child: Column(
              // Column is also a layout widget. It takes a list of children and
              // arranges them vertically. By default, it sizes itself to fit its
              // children horizontally, and tries to be as tall as its parent.
              //
              // Invoke "debug painting" (press "p" in the console, choose the
              // "Toggle Debug Paint" action from the Flutter Inspector in Android
              // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
              // to see the wireframe for each widget.
              //
              // Column has various properties to control how it sizes itself and
              // how it positions its children. Here we use mainAxisAlignment to
              // center the children vertically; the main axis here is the vertical
              // axis because Columns are vertical (the cross axis would be
              // horizontal).
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                WeatherCard(
                    cityName: currentWeatherInfo.cityName,
                    main: currentWeatherInfo.main,
                    onRemove: () => {},
                    isCurrentLocation: true),
                Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Column(
                      children: [
                        TextField(
                          controller: newCityTextController,
                          decoration:
                              InputDecoration(hintText: 'name of the city'),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    onSurface: Colors.white,
                                    backgroundColor: btnColor,
                                  ),
                                  onPressed: addNewCity,
                                  child: Text('Add'),
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    onSurface: Colors.white,
                                    backgroundColor: btnColor2,
                                  ),
                                  onPressed: lookupCity,
                                  child: Text('Lookup'),
                                ),
                              ],
                            )),
                      ],
                    )),
                Visibility(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: WeatherCard(
                      cityName: cityLookupWeatherInfo.cityName,
                      main: cityLookupWeatherInfo.main,
                      isRemovable: false,
                      onRemove: () => {},
                    ),
                  ),
                  visible: cityLookupWeatherInfo.cityName.length > 0,
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Column(
                    children: getCityWidgets(),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: refreshWeatherInfo,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
