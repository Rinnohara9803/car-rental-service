import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../config.dart';
import '../services/shared_services.dart';

class TheCar with ChangeNotifier {
  final String id;
  String name;
  String description;
  String numberPlate;
  int horsePower;
  int mileage;
  int price;
  String image;
  TheCar({
    required this.id,
    required this.name,
    required this.description,
    required this.numberPlate,
    required this.horsePower,
    required this.mileage,
    required this.price,
    required this.image,
  });

  Future<void> updateCarWithoutImage(TheCar car) async {
    print('here');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer ${SharedService.token}",
    };
    try {
      var responseData = await http.patch(
        Uri.http(Config.authority, 'api/cars/$id'),
        headers: headers,
        body: jsonEncode(
          {
            "name": car.name,
            "description": car.description,
            "number_plate": car.numberPlate,
            "horsepower": car.horsePower,
            "mileage": car.mileage,
            "price": car.price,
          },
        ),
      );
      print(responseData.statusCode);

      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        var jsonData = jsonDecode(responseData.body);
        name = jsonData['car']['name'];
        print(name);
        notifyListeners();
        description = jsonData['car']['description'];
        notifyListeners();
        horsePower = jsonData['car']['horsepower'];
        notifyListeners();
        mileage = jsonData['car']['mileage'];
        notifyListeners();
        price = jsonData['car']['price'];
        notifyListeners();
      }
    } on SocketException {
      return Future.error('No Internet Connection.');
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
