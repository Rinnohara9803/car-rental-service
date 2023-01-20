import 'dart:convert';
import 'dart:io';

import 'package:car_rental_service/models/booking.dart';
import 'package:car_rental_service/providers/car.dart';
import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../config.dart';
import '../services/auth_service.dart';

class BookingResponse with ChangeNotifier {
  final int id;
  String bookedFrom;
  String bookedTo;
  double totalPrice;
  String status;
  final TheCar bookedCar;

  BookingResponse({
    required this.id,
    required this.bookedFrom,
    required this.bookedTo,
    required this.totalPrice,
    required this.status,
    required this.bookedCar,
  });

  Future<void> updateBooking(TheBooking booking, dynamic carId) async {
    var accessToken = await AuthService.getUserToken();
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken",
    };
    try {
      var responseData = await http.put(
        Uri.http(Config.authority, 'api/bookings/$id'),
        headers: headers,
        body: jsonEncode(
          {
            "booked_from": booking.bookFrom,
            "booked_to": booking.bookTo,
            "car_id": carId,
          },
        ),
      );
      var jsonData = jsonDecode(responseData.body);
      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        bookedFrom = jsonData['booking']['booked_from'];
        notifyListeners();
        bookedTo = jsonData['booking']['booked_to'];
        notifyListeners();
        totalPrice = jsonData['booking']['total_price'];
        notifyListeners();
      } else {
        return Future.error(jsonData['message']);
      }
    } on SocketException {
      return Future.error('No Internet Connection.');
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> updateBookingStatus() async {
    var accessToken = await AuthService.getUserToken();
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken",
    };
    try {
      var responseData = await http.put(
        Uri.http(Config.authority, 'api/bookings/$id/update-status'),
        headers: headers,
      );
      var jsonData = jsonDecode(responseData.body);
      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        status = jsonData['booking']['status'];
        notifyListeners();
      } else {
        return Future.error(jsonData['message']);
      }
    } on SocketException {
      return Future.error('No Internet Connection.');
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
