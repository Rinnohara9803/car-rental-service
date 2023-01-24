import 'dart:async';
import 'package:car_rental_service/models/booking.dart';
import 'package:car_rental_service/providers/booking_response.dart';
import 'package:car_rental_service/providers/bookings_provider.dart';
import 'package:car_rental_service/providers/car.dart';
import 'package:car_rental_service/providers/review.dart';
import 'package:car_rental_service/providers/reviews_provider.dart';
import 'package:car_rental_service/utilities/toasts.dart';
import 'package:car_rental_service/utilities/themes.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../services/shared_services.dart';
import '../widgets/review_widget.dart';

class BookingCarDetailsPage extends StatefulWidget {
  final dynamic carId;

  static String routeName = '/bookingCarDetailsPage';
  const BookingCarDetailsPage({
    super.key,
    required this.carId,
  });

  @override
  State<BookingCarDetailsPage> createState() => _BookingCarDetailsPageState();
}

class _BookingCarDetailsPageState extends State<BookingCarDetailsPage> {
  Widget detailWidget(IconData iconData, String value) {
    return DottedBorder(
      borderType: BorderType.RRect,
      radius: const Radius.circular(
        5,
      ),
      padding: const EdgeInsets.all(
        4,
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            size: 18,
          ),
          Text(
            value,
            style: GoogleFonts.raleway().copyWith(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final booking = Provider.of<BookingResponse>(context);
    final car = booking.bookedCar;

    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<ReviewsProvider>(context, listen: false)
            .fetchReviews(car.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            bool myReview = Provider.of<ReviewsProvider>(context).haveIReviewed;

            return ResponsiveBuilder(
              builder: (context, si) {
                if (si.deviceScreenType == DeviceScreenType.desktop) {
                  return ChangeNotifierProvider<BookingResponse>.value(
                    value: booking,
                    child: homeView(false, context, myReview),
                  );
                } else if (si.deviceScreenType == DeviceScreenType.tablet) {
                  return ChangeNotifierProvider<BookingResponse>.value(
                    value: booking,
                    child: homeView(false, context, myReview),
                  );
                } else {
                  return ChangeNotifierProvider<BookingResponse>.value(
                    value: booking,
                    child: homeView(true, context, myReview),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  Widget homeView(bool isMobileView, BuildContext context, bool myReview) {
    final booking = Provider.of<BookingResponse>(context);
    final car = booking.bookedCar;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: isMobileView
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ChangeNotifierProvider<BookingResponse>.value(
                          value: booking,
                          child: image(car),
                        ),
                        imageDetails(car, isMobileView, context),
                      ],
                    )
                  : Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child:
                                  ChangeNotifierProvider<BookingResponse>.value(
                                value: booking,
                                child: image(car),
                              ),
                            ),
                            imageDetailWidget(car, isMobileView, context),
                          ],
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Column reviewWidget(List<Review> reviews) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 5,
            bottom: 5,
          ),
          child: Text(
            'Reviews',
            style: GoogleFonts.raleway().copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 5,
            bottom: 5,
          ),
          child: ReviewWidget(
            reviews: reviews.take(3).toList(),
          ),
        ),
      ],
    );
  }

  Widget imageDetailWidget(
      TheCar car, bool isMobileView, BuildContext context) {
    return Flexible(
      child: imageDetails(car, isMobileView, context),
    );
  }

  Padding imageDetails(TheCar car, bool isMobileView, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  car.name,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.raleway().copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (car.rating != 'No rating yet')
                  RatingBarIndicator(
                    rating: car.rating,
                    itemBuilder: (context, index) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 15.0,
                    direction: Axis.horizontal,
                  ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              car.description,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.raleway().copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                detailWidget(
                  Icons.power_rounded,
                  '${car.horsePower} hp',
                ),
                const SizedBox(
                  width: 10,
                ),
                detailWidget(
                  Icons.power_settings_new,
                  '${car.mileage} km/l',
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Rs.${car.price}',
                  style: GoogleFonts.raleway().copyWith(
                    fontSize: 15,
                    color: ThemeClass.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' / hour',
                  style: GoogleFonts.raleway().copyWith(
                    fontSize: 15,
                    color: ThemeClass.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget image(TheCar car) {
    final booking = Provider.of<BookingResponse>(context);
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(
            5,
          ),
          child: Container(
            color: booking.status != 'active'
                ? Colors.black12
                : Colors.transparent,
            height: 300,
            width: double.infinity,
            child: FadeInImage(
              fit: BoxFit.cover,
              placeholderFit: BoxFit.cover,
              placeholder: const AssetImage(
                'images/loading.gif',
              ),
              image: NetworkImage(
                car.image,
              ),
            ),
          ),
        ),
        if (SharedService.role == 'User' && booking.status == 'active')
          Positioned(
            right: 5,
            top: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                5,
              ),
              child: Material(
                color: Colors.black26, // button color
                child: TextButton(
                  onPressed: () async {
                    await booking.updateBookingStatus().then((value) {
                      FlutterToasts.showNormalToast(
                          context, 'Booking Status updated successfully.');
                    }).catchError((e) {
                      FlutterToasts.showErrorToast(context, e.toString());
                    });
                  },
                  child: Text(
                    'Return Car',
                    style: GoogleFonts.raleway().copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        Positioned(
          left: 5,
          top: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              5,
            ),
            child: Material(
              color: booking.status == 'active' ? Colors.green : Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  booking.status,
                  style: GoogleFonts.raleway().copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
