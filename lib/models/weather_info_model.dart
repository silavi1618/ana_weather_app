class WeatherInfo {
  String main = "";
  String description = "";
  String icon = "";
  String cityName = "";

  WeatherInfo(this.main, this.description, this.icon, this.cityName);

  WeatherInfo.fromJson(Map<String, dynamic> json) {
    main = json['weather'][0]['main'];
    description = json['weather'][0]['description'];
    icon = json['weather'][0]['icon'];
    cityName = json['name'];
  }

  WeatherInfo.empty() {
    main = "";
    description = "";
    icon = "";
    cityName = "";
  }
}
