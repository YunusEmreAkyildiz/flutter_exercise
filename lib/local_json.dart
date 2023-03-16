import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_exercise/model/cars_model.dart';

class LocalJson extends StatefulWidget {
  const LocalJson({super.key});

  @override
  State<LocalJson> createState() => _LocalJsonState();
}

class _LocalJsonState extends State<LocalJson> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local JSON Processes'),
      ),
      body: FutureBuilder<List<CarsModel>>(
        future: jsonReadCars(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CarsModel> carsList = snapshot.data!;
            return ListView.builder(
                itemCount: carsList.length,
                itemBuilder: ((context, index) {
                  return ListTile(
                    title: Text(carsList[index].carBrand),
                    subtitle: Text(carsList[index].country),
                    leading: CircleAvatar(
                      child: Text(carsList[index].model[0].price.toString()),
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
    );
  }

  Future<List<CarsModel>> jsonReadCars() async {
    await Future.delayed(const Duration(seconds: 2)); //To see loading indicator
    try {
      String stringCarsJson = await DefaultAssetBundle.of(context)
          .loadString('assets/data/cars.json');
      var jsonArray = jsonDecode(stringCarsJson);
      List<CarsModel> allCars = (jsonArray as List)
          .map((carsMap) => CarsModel.fromMap(carsMap))
          .toList();
      return allCars;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
