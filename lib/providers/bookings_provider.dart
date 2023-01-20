import 'dart:convert';
import 'dart:io';

import 'package:car_rental_service/models/booking.dart';
import 'package:car_rental_service/providers/booking_response.dart';
import 'package:car_rental_service/providers/car.dart';
import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

import '../config.dart';
import '../services/auth_service.dart';

class BookingsProvider with ChangeNotifier {
  List<BookingResponse> _bookings = [];

  List<BookingResponse> get bookings {
    return [..._bookings];
  }

  Future<void> createBooking(TheBooking booking, dynamic carId) async {
    var accessToken = await AuthService.getUserToken();
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken",
    };
    try {
      var responseData = await http.post(
        Uri.http(Config.authority, 'api/bookings'),
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
        BookingResponse bookingResponse = BookingResponse(
          id: jsonData['Booking']['id'],
          bookedFrom: jsonData['Booking']['booked_from'],
          bookedTo: jsonData['Booking']['booked_to'],
          status: jsonData['Booking']['status'],
          totalPrice: jsonData['Booking']['total_price'],
          bookedCar: TheCar(
            id: jsonData['Booking']['car']['id'],
            name: jsonData['Booking']['car']['name'],
            description: jsonData['Booking']['car']['description'],
            numberPlate: jsonData['Booking']['car']['number_plate'],
            horsePower: jsonData['Booking']['car']['horsepower'],
            mileage: jsonData['Booking']['car']['mileage'],
            rating: jsonData['Booking']['car']['rating'],
            price: jsonData['Booking']['car']['price'],
            image: jsonData['Booking']['car']['links']['image'],
          ),
        );
        _bookings.add(bookingResponse);
        notifyListeners();
      } else if (responseData.statusCode == 400) {
        return Future.error(jsonData['message']);
      }
    } on SocketException {
      return Future.error('No Internet Connection.');
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> fetchBookings() async {
    var accessToken = await AuthService.getUserToken();
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken",
    };
    try {
      var responseData = await http.get(
        Uri.http(Config.authority, 'api/bookings'),
        headers: headers,
      );

      var jsonData = jsonDecode(responseData.body);

      if (responseData.statusCode == 400) {
        return Future.error(jsonData['message']);
      }

      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        List<BookingResponse> loadedBookings = [];

        for (var booking in jsonData['bookings']) {
          loadedBookings.add(
            BookingResponse(
              id: booking['id'],
              bookedFrom: booking['booked_from'],
              bookedTo: booking['booked_to'],
              totalPrice: booking['total_price'],
              status: booking['status'],
              bookedCar: TheCar(
                id: booking['car']['id'],
                name: booking['car']['name'],
                description: booking['car']['description'],
                numberPlate: booking['car']['number_plate'],
                horsePower: booking['car']['horsepower'],
                mileage: booking['car']['mileage'],
                rating: booking['car']['rating'],
                price: booking['car']['price'],
                image: booking['car']['links']['image'],
              ),
            ),
          );
          _bookings = loadedBookings;
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

  Future<void> cancelBooking(dynamic bookingId) async {
    var accessToken = await AuthService.getUserToken();
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken",
    };
    try {
      var responseData = await http.post(
        Uri.http(Config.authority, 'api/bookings/$bookingId'),
        headers: headers,
      );

      if (responseData.statusCode == 204) {
        BookingResponse booking =
            _bookings.firstWhere((booking) => booking.id == bookingId);
        _bookings.remove(booking);
        notifyListeners();
      } else {
        var jsonData = jsonDecode(responseData.body);
        return Future.error(jsonData['message']);
      }
    } on SocketException {
      return Future.error('No Internet connection');
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
