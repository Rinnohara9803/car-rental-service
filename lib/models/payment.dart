import 'package:car_rental_service/providers/booking_response.dart';

class Payment {
  final dynamic id;
  final dynamic paymentToken;
  final dynamic mobile;
  final BookingResponse booking;

  Payment({
    required this.id,
    required this.paymentToken,
    required this.mobile,
    required this.booking,
  });
}
