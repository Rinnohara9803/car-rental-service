import 'package:car_rental_service/pages/about_us_page.dart';
import 'package:car_rental_service/pages/bookings_page.dart';
import 'package:car_rental_service/pages/car_details_page.dart';
import 'package:car_rental_service/pages/home_page.dart';
import 'package:car_rental_service/pages/cars_page.dart';
import 'package:car_rental_service/pages/add_cars_page.dart';
import 'package:car_rental_service/pages/manage_cars_page.dart';
import 'package:car_rental_service/pages/sign_in_page.dart';
import 'package:car_rental_service/pages/sign_up_page.dart';
import 'package:car_rental_service/pages/update_car_details_page.dart';
import 'package:car_rental_service/providers/cars_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SignInPage(),
        routes: {
          SignInPage.routeName: (context) => const SignInPage(),
          SignUpPage.routeName: (context) => const SignUpPage(),
          HomePage.routeName: (context) => const HomePage(),
          BookingsPage.routeName: (context) => const BookingsPage(),
          CarsPage.routeName: (context) => const CarsPage(),
          AboutUsPage.routeName: (context) => const AboutUsPage(),
          CarDetailsPage.routeName: (context) => const CarDetailsPage(),
          AddCarsPage.routeName: (context) => const AddCarsPage(),
          ManageCarsPage.routeName: (context) => const ManageCarsPage(),
          UpdateCarDetailsPage.routeName: (context) =>
              const UpdateCarDetailsPage(),
        },
      ),
    );
  }
}
