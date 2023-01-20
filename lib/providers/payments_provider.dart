import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/payment.dart';
import '../services/auth_service.dart';

class PaymentProvider with ChangeNotifier {
  List<Payment> _payments = [];

  List<Payment> get payments {
    return [..._payments];
  }

  Future<void> createPayment(Payment payment) async {
    var accessToken = await AuthService.getUserToken();
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken",
    };
    try {
      var responseData = await http.post(
        Uri.http(Config.authority, 'api/payments'),
        headers: headers,
        body: jsonEncode(
          {
            // "payment_number": booking.bookFrom,
            // "payment_token": booking.bookTo,
          },
        ),
      );
      var jsonData = jsonDecode(responseData.body);

      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
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
      print(responseData.statusCode);
      print(jsonData);
      if (responseData.statusCode == 400) {
        return Future.error(jsonData['message']);
      }

      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        List<Payment> loadedPayments = [];

        for (var booking in jsonData['bookings']) {}
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
}
