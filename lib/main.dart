import 'package:car_rental_service/pages/about_us_page.dart';
import 'package:car_rental_service/pages/bookings_page.dart';
import 'package:car_rental_service/pages/home_page.dart';
import 'package:car_rental_service/pages/cars_page.dart';
import 'package:car_rental_service/pages/add_cars_page.dart';
import 'package:car_rental_service/pages/manage_cars_page.dart';
import 'package:car_rental_service/pages/my_payments_page.dart';
import 'package:car_rental_service/pages/profile_page.dart';
import 'package:car_rental_service/pages/search_page.dart';
import 'package:car_rental_service/pages/sign_in_page.dart';
import 'package:car_rental_service/pages/sign_up_page.dart';
import 'package:car_rental_service/pages/update_car_details_page.dart';
import 'package:car_rental_service/providers/bookings_provider.dart';
import 'package:car_rental_service/providers/cars_provider.dart';
import 'package:car_rental_service/providers/reviews_provider.dart';
import 'package:car_rental_service/services/auth_service.dart';
import 'package:car_rental_service/services/shared_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

void main() async {
  var role = await AuthService.getUserRole();
  var email = await AuthService.getUserEmail();
  var userName = await AuthService.getUserName();
  var userId = await AuthService.getUserId();
  if (role == null || email == null || userName == null || userId == null) {
    runApp(const MyApp());
    return;
  }

  SharedService.role = role;
  SharedService.email = email;
  SharedService.userName = userName;
  SharedService.userID = userId;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CarsProvider>(
          create: (context) => CarsProvider(),
        ),
        ChangeNotifierProvider<BookingsProvider>(
          create: (context) => BookingsProvider(),
        ),
        ChangeNotifierProvider<ReviewsProvider>(
          create: (context) => ReviewsProvider(),
        ),
      ],
      child: KhaltiScope(
        publicKey: "test_public_key_a0d8cf0b60c34546a46140c5daf2c989",
        builder: (context, navigatorKey) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ne', 'NP'),
            ],
            localizationsDelegates: const [
              KhaltiLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            title: 'Car Rental Service',
            theme: ThemeData(
              primarySwatch: Colors.purple,
            ),
            home: const SignInPage(),
            routes: {
              SignInPage.routeName: (context) => const SignInPage(),
              SignUpPage.routeName: (context) => const SignUpPage(),
              HomePage.routeName: (context) => const HomePage(),
              BookingsPage.routeName: (context) => const BookingsPage(),
              CarsPage.routeName: (context) => const CarsPage(),
              AboutUsPage.routeName: (context) => const AboutUsPage(),
              AddCarsPage.routeName: (context) => const AddCarsPage(),
              ManageCarsPage.routeName: (context) => const ManageCarsPage(),
              UpdateCarDetailsPage.routeName: (context) =>
                  const UpdateCarDetailsPage(),
              SearchPage.routeName: (context) => const SearchPage(),
              MyPaymentsPage.routeName: (context) => const MyPaymentsPage(),
              ProfilePage.routeName: (context) => const ProfilePage(),
            },
          );
        },
      ),
    );
  }
}
