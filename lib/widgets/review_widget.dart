import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/review.dart';
import '../utilities/themes.dart';

class ReviewWidget extends StatelessWidget {
  final List<Review> reviews;
  const ReviewWidget({Key? key, required this.reviews}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return Text(
        'No reviews till date.',
        style: GoogleFonts.raleway().copyWith(),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: reviews.map((review) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 5,
          ),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: ThemeClass.primaryColor,
                        backgroundImage: const AssetImage(
                          'images/user.png',
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        review.user.toString(),
                        style: GoogleFonts.raleway().copyWith(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  RatingBarIndicator(
                    rating: review.rating.toDouble(),
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 15.0,
                    direction: Axis.horizontal,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    review.review,
                    style: GoogleFonts.raleway().copyWith(),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
