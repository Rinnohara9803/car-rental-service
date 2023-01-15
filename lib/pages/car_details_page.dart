import 'package:car_rental_service/models/booking.dart';
import 'package:car_rental_service/providers/bookings_provider.dart';
import 'package:car_rental_service/providers/car.dart';
import 'package:car_rental_service/models/review.dart';
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

class CarDetailsPage extends StatefulWidget {
  static String routeName = '/carDetailsPage';
  const CarDetailsPage({
    super.key,
  });

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  TimeOfDay timeOfDay = TimeOfDay.now();
  DateTime? bookFromDate;
  String? _bookFromTime;
  String _bookToTime = '00:00:00';
  DateTime? bookToDate;
  TimeOfDay? bookFromTime;
  TimeOfDay? bookTime;

  void showBookingDialog(BuildContext context, bool isMobileView, TheCar car) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (ctx, StateSetter setState) {
          Future<void> bookCar() async {
            if (bookFromDate == null || bookToDate == null) {
              FlutterToasts.showNormalToast(
                  context, 'Provide necessary details to continue booking.');
              return;
            } else {
              TheBooking booking = TheBooking(
                bookFrom: DateFormat('yyyy-MM-dd $_bookFromTime')
                    .format(bookFromDate!),
                bookTo:
                    DateFormat('yyyy-MM-dd $_bookToTime').format(bookToDate!),
                totalCost: 0,
              );

              Provider.of<BookingsProvider>(context, listen: false)
                  .createBooking(booking, car.id)
                  .then((value) {
                FlutterToasts.showNormalToast(context, 'Booking successful.');
                Navigator.of(context).pop();
              }).catchError((e) {
                FlutterToasts.showErrorToast(context, e.toString());
              });
            }
          }

          void presentDateRangePicker() {
            var initialDateRange = DateTimeRange(
              start: DateTime.now(),
              end: DateTime.now().add(
                const Duration(hours: 24 * 3),
              ),
            );
            showDateRangePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime(
                2050,
              ),
              initialDateRange: initialDateRange,
            ).then((dateRange) {
              if (dateRange == null) {
                return;
              } else {
                setState(() {
                  initialDateRange = dateRange;
                  bookFromDate = initialDateRange.start;
                  bookToDate = initialDateRange.end;
                });
              }
            });
          }

          void presentFromTimePicker() {
            showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            ).then((time) {
              if (time == null) {
                return;
              } else {
                setState(() {
                  bookFromTime = time;
                  String bookFromTimeString = '';

                  if (bookFromTime!.hour.toString().length == 1 &&
                      bookFromTime!.minute.toString().length == 1) {
                    bookFromTimeString =
                        '0${bookFromTime!.hour}:0${bookFromTime!.minute}:00';
                  } else if (bookFromTime!.hour.toString().length == 1 &&
                      bookFromTime!.minute.toString().length != 1) {
                    bookFromTimeString =
                        '0${bookFromTime!.hour}:${bookFromTime!.minute}:00';
                  } else if (bookFromTime!.hour.toString().length != 1 &&
                      bookFromTime!.minute.toString().length == 1) {
                    bookFromTimeString =
                        '${bookFromTime!.hour}:0${bookFromTime!.minute}:00';
                  } else {
                    bookFromTimeString =
                        '${bookFromTime!.hour}:${bookFromTime!.minute}:00';
                  }
                  _bookFromTime =
                      '${bookFromTime!.hour}:${bookFromTime!.minute}:00';
                  _bookFromTime = bookFromTimeString;
                });
              }
            });
          }

          void presentToTimePicker() {
            showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            ).then((time) {
              if (time == null) {
                return;
              } else {
                setState(() {
                  bookTime = time;
                  String bookToTimeString = '';

                  if (bookTime!.hour.toString().length == 1 &&
                      bookTime!.minute.toString().length == 1) {
                    bookToTimeString =
                        '0${bookTime!.hour}:0${bookTime!.minute}:00';
                  } else if (bookTime!.hour.toString().length == 1 &&
                      bookTime!.minute.toString().length != 1) {
                    bookToTimeString =
                        '0${bookTime!.hour}:${bookTime!.minute}:00';
                  } else if (bookTime!.hour.toString().length != 1 &&
                      bookTime!.minute.toString().length == 1) {
                    bookToTimeString =
                        '${bookTime!.hour}:0${bookTime!.minute}:00';
                  } else {
                    bookToTimeString =
                        '${bookTime!.hour}:${bookTime!.minute}:00';
                  }
                  _bookToTime = bookToTimeString;
                });
              }
            });
          }

          return Dialog(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 15,
              ),
              child: SizedBox(
                height: 210,
                width: 210,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue Booking . . .',
                      style: GoogleFonts.raleway().copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    IconButton(
                      onPressed: () {
                        presentDateRangePicker();
                      },
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                      ),
                      color: Colors.purple,
                    ),
                    bookFromWidget(presentFromTimePicker),
                    const SizedBox(
                      height: 5,
                    ),
                    bookToWidget(presentToTimePicker),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 30,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.purple,
                          ),
                        ),
                        onPressed: () {
                          bookCar();
                        },
                        child: Text(
                          'Book Now',
                          style: GoogleFonts.raleway().copyWith(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Row bookToWidget(void Function() presentToTimePicker) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'To        ',
          style: GoogleFonts.raleway().copyWith(
            color: Colors.purple,
          ),
        ),
        Container(
          height: 30,
          padding: const EdgeInsets.all(
            5,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.purple,
            ),
            borderRadius: BorderRadius.circular(
              5,
            ),
          ),
          child: Center(
            child: Text(
              bookToDate == null
                  ? 'No Date Chosen!!!'
                  : DateFormat('yyyy-MM-dd $_bookToTime').format(bookToDate!),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        if (bookFromDate != null || bookToDate != null)
          IconButton(
            icon: const Icon(
              Icons.watch_later_outlined,
            ),
            color: Colors.purple,
            onPressed: () {
              presentToTimePicker();
            },
          ),
      ],
    );
  }

  Row bookFromWidget(void Function() presentFromTimePicker) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'From',
          style: GoogleFonts.raleway().copyWith(
            color: Colors.purple,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Container(
          height: 30,
          padding: const EdgeInsets.all(
            5,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.purple,
            ),
            borderRadius: BorderRadius.circular(
              5,
            ),
          ),
          child: Center(
            child: Text(
              bookFromDate == null
                  ? 'No Date Chosen!!!'
                  : DateFormat('yyyy-MM-dd $_bookFromTime')
                      .format(bookFromDate!),
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        if (bookFromDate != null || bookToDate != null)
          IconButton(
            icon: const Icon(
              Icons.watch_later_outlined,
            ),
            color: Colors.purple,
            onPressed: () {
              presentFromTimePicker();
            },
          ),
      ],
    );
  }

  final _formKey = GlobalKey<FormState>();
  String _review = '';
  int _rating = 0;
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
  void initState() {
    _bookFromTime = '';

    bookTime = TimeOfDay.now();
    String bookFromTimeString = '';

    if (bookTime!.hour.toString().length == 1 &&
        bookTime!.minute.toString().length == 1) {
      bookFromTimeString = '0${bookTime!.hour}:0${bookTime!.minute}:00';
    } else if (bookTime!.hour.toString().length == 1 &&
        bookTime!.minute.toString().length != 1) {
      bookFromTimeString = '0${bookTime!.hour}:${bookTime!.minute}:00';
    } else if (bookTime!.hour.toString().length != 1 &&
        bookTime!.minute.toString().length == 1) {
      bookFromTimeString = '${bookTime!.hour}:0${bookTime!.minute}:00';
    } else {
      bookFromTimeString = '${bookTime!.hour}:${bookTime!.minute}:00';
    }
    _bookFromTime = bookFromTimeString;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final car = Provider.of<TheCar>(context);
    // _review = Provider.of<ReviewsProvider>(context).myReview.review;
    // _rating = Provider.of<ReviewsProvider>(context).myReview.rating;
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
                  return ChangeNotifierProvider<TheCar>.value(
                    value: car,
                    child: homeView(false, context, myReview),
                  );
                } else if (si.deviceScreenType == DeviceScreenType.tablet) {
                  return ChangeNotifierProvider<TheCar>.value(
                    value: car,
                    child: homeView(false, context, myReview),
                  );
                } else {
                  return ChangeNotifierProvider<TheCar>.value(
                    value: car,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        image(car),
                        imageDetails(car, isMobileView, context),
                        const SizedBox(
                          height: 30,
                        ),
                        reviewWidget(
                            Provider.of<ReviewsProvider>(context).reviews),
                        const SizedBox(
                          height: 60,
                        ),
                        ChangeNotifierProvider<Review>.value(
                          value: Provider.of<ReviewsProvider>(
                            context,
                          ).myReview,
                          child: ReviewAndRatingWidget(carId: car.id),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            imageWidget(car),
                            imageDetailWidget(car, isMobileView, context),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              flex: 3,
                              child: ChangeNotifierProvider<Review>.value(
                                value: Provider.of<ReviewsProvider>(
                                  context,
                                ).myReview,
                                child: ReviewAndRatingWidget(carId: car.id),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 3,
                              child: reviewWidget(
                                Provider.of<ReviewsProvider>(context).reviews,
                              ),
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

  // Widget reviewAndRatingWidget(
  //   BuildContext context,
  //   TheCar car,
  //   bool myReview,
  // ) {
  //   return Column(
  //     children: [
  //       Stack(
  //         clipBehavior: Clip.none,
  //         children: [
  //           DottedBorder(
  //             child: Container(
  //               height: 80,
  //               width: double.infinity,
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   begin: Alignment.topRight,
  //                   end: Alignment.bottomLeft,
  //                   colors: [
  //                     Colors.lightBlueAccent,
  //                     ThemeClass.primaryColor,
  //                   ],
  //                 ),
  //                 borderRadius: BorderRadius.circular(
  //                   2,
  //                 ),
  //               ),
  //             ),
  //           ),
  //           const Positioned(
  //             right: 0,
  //             left: 0,
  //             top: -42,
  //             child: CircleAvatar(
  //               radius: 42,
  //               backgroundColor: Colors.white,
  //               child: CircleAvatar(
  //                 radius: 40,
  //                 backgroundColor: Colors.black12,
  //                 backgroundImage: AssetImage(
  //                   'images/user.png',
  //                 ),
  //               ),
  //             ),
  //           ),
  //           Positioned(
  //             bottom: 6,
  //             right: 0,
  //             left: 0,
  //             child: Text(
  //               'Review By ${SharedService.userName}',
  //               style: GoogleFonts.raleway().copyWith(
  //                 fontSize: 16,
  //                 fontWeight: FontWeight.bold,
  //                 color: Colors.white,
  //               ),
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //         ],
  //       ),
  //       Form(
  //         key: _formKey,
  //         child: Column(
  //           children: [
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             RatingBar.builder(
  //               initialRating:
  //                   Provider.of<ReviewsProvider>(context, listen: true)
  //                       .myReview
  //                       .rating
  //                       .toDouble(),
  //               minRating: 1,
  //               glow: true,
  //               glowRadius: 0.5,
  //               direction: Axis.horizontal,
  //               allowHalfRating: false,
  //               itemCount: 5,
  //               itemPadding: const EdgeInsets.symmetric(
  //                 horizontal: 5.0,
  //               ),
  //               itemBuilder: (context, _) => Icon(
  //                 Icons.star,
  //                 color: ThemeClass.primaryColor,
  //               ),
  //               onRatingUpdate: (rating) {
  //                 _rating = rating.toInt();
  //               },
  //             ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 20,
  //               ),
  //               child: TextFormField(
  //                 initialValue:
  //                     !Provider.of<ReviewsProvider>(context, listen: true)
  //                             .haveIReviewed
  //                         ? ''
  //                         : Provider.of<ReviewsProvider>(context, listen: true)
  //                             .myReview
  //                             .review,
  //                 maxLines: 3,
  //                 key: const ValueKey(
  //                   'Write your review',
  //                 ),
  //                 decoration: const InputDecoration(
  //                   labelText: 'Your review',
  //                 ),
  //                 validator: (value) {
  //                   if (value!.trim().isEmpty) {
  //                     return 'Please provide your review.';
  //                   } else if (value.trim().length < 5) {
  //                     return 'Review is too short.';
  //                   }
  //                   return null;
  //                 },
  //                 onSaved: (value) {
  //                   _review = value!;
  //                 },
  //                 onChanged: (value) {
  //                   _review = value;
  //                 },
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 10,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 if (myReview)
  //                   TextButton(
  //                     onPressed: () async {
  //                       Provider.of<ReviewsProvider>(context, listen: false)
  //                           .deleteReview(car.id)
  //                           .then((value) {
  //                         _review = '';
  //                         _rating = 2;
  //                         FlutterToasts.showNormalToast(
  //                             context, 'Your review has been deleted.');
  //                       }).catchError((e) {
  //                         FlutterToasts.showErrorToast(context, e.toString());
  //                       });
  //                     },
  //                     child: Text(
  //                       'Delete your review',
  //                       style: GoogleFonts.raleway().copyWith(),
  //                     ),
  //                   ),
  //                 if (!myReview) const SizedBox(),
  //                 TextButton(
  //                   onPressed:
  //                       Provider.of<ReviewsProvider>(context).haveIReviewed
  //                           ? () async {
  //                               if (!_formKey.currentState!.validate()) {
  //                                 return;
  //                               }
  //                               _formKey.currentState!.save();
  //                               Review review = Review(
  //                                 id: '',
  //                                 rating: _rating,
  //                                 review: _review,
  //                                 userId: '',
  //                                 user: '',
  //                               );
  //                               // await myFreakinReview
  //                               //     .updateReview(review, car.id)
  //                               //     .then((value) {
  //                               //   FlutterToasts.showNormalToast(
  //                               //       context, 'Review updated successfully.');
  //                               // }).catchError((e) {
  //                               //   FlutterToasts.showErrorToast(
  //                               //       context, e.toString());
  //                               // });
  //                             }
  //                           : () async {
  //                               if (!_formKey.currentState!.validate()) {
  //                                 return;
  //                               }
  //                               _formKey.currentState!.save();
  //                               Review review = Review(
  //                                 id: '',
  //                                 rating: _rating,
  //                                 review: _review,
  //                                 userId: '',
  //                                 user: '',
  //                               );
  //                               await Provider.of<ReviewsProvider>(context,
  //                                       listen: false)
  //                                   .createReview(
  //                                 review,
  //                                 car.id,
  //                               )
  //                                   .then((value) {
  //                                 FlutterToasts.showNormalToast(
  //                                     context, 'Review posted successfully.');
  //                               }).catchError((e) {
  //                                 FlutterToasts.showErrorToast(
  //                                     context, e.toString());
  //                               });
  //                             },
  //                   child: Text(
  //                     Provider.of<ReviewsProvider>(context).haveIReviewed
  //                         ? 'Update your review'
  //                         : 'Post your review',
  //                     style: GoogleFonts.raleway().copyWith(),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

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
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.purple,
                  ),
                ),
                onPressed: () {
                  showBookingDialog(context, isMobileView, car);
                },
                child: Text(
                  'Proceed To Book',
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

class ReviewAndRatingWidget extends StatefulWidget {
  final dynamic carId;
  const ReviewAndRatingWidget({super.key, required this.carId});

  @override
  State<ReviewAndRatingWidget> createState() => _ReviewAndRatingWidgetState();
}

class _ReviewAndRatingWidgetState extends State<ReviewAndRatingWidget> {
  final _formKey = GlobalKey<FormState>();
  String? _review;
  int? _rating;
  @override
  Widget build(BuildContext context) {
    final myFreakinReview = Provider.of<Review>(context);
    _review = myFreakinReview.review;
    _rating = myFreakinReview.rating;

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
                initialRating:
                    Provider.of<ReviewsProvider>(context, listen: true)
                        .myReview
                        .rating
                        .toDouble(),
                minRating: 1,
                glow: true,
                glowRadius: 0.5,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(
                  horizontal: 5.0,
                ),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: ThemeClass.primaryColor,
                ),
                onRatingUpdate: (rating) {
                  _rating = rating.toInt();
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
                  initialValue:
                      !Provider.of<ReviewsProvider>(context, listen: true)
                              .haveIReviewed
                          ? ''
                          : Provider.of<ReviewsProvider>(context, listen: true)
                              .myReview
                              .review,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (Provider.of<ReviewsProvider>(context, listen: true)
                      .haveIReviewed)
                    TextButton(
                      onPressed: () async {
                        Provider.of<ReviewsProvider>(context, listen: false)
                            .deleteReview(widget.carId)
                            .then((value) {
                          _review = '';
                          _rating = 2;
                          FlutterToasts.showNormalToast(
                              context, 'Your review has been deleted.');
                        }).catchError((e) {
                          FlutterToasts.showErrorToast(context, e.toString());
                        });
                      },
                      child: Text(
                        'Delete your review',
                        style: GoogleFonts.raleway().copyWith(),
                      ),
                    ),
                  if (!Provider.of<ReviewsProvider>(context, listen: true)
                      .haveIReviewed)
                    const SizedBox(),
                  TextButton(
                    onPressed:
                        Provider.of<ReviewsProvider>(context).haveIReviewed
                            ? () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                _formKey.currentState!.save();
                                Review review = Review(
                                  id: '',
                                  rating: _rating!,
                                  review: _review!,
                                  userId: '',
                                  user: '',
                                );
                                await myFreakinReview
                                    .updateReview(review, widget.carId)
                                    .then((value) {
                                  FlutterToasts.showNormalToast(
                                      context, 'Review updated successfully.');
                                }).catchError((e) {
                                  FlutterToasts.showErrorToast(
                                      context, e.toString());
                                });
                              }
                            : () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                _formKey.currentState!.save();
                                Review review = Review(
                                  id: '',
                                  rating: _rating!,
                                  review: _review!,
                                  userId: '',
                                  user: '',
                                );
                                await Provider.of<ReviewsProvider>(context,
                                        listen: false)
                                    .createReview(
                                  review,
                                  widget.carId,
                                )
                                    .then((value) {
                                  FlutterToasts.showNormalToast(
                                      context, 'Review posted successfully.');
                                }).catchError((e) {
                                  FlutterToasts.showErrorToast(
                                      context, e.toString());
                                });
                              },
                    child: Text(
                      Provider.of<ReviewsProvider>(context).haveIReviewed
                          ? 'Update your review'
                          : 'Post your review',
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
}
