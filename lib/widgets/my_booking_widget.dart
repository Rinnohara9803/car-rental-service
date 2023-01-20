import 'package:car_rental_service/providers/booking_response.dart';
import 'package:car_rental_service/providers/bookings_provider.dart';
import 'package:car_rental_service/providers/car.dart';
import 'package:car_rental_service/widgets/update_booking_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';

import '../models/payment.dart';
import '../pages/booking_car_details_page.dart';
import '../pages/car_details_page.dart';
import '../utilities/toasts.dart';

class MyBookingWidget extends StatelessWidget {
  final bool isMobileView;
  const MyBookingWidget({
    Key? key,
    required this.isMobileView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget detailWidget(String initialValue, String value) {
      return Row(
        children: [
          Text(
            initialValue,
            style: GoogleFonts.raleway().copyWith(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          Text(
            value.substring(0, 10),
            style: GoogleFonts.raleway().copyWith(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ],
      );
    }

    initKhaltiPayment(BookingResponse booking) async {
      await KhaltiScope.of(context).pay(
        config: PaymentConfig(
          amount: booking.totalPrice.toInt() * 100,
          productIdentity: booking.bookedCar.id.toString(),
          productName: booking.bookedCar.name,
        ),
        preferences: [
          PaymentPreference.khalti,
          PaymentPreference.connectIPS,
          PaymentPreference.eBanking,
          PaymentPreference.mobileBanking,
          PaymentPreference.sct,
        ],
        onSuccess: (suJsonData) async {
          print(suJsonData);
          Payment payment = Payment(
            id: suJsonData.idx,
            paymentToken: suJsonData.token,
            mobile: suJsonData.mobile,
            booking: booking,
          );
        },
        onFailure: (fa) {
          FlutterToasts.showErrorToast(context, 'Payment failed!!!');
        },
        onCancel: () {
          FlutterToasts.showErrorToast(context, 'Payment cancelled!!!');
        },
      );
    }

    final booking = Provider.of<BookingResponse>(context);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<BookingResponse>.value(
              value: booking,
              child: BookingCarDetailsPage(
                carId: booking.bookedCar.id,
              ),
            ),
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(
                        5,
                      ),
                      topRight: Radius.circular(
                        5,
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: FadeInImage(
                        fit: BoxFit.cover,
                        placeholderFit: BoxFit.cover,
                        placeholder: const AssetImage(
                          'images/loading.gif',
                        ),
                        image: NetworkImage(
                          booking.bookedCar.image,
                        ),
                      ),
                    ),
                  ),
                  if (booking.status == 'active')
                    ChangeNotifierProvider<BookingResponse>.value(
                      value: booking,
                      child: UpdateBookingWidget(
                        isMobileView: isMobileView,
                        booking: booking,
                      ),
                    ),
                  if (booking.status == 'active')
                    Positioned(
                      right: 40,
                      top: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          5,
                        ),
                        child: Material(
                          color: Colors.black26, // button color
                          child: InkWell(
                            splashColor: Colors.red, // inkwell color
                            child: const SizedBox(
                              width: 30,
                              height: 30,
                              child: Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Are you Sure?'),
                                    content: const Text(
                                      'Do you want to cancel this booking?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: const Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Provider.of<BookingsProvider>(context,
                                                  listen: false)
                                              .cancelBooking(booking.id)
                                              .then((value) {
                                            FlutterToasts.showNormalToast(
                                                context,
                                                'Booking cancelled successfully.');
                                            Navigator.of(context).pop();
                                          }).catchError((e) {
                                            FlutterToasts.showErrorToast(
                                                context, e.toString());
                                          });
                                        },
                                        child: const Text('Yes'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  if (booking.status == 'active')
                    Positioned(
                      right: 75,
                      top: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          5,
                        ),
                        child: Material(
                          color: Colors.black26, // button color
                          child: InkWell(
                            splashColor: Colors.blueAccent, // inkwell color
                            child: const SizedBox(
                              width: 30,
                              height: 30,
                              child: Icon(
                                Icons.payment,
                                color: Colors.blueAccent,
                                size: 20,
                              ),
                            ),
                            onTap: () {
                              initKhaltiPayment(booking);
                            },
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 70,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      booking.bookedCar.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.raleway().copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    if (isMobileView)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              detailWidget(
                                'From: ',
                                booking.bookedFrom,
                              ),
                              detailWidget(
                                'To: ',
                                booking.bookedTo,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Total Price: Rs.${booking.totalPrice.toInt()}',
                                style: GoogleFonts.raleway().copyWith(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    if (!isMobileView)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                detailWidget(
                                  'From: ',
                                  booking.bookedFrom,
                                ),
                                detailWidget(
                                  'To: ',
                                  booking.bookedTo,
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Total Price: Rs.${booking.totalPrice.toInt()}',
                                  style: GoogleFonts.raleway().copyWith(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
