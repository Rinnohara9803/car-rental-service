import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:car_rental_service/services/auth_service.dart';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:car_rental_service/providers/car.dart';
import 'package:image_picker/image_picker.dart';
import '../config.dart';

class CarsProvider with ChangeNotifier {
  List<TheCar> _cars = [];

  List<TheCar> get cars {
    return [..._cars];
  }

  List<TheCar> _searchData = [];

  List<TheCar> get searchData {
    return [..._searchData];
  }

  Future<void> addCar(TheCar car, XFile image) async {
    var accessToken = await AuthService.getUserToken();
    Map<String, String> headers = {
      "Authorization": "Bearer $accessToken",
    };
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://${Config.authority}/api/cars'),
      )
        ..fields['name'] = car.name
        ..fields['description'] = car.description
        ..fields['number_plate'] = car.numberPlate
        ..fields['horsepower'] = car.horsePower.toString()
        ..fields['mileage'] = car.mileage.toString()
        ..fields['price'] = car.price.toString();
      Uint8List data = await image.readAsBytes();
      List<int> list = data.cast();
      request.headers.addAll(headers);

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          list,
          filename: image.name,
        ),
      );

      var response = await request.send();

      response.stream.bytesToString().asStream().listen((event) {
        var jsonData = json.decode(event);
        if (response.statusCode == 200 || response.statusCode == 201) {
          _cars.add(
            TheCar(
              id: jsonData['car']['id'],
              name: jsonData['car']['name'],
              description: jsonData['car']['description'],
              numberPlate: jsonData['car']['number_plate'],
              horsePower: int.parse(jsonData['car']['horsepower'].toString()),
              mileage: int.parse(jsonData['car']['mileage'].toString()),
              rating: jsonData['car']['rating'],
              price: int.parse(jsonData['car']['price'].toString()),
              image: jsonData['car']['links']['image'],
            ),
          );
          notifyListeners();
        }
      });
    } on SocketException {
      return Future.error('No Internet Connection.');
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> getAllCars() async {
    var accessToken = await AuthService.getUserToken();
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken",
    };
    try {
      var responseData = await http.get(
        Uri.http(Config.authority, 'api/cars'),
        headers: headers,
      );

      var jsonData = jsonDecode(responseData.body);

      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        List<TheCar> loadedCars = [];
        for (var car in jsonData['cars']) {
          loadedCars.add(
            TheCar(
              id: car['id'],
              name: car['name'],
              description: car['description'],
              numberPlate: car['number_plate'],
              horsePower: car['horsepower'],
              mileage: car['mileage'],
              rating: car['rating'],
              price: car['price'],
              image: car['links']['image'],
            ),
          );
          _cars = loadedCars;
          notifyListeners();
        }
      } else {
        return Future.error(jsonData['message']);
      }

      notifyListeners();
    } on SocketException {
      return Future.error('No Internet connection');
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> getCarsBySearch(dynamic value) async {
    var accessToken = await AuthService.getUserToken();
    var queryParameters = {
      'name': value,
    };
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken",
    };
    try {
      var uri = Uri.http(Config.authority, 'api/search', queryParameters);
      var responseData = await http.get(uri, headers: headers);
      var jsonData = jsonDecode(responseData.body);
      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        List<TheCar> loadedCars = [];
        for (var car in jsonData['cars']) {
          loadedCars.add(
            TheCar(
              id: car['id'],
              name: car['name'],
              description: car['description'],
              numberPlate: car['number_plate'],
              horsePower: car['horsepower'],
              mileage: car['mileage'],
              rating: car['rating'],
              price: car['price'],
              image: car['links']['image'],
            ),
          );
          _searchData = loadedCars;
          notifyListeners();
        }
      } else {
        return Future.error(jsonData['message']);
      }
    } on SocketException {
      return Future.error('No Internet connection');
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> deleteCar(String id) async {
    var accessToken = await AuthService.getUserToken();
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken",
    };
    try {
      var responseData = await http.delete(
        Uri.http(Config.authority, 'api/cars/$id'),
        headers: headers,
      );

      if (responseData.statusCode == 204) {
        TheCar car = _cars.firstWhere((car) => car.id == id);
        _cars.remove(car);
        notifyListeners();
      } else {
        var jsonData = jsonDecode(responseData.body);
        return Future.error(jsonData['message']);
      }

      // notifyListeners();
    } on SocketException {
      return Future.error('No Internet connection');
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
