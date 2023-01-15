import 'dart:convert';
import 'dart:io';

import 'package:car_rental_service/models/review.dart';
import 'package:car_rental_service/services/shared_services.dart';
import 'package:flutter/cupertino.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import '../config.dart';
import '../services/auth_service.dart';

class ReviewsProvider with ChangeNotifier {
  List<Review> _reviews = [];

  List<Review> get reviews {
    return [..._reviews];
  }

  Review _myReview =
      Review(id: '', rating: 2, review: '', userId: '', user: '');

  Review get myReview {
    return _myReview;
  }

  bool _haveIReviewed = false;

  bool get haveIReviewed {
    return _haveIReviewed;
  }

  Future<void> createReview(Review review, dynamic carId) async {
    var accessToken = await AuthService.getUserToken();
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken",
    };
    try {
      var responseData = await http.post(
        Uri.http(Config.authority, 'api/cars/$carId/reviews'),
        headers: headers,
        body: jsonEncode(
          {
            "star": review.rating,
            "review": review.review,
          },
        ),
      );
      var jsonData = jsonDecode(responseData.body);
      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        Review theReview = Review(
          id: jsonData['review']['id'],
          rating: jsonData['review']['star'],
          review: jsonData['review']['body'],
          userId: jsonData['review']['customer_id'],
          user: jsonData['review']['customer'],
        );
        _myReview = theReview;
        notifyListeners();

        _haveIReviewed = true;
        notifyListeners();
      }
    } on SocketException {
      return Future.error('No Internet Connection.');
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  Future<void> fetchReviews(dynamic carId) async {
    var userId = await AuthService.getUserId();
    var accessToken = await AuthService.getUserToken();
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken",
    };
    try {
      var responseData = await http.get(
        Uri.http(Config.authority, 'api/cars/$carId/reviews'),
        headers: headers,
      );

      var jsonData = jsonDecode(responseData.body);

      if (responseData.statusCode == 200 || responseData.statusCode == 201) {
        List<Review> loadedReviews = [];
        _myReview = Review(id: '', rating: 2, review: '', userId: '', user: '');
        notifyListeners();

        _haveIReviewed = false;
        notifyListeners();
        for (var review in jsonData['reviews']) {
          Review theReview = Review(
            id: review['id'],
            rating: review['star'],
            review: review['body'],
            userId: review['customer_id'],
            user: review['customer'],
          );
          loadedReviews.add(theReview);

          if (theReview.userId.toString() == userId) {
            _myReview = theReview;
            notifyListeners();
            _haveIReviewed = true;
            notifyListeners();
          }
        }
        _reviews = loadedReviews;
        notifyListeners();
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

  Future<void> deleteReview(dynamic carId) async {
    var accessToken = await AuthService.getUserToken();
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken",
    };
    try {
      var responseData = await http.delete(
        Uri.http(Config.authority, 'api/cars/$carId/reviews/${_myReview.id}'),
        headers: headers,
      );

      if (responseData.statusCode == 204) {
        print('good deletion');
        _myReview = Review(id: '', rating: 2, review: '', userId: '', user: '');
        notifyListeners();
        _haveIReviewed = false;
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
