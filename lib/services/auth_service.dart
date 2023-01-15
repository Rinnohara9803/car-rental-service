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
        await prefs.setString(
          'user_name',
          jsonData['user']['name'],
        );
        await prefs.setString(
          'user_id',
          jsonData['user']['id'].toString(),
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

  static Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userName = prefs.getString('user_name');

    return userName;
  }

  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('user_id');

    return userId;
  }

  static Future<void> logOut(BuildContext context) async {
    var accessToken = await AuthService.getUserToken();
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken",
    };
    try {
      var responseData = await http.post(
        Uri.http(Config.authority, 'api/auth/logout'),
        headers: headers,
      );
      var jsonData = jsonDecode(responseData.body);

      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear().then((value) {
          Navigator.pushNamedAndRemoveUntil(
              context, SignInPage.routeName, (route) => false);
        });
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
}
