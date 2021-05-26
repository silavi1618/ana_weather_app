class ErrorModel {
  String cod = "";
  String message = "";

  ErrorModel(this.cod, this.message);

  ErrorModel.fromJson(Map<String, dynamic> json) {
    cod = json['cod'];
    message = json['message'];
  }
  
}
