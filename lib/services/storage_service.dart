import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  void addNewCity(String cityName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.remove("cities");
    String currentCities = prefs.getString("city").toString();
    await prefs.setString(
        "city",
        currentCities +
            (currentCities.length > 0 ? "," : "") +
            cityName.toLowerCase());
  }

  Future<List<String>> getAllCities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("city").toString().trim().replaceAll("null", ""));
    var cities = prefs
        .getString("city")
        .toString()
        .trim()
        .replaceAll("null", "")
        .split(',')
        .toList();
    // cities.removeAt(0);
    return cities;
  }

  Future removeCity(String city) async {
    print(city);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var cities = await getAllCities();
    cities.remove(city.toLowerCase());

    var newCities = "";
    cities.forEach((element) {
      newCities += (newCities.length > 0 ? "," : "") + element;
    });

    print(newCities);
    print(cities);

    await prefs.setString("city", newCities);
    print(prefs.getString("city"));
  }

  Future<bool> cityExist(String city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString("city").toString().toLowerCase().contains(city)) {
      return true;
    }

    return false;
  }

  void clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("city");
  }
}
