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

  static String routeName = '/carDetailsPage';
  const BookingCarDetailsPage({
    super.key,
    required this.carId,
  });

  @override
  State<BookingCarDetailsPage> createState() => _BookingCarDetailsPageState();
}

class _BookingCarDetailsPageState extends State<BookingCarDetailsPage> {
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
                            ChangeNotifierProvider<BookingResponse>.value(
                              value: booking,
                              child: imageWidget(car),
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

  Widget imageWidget(TheCar car) {
    final booking = Provider.of<BookingResponse>(context);
    return Flexible(
      child: ChangeNotifierProvider<BookingResponse>.value(
        value: booking,
        child: imageWidget(car),
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
