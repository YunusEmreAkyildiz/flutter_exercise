import 'dart:convert';

CarsModel carsModelFromMap(String str) => CarsModel.fromMap(json.decode(str));

String carsModelToMap(CarsModel data) => json.encode(data.toMap());

class CarsModel {
  CarsModel({
    required this.carBrand,
    required this.country,
    required this.manufactureDate,
    required this.model,
  });

  final String carBrand;
  final String country;
  final int manufactureDate;
  final List<Model> model;

  factory CarsModel.fromMap(Map<String, dynamic> json) => CarsModel(
        carBrand: json["car_brand"],
        country: json["country"],
        manufactureDate: json["manufacture_date"],
        model: List<Model>.from(json["model"].map((x) => Model.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "car_brand": carBrand,
        "country": country,
        "manufacture_date": manufactureDate,
        "model": List<dynamic>.from(model.map((x) => x.toMap())),
      };
}

class Model {
  Model({
    required this.modelName,
    required this.price,
    required this.diesel,
  });

  final String modelName;
  final int price;
  final bool diesel;

  factory Model.fromMap(Map<String, dynamic> json) => Model(
        modelName: json["model_name"],
        price: json["price"],
        diesel: json["diesel"],
      );

  Map<String, dynamic> toMap() => {
        "model_name": modelName,
        "price": price,
        "diesel": diesel,
      };
}
