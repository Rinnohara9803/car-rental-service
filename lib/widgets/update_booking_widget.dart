import 'package:car_rental_service/models/booking.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/booking_response.dart';
import '../utilities/toasts.dart';

class UpdateBookingWidget extends StatefulWidget {
  const UpdateBookingWidget({
    Key? key,
    required this.isMobileView,
    required this.booking,
  }) : super(key: key);

  final bool isMobileView;
  final BookingResponse booking;

  @override
  State<UpdateBookingWidget> createState() => _UpdateBookingWidgetState();
}

class _UpdateBookingWidgetState extends State<UpdateBookingWidget> {
  TimeOfDay timeOfDay = TimeOfDay.now();
  DateTime? bookFromDate;
  String? _bookFromTime;
  String _bookToTime = '00:00:00';
  DateTime? bookToDate;
  TimeOfDay? bookFromTime;
  TimeOfDay? bookTime;

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
    return Positioned(
      right: 5,
      top: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          5,
        ),
        child: Material(
          color: Colors.purple,
          child: InkWell(
            splashColor: Colors.purple,
            child: const SizedBox(
              width: 30,
              height: 30,
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: 20,
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(builder: (ctx, StateSetter setState) {
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
                            } else if (bookFromTime!.hour.toString().length ==
                                    1 &&
                                bookFromTime!.minute.toString().length != 1) {
                              bookFromTimeString =
                                  '0${bookFromTime!.hour}:${bookFromTime!.minute}:00';
                            } else if (bookFromTime!.hour.toString().length !=
                                    1 &&
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
                                    : DateFormat('yyyy-MM-dd $_bookToTime')
                                        .format(bookToDate!),
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
                                'Update Booking . . .',
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
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Colors.purple,
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (bookFromDate == null ||
                                        bookToDate == null) {
                                      FlutterToasts.showNormalToast(context,
                                          'Provide necessary details to update booking.');
                                      return;
                                    } else {
                                      TheBooking newBooking = TheBooking(
                                        bookFrom: DateFormat(
                                                'yyyy-MM-dd $_bookFromTime')
                                            .format(bookFromDate!),
                                        bookTo: DateFormat(
                                                'yyyy-MM-dd $_bookToTime')
                                            .format(bookToDate!),
                                        totalCost: 0,
                                      );

                                      booking
                                          .updateBooking(
                                              newBooking, booking.bookedCar.id)
                                          .then((value) {
                                        FlutterToasts.showNormalToast(context,
                                            'Booking updated Successfully.');
                                        Navigator.of(context).pop();
                                      }).catchError((e) {
                                        FlutterToasts.showErrorToast(
                                          context,
                                          e.toString(),
                                        );
                                      });
                                    }
                                  },
                                  child: Text(
                                    'Update Booking',
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
            },
          ),
        ),
      ),
    );
  }
}
