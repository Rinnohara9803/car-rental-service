import 'package:car_rental_service/providers/car.dart';
import 'package:car_rental_service/models/review.dart';
import 'package:car_rental_service/utilities/show_dialogs.dart';
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

class CarDetailsPage extends StatefulWidget {
  static String routeName = '/carDetailsPage';
  const CarDetailsPage({super.key});

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  void showBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        DateTime? bookFromDate;
        String _bookFromDate = '';
        DateTime? bookToDate;
        String _bookToDate = '';
        void presentDatePicker(DateTime? dateTime, String dateTimeString) {
          showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2050),
          ).then((pickedDate) {
            if (pickedDate == null) {
              return;
            }
            setState(() {
              dateTime = pickedDate;
              dateTimeString = dateTime!.toIso8601String();
            });
          });
        }

        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                  ),
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          bookFromDate == null
                              ? 'No Date Chosen!!!'
                              : DateFormat.yMd().format(
                                  DateTime.parse(_bookFromDate),
                                ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        TextButton(
                          onPressed: () {
                            presentDatePicker(bookFromDate, _bookFromDate);
                          },
                          child: const Text(
                            'Choose DOB',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  List<Review> reviews = [
    Review(
      id: '0',
      rating: 4,
      review: 'This is good review.',
      reviewer: 'User 1',
    ),
    Review(
      id: '1',
      rating: 4.5,
      review: 'This is bad review.',
      reviewer: 'User 2',
    ),
    Review(
      id: '2',
      rating: 2.5,
      review: 'This is mixed review.',
      reviewer: 'User 3',
    ),
  ];

  final _formKey = GlobalKey<FormState>();
  String _review = '';
  double _rating = 1.0;
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
    final car = Provider.of<TheCar>(context);
    return Scaffold(
      body: ResponsiveBuilder(
        builder: (context, si) {
          if (si.deviceScreenType == DeviceScreenType.desktop) {
            return ChangeNotifierProvider<TheCar>.value(
              value: car,
              child: homeView(false),
            );
          } else if (si.deviceScreenType == DeviceScreenType.tablet) {
            return ChangeNotifierProvider<TheCar>.value(
              value: car,
              child: homeView(false),
            );
          } else {
            return ChangeNotifierProvider<TheCar>.value(
              value: car,
              child: homeView(true),
            );
          }
        },
      ),
    );
  }

  Widget homeView(bool isMobileView) {
    final car = Provider.of<TheCar>(context);
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
                      children: [
                        image(car),
                        imageDetails(car, isMobileView),
                        const SizedBox(
                          height: 30,
                        ),
                        reviewWidget(),
                        const SizedBox(
                          height: 60,
                        ),
                        reviewAndRatingWidget(),
                      ],
                    )
                  : Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            imageWidget(car),
                            imageDetailWidget(car, isMobileView),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: reviewAndRatingWidget(),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 3,
                              child: reviewWidget(),
                            ),
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

  Column reviewWidget() {
    return Column(
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
        ReviewWidget(
          reviews: reviews.take(3).toList(),
        ),
      ],
    );
  }

  Widget imageDetailWidget(TheCar car, bool isMobileView) {
    return Flexible(
      child: imageDetails(car, isMobileView),
    );
  }

  Widget reviewAndRatingWidget() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            DottedBorder(
              child: Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.lightBlueAccent,
                      ThemeClass.primaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(
                    2,
                  ),
                ),
              ),
            ),
            const Positioned(
              right: 0,
              left: 0,
              top: -42,
              child: CircleAvatar(
                radius: 42,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.black12,
                  backgroundImage: AssetImage(
                    'images/user.png',
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 6,
              right: 0,
              left: 0,
              child: Text(
                'Review By ${SharedService.userName}',
                style: GoogleFonts.raleway().copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              RatingBar.builder(
                initialRating: 2,
                minRating: 1,
                glow: true,
                glowRadius: 0.5,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                ),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: ThemeClass.primaryColor,
                ),
                onRatingUpdate: (rating) {
                  _rating = rating;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: TextFormField(
                  maxLines: 3,
                  key: const ValueKey(
                    'Write your review',
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Your review',
                  ),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please provide your review.';
                    } else if (value.trim().length < 5) {
                      return 'Review is too short.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _review = value!;
                  },
                  onChanged: (value) {
                    _review = value;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      _formKey.currentState!.save();
                    },
                    child: Text(
                      'Post your review',
                      style: GoogleFonts.raleway().copyWith(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding imageDetails(TheCar car, bool isMobileView) {
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
            Text(
              car.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.raleway().copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
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
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 35,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.purple,
                  ),
                ),
                onPressed: () {
                  showBookingDialog(context);
                },
                icon: const Icon(
                  Icons.book_online,
                ),
                label: Text(
                  'Book Now',
                  style: GoogleFonts.raleway().copyWith(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageWidget(TheCar car) {
    return Flexible(
      child: image(car),
    );
  }

  Widget image(TheCar car) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        5,
      ),
      child: SizedBox(
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
    );
  }
}
