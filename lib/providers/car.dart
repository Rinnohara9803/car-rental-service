import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../config.dart';
import '../services/auth_service.dart';

class TheCar with ChangeNotifier {
  final String id;
  String name;
  String description;
  String numberPlate;
  int horsePower;
  int mileage;
  int price;
  dynamic rating;
  String image;
  TheCar({
    required this.id,
    required this.name,
    required this.description,
    required this.numberPlate,
    required this.horsePower,
    required this.mileage,
    required this.rating,
    required this.price,
    required this.image,
  });

  Future<void> updateCarWithoutImage(TheCar car) async {
    var accessToken = await AuthService.getUserToken();
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken",
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

      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        var jsonData = jsonDecode(responseData.body);
        name = jsonData['car']['name'];
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

  Future<void> updateCarWithImage(TheCar car, XFile theImage) async {
    var accessToken = await AuthService.getUserToken();
    Map<String, String> headers = {
      "Authorization": "Bearer $accessToken",
    };
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://${Config.authority}/api/cars/$id?_method=PATCH'),
      )
        ..fields['name'] = car.name
        ..fields['description'] = car.description
        ..fields['number_plate'] = car.numberPlate
        ..fields['horsepower'] = car.horsePower.toString()
        ..fields['mileage'] = car.mileage.toString()
        ..fields['price'] = car.price.toString();
      Uint8List data = await theImage.readAsBytes();
      List<int> list = data.cast();
      request.headers.addAll(headers);

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          list,
          filename: theImage.name,
        ),
      );

      var response = await request.send();

      response.stream.bytesToString().asStream().listen((event) {
        var jsonData = json.decode(event);
        if (response.statusCode == 200 || response.statusCode == 201) {
          name = jsonData['car']['name'];
          notifyListeners();
          description = jsonData['car']['description'];
          notifyListeners();
          horsePower = int.parse(jsonData['car']['horsepower'].toString());
          notifyListeners();
          mileage = int.parse(jsonData['car']['mileage'].toString());
          notifyListeners();
          price = int.parse(jsonData['car']['price'].toString());
          notifyListeners();
          image = jsonData['car']['links']['image'];
          notifyListeners();
        }
      });
    } on SocketException {
      return Future.error('No Internet Connection.');
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}

// _saveForm().then((value) async {
//                             setState(() {
//                               _isLoading = true;
//                             });
//                             TheCar newCar = TheCar(
//                               id: '',
//                               name: _carNameController!.text,
//                               description: _carDescriptionController!.text,
//                               numberPlate: _carNumberController!.text,
//                               horsePower: int.parse(
//                                 _horsePowerController!.text,
//                               ),
//                               mileage: int.parse(_mileageController!.text),
//                               price: int.parse(
//                                 _priceController!.text,
//                               ),
//                               image: '',
//                             );
//                             if (image == null) {
//                               await car
//                                   .updateCarWithoutImage(
//                                 newCar,
//                               )
//                                   .then((value) {
//                                 setState(() {
//                                   _isLoading = false;
//                                 });
//                                 Navigator.of(context).pop();
//                               }).catchError((e) {
//                                 setState(() {
//                                   _isLoading = false;
//                                 });
//                                 SnackBars.showErrorSnackBar(
//                                     context, e.toString());
//                               });
//                             } else {
//                               await car
//                                   .updateCarWithImage(
//                                 newCar,
//                                 image!,
//                               )
//                                   .then((value) {
//                                 setState(() {
//                                   _isLoading = false;
//                                 });
//                                 Navigator.of(context).pop();
//                               }).catchError((e) {
//                                 setState(() {
//                                   _isLoading = false;
//                                 });
//                                 SnackBars.showErrorSnackBar(
//                                     context, e.toString());
//                               });
//                             }
//                           });
//                           setState(() {
//                             _isLoading = false;
//                           });