import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_exercise/model/cars_model.dart';

class LocalJson extends StatefulWidget {
  const LocalJson({super.key});

  @override
  State<LocalJson> createState() => _LocalJsonState();
}

class _LocalJsonState extends State<LocalJson> {
  int _counter = 0;
  String? _title;

  late final Future<List<CarsModel>> getCarsModel;

  @override
  void initState() {
    super.initState();
    _title = 'Local JSON Processes';
    getCarsModel = jsonReadCars(); // With this way, whenever build widget is called because of another reason (e.g. title updating), the Future op. will not be done again.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title!),
      ),
      body: FutureBuilder<List<CarsModel>>(
        future: getCarsModel,
        //initialData: [], // We can use this instead of CircularProgressIndicator to fill the screen with data until the data we pull from internet comes.
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CarsModel> carsList = snapshot.data!;
            return ListView.builder(
                itemCount: carsList.length,
                itemBuilder: ((context, index) {
                  CarsModel indexOfCar = carsList[index];
                  return ListTile(
                    title: Text(indexOfCar.carBrand),
                    subtitle: Text(indexOfCar.country),
                    leading: CircleAvatar(
                      child: Text(indexOfCar.model[0].price.toString()),
                    ),
                  );
                }));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _counter++;
            _title = 'Local JSON Processes / $_counter';
          });
        },
        child: const Icon(Icons.plus_one),
      ),
    );
  }

  Future<List<CarsModel>> jsonReadCars() async {
    debugPrint('jsonReadCars CALLED!');
    await Future.delayed(const Duration(seconds: 2)); //To see loading indicator
    try {
      String stringCarsJson = await DefaultAssetBundle.of(context)
          .loadString('assets/data/cars.json');
      var jsonArray = jsonDecode(stringCarsJson);
      List<CarsModel> allCars = (jsonArray as List)
          .map((carsMap) => CarsModel.fromMap(carsMap))
          .toList();
      debugPrint('jsonReadCars RETURNED NORMAL!');
      return allCars;
    } catch (e) {
      debugPrint('jsonReadCars RETURNED WITH ERROR!');
      return Future.error(e.toString());
    }
  }
}
