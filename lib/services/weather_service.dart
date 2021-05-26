import 'package:ana_weather_app/models/error_model.dart';
import 'package:ana_weather_app/models/weather_info_model.dart';
import 'package:dio/dio.dart';

class WeatherService {
  final _apiKey = "cf162eec8731b79fa6d17d85bea87246";
  final String baseURL = "https://api.openweathermap.org/data/2.5/";
  final String weatherSection = "weather";

  Future<WeatherInfo> getWeatherInfoByCordinations(
      double lat, double long) async {
    Response response;
    var dio = Dio();

    response = await dio.get(baseURL + weatherSection, queryParameters: {
      "lat": lat.toString(),
      "lon": long.toString(),
      "appid": _apiKey
    });

    if (response.statusCode == 200) {
      return WeatherInfo.fromJson(response.data);
    }

    throw ("Couldn't retrieve weather info!");
  }

  Future<WeatherInfo> getWeatherInfoByCityName(String city) async {
    Response response;
    try {
      var dio = Dio();

      response = await dio.get(baseURL + weatherSection,
          queryParameters: {"q": city, "appid": _apiKey});

      if (response.statusCode == 200) {
        return WeatherInfo.fromJson(response.data);
      }
      throw ("Couldn't retrieve weather info!");
    } catch (e) {
      if (e is DioError) {
        ErrorModel error = ErrorModel.fromJson(e.response?.data);
        return Future.error(error.message);
      }
    }
    return Future.error("Couldn't retrieve weather info!");
  }
}
