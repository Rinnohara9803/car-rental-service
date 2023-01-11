import 'dart:convert';
import 'dart:io';
import 'package:car_rental_service/services/shared_services.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';
import '../models/user.dart';
import '../pages/sign_in_page.dart';

class AuthService {
  static Future<void> signUpUser(User user) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    try {
      var responseData = await http.post(
        Uri.http(Config.authority, 'api/auth/signup'),
        headers: headers,
        body: jsonEncode(
          {
            "name": user.userName,
            "email": user.email,
            "password": user.password,
            "password_confirmation": user.password,
          },
        ),
      );

      var jsonData = json.decode(responseData.body);

      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        return;
      } else {
        return Future.error(jsonData['message']);
      }
    } on SocketException {
      return Future.error('No Internet Connection');
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<void> signInuser(String email, String password) async {
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json"
    };
    try {
      var responseData = await http.post(
        Uri.http(Config.authority, 'api/auth/login'),
        headers: headers,
        body: jsonEncode(
          {
            "email": email,
            "password": password,
          },
        ),
      );
      var jsonData = jsonDecode(responseData.body);

      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString(
          'access_token',
          jsonData['access_token'],
        );
        SharedService.userName = jsonData['user']['name'];
        SharedService.email = jsonData['user']['email'];
        SharedService.userID = jsonData['user']['id'].toString();
        SharedService.token = jsonData['access_token'];
      } else {
        return Future.error(
          jsonData['message'],
        );
      }
    } on SocketException {
      return Future.error('No Internet Connection');
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  static Future<String?> getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('access_token');

    return accessToken;
  }

  // static Future<void> verifyUser(String otp) async {
  //   Map<String, String> headers = {
  //     "Content-type": "application/json",
  //     "Authorization": "Bearer ${SharedService.token}",
  //   };
  //   try {
  //     var responseData = await http.post(
  //       Uri.http(Config.authority, 'api/users/verify'),
  //       headers: headers,
  //       body: jsonEncode(
  //         {
  //           "otp": otp,
  //         },
  //       ),
  //     );

  //     if (responseData.statusCode == 200 || responseData.statusCode == 201) {
  //     } else if (responseData.statusCode == 400) {
  //       return Future.error('Invalid or expired OTP');
  //     }
  //   } on SocketException {
  //     return Future.error('No Internet Connection');
  //   } catch (e) {
  //     return Future.error(e.toString());
  //   }
  // }

  // static Future<void> resendOtp() async {
  //   Map<String, String> headers = {
  //     "Content-type": "application/json",
  //     "Authorization": "Bearer ${SharedService.token}",
  //   };
  //   try {
  //     var responseData = await http.post(
  //       Uri.http(Config.authority, 'api/users/resend-otp'),
  //       headers: headers,
  //     );

  //     if (responseData.statusCode == 200 || responseData.statusCode == 201) {
  //     } else if (responseData.statusCode == 400) {
  //       return Future.error('Something went wrong.');
  //     }
  //   } on SocketException {
  //     return Future.error('No Internet Connection');
  //   } catch (e) {
  //     return Future.error(e.toString());
  //   }
  // }

  // static Future<void> fetchMyProfile(String userId) async {
  //   Map<String, String> headers = {
  //     "Content-type": "application/json",
  //     "Authorization": "Bearer ${SharedService.token}",
  //   };
  //   try {
  //     var responseData = await http.get(
  //       Uri.http(Config.authority, 'api/users/$userId'),
  //       headers: headers,
  //     );
  //     if (responseData.statusCode == 200 || responseData.statusCode == 201) {
  //       var jsonData = jsonDecode(responseData.body);
  //       SharedService.userID = jsonData['_id'];
  //       SharedService.userName = jsonData['name'];
  //       SharedService.email = jsonData['email'];
  //     } else {
  //       return Future.error('No user found.');
  //     }
  //   } on SocketException {
  //     return Future.error('No Internet Connection');
  //   } catch (e) {
  //     return Future.error(e.toString());
  //   }
  // }

  static Future<void> logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear().then((value) {
      Navigator.pushReplacementNamed(
        context,
        SignInPage.routeName,
      );
    });
  }
}
