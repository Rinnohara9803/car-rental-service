// import 'dart:convert';
// import 'dart:io';
// // ignore: depend_on_referenced_packages
// import 'package:http/http.dart' as http;

// class KhaltiPaymentService {
//   static var khaltiToken = '';
//   static var theirPartyKhaltiPin = '';
//   static Future<void> initiateTransaction(
//       String khaltiNumber, String khaltiPin) async {
//     try {
//       final uri = Uri.parse('https://khalti.com/api/v2/payment/initiate/');
//       Map<String, String> headers = {
//         "Content-type": "application/json",
//       };
//       var responseData = await http.post(
//         uri,
//         body: jsonEncode({
//           "public_key": "test_public_key_a0d8cf0b60c34546a46140c5daf2c989",
//           "mobile": khaltiNumber,
//           "transaction_pin": khaltiPin,
//           "amount": 10000,
//           "product_identity": "patch101",
//           "product_name": "patch101",
//         }),
//         headers: headers,
//       );
//       print(responseData.statusCode);
//       var jsonData = jsonDecode(responseData.body);

//       if (responseData.statusCode == 200) {
//         khaltiToken = jsonData['token'];
//         theirPartyKhaltiPin = khaltiPin;
//       } else {
//         return Future.error(jsonData['detail']);
//       }
//     } on SocketException {
//       return Future.error('No Internet Connection.');
//     } catch (e) {
//       return Future.error(e.toString());
//     }
//   }
// }
