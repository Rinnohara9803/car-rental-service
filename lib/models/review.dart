import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../services/auth_service.dart';

class Review with ChangeNotifier {
  final dynamic id;
  int rating;
  String review;
  final dynamic userId;
  final String user;

  Review({
    required this.id,
    required this.rating,
    required this.review,
    required this.userId,
    required this.user,
  });

  Future<void> updateReview(Review newReview, dynamic carId) async {
    var accessToken = await AuthService.getUserToken();
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": "Bearer $accessToken",
    };
    try {
      var responseData = await http.put(
        Uri.http(Config.authority, 'api/cars/$carId/reviews/$id'),
        headers: headers,
        body: jsonEncode(
          {
            "star": newReview.rating,
            "review": newReview.review,
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

        rating = theReview.rating;
        notifyListeners();

        review = theReview.review;
        notifyListeners();
      }
    } on SocketException {
      return Future.error('No Internet Connection.');
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
