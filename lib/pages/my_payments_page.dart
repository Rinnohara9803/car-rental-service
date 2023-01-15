import 'package:car_rental_service/pages/bookings_page.dart';
import 'package:car_rental_service/pages/home_page.dart';
import 'package:car_rental_service/pages/cars_page.dart';
import 'package:car_rental_service/utilities/themes.dart';
import 'package:car_rental_service/widgets/bottom_signup_widget.dart';
import 'package:car_rental_service/widgets/on_hover_widget.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../widgets/header_widget.dart';

class MyPaymentsPage extends StatefulWidget {
  static String routeName = '/myPaymentsPage';
  const MyPaymentsPage({Key? key}) : super(key: key);

  @override
  State<MyPaymentsPage> createState() => _MyPaymentsPageState();
}

class _MyPaymentsPageState extends State<MyPaymentsPage>
    with TickerProviderStateMixin {
  Widget onHoverWidgets(String value, Color textColor, Function onTap) {
    return OnHover(
      builder: (onHovered) {
        return InkWell(
          onTap: () {
            onTap();
          },
          child: Text(
            value,
            style: GoogleFonts.raleway().copyWith(
              fontWeight: FontWeight.normal,
              color: textColor,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveBuilder(
        builder: (context, si) {
          if (si.deviceScreenType == DeviceScreenType.desktop) {
            return homeView(false);
          } else if (si.deviceScreenType == DeviceScreenType.tablet) {
            return homeView(false);
          } else {
            return homeView(true);
          }
        },
      ),
    );
  }

  SingleChildScrollView homeView(bool isMobileView) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 15,
        ),
        child: Column(
          children: [
            HeaderWidget(
              isMobileView: isMobileView,
              toHomePage: () {
                Navigator.pushNamed(context, HomePage.routeName);
              },
              toBookingsPage: () {
                Navigator.pushNamed(context, BookingsPage.routeName);
              },
              toCarsPage: () {
                Navigator.pushNamed(context, CarsPage.routeName);
              },
              toAboutUsPage: () {},
              homePageColor: Colors.black,
              bookingsPageColor: Colors.black,
              carsPageColor: Colors.black,
              aboutUsPageColor: ThemeClass.primaryColor,
            ),
            aboutUsWidget(isMobileView),
            const SizedBox(
              height: 30,
            ),
            Text(
              'Car Rentals Company and Agency',
              style: GoogleFonts.raleway().copyWith(
                color: ThemeClass.primaryColor,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              'carrentals9803@gmail.com',
              style: GoogleFonts.raleway().copyWith(
                fontStyle: FontStyle.normal,
                fontSize: 12,
                decoration: TextDecoration.underline,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const BottomSignUpWidget(),
          ],
        ),
      ),
    );
  }

  Widget aboutUsWidget(bool isMobileView) {
    if (isMobileView) {
      return Column(
        children: [
          Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: const Image(
              image: AssetImage('images/rent_car.webp'),
              fit: BoxFit.fill,
            ),
          ),
          Container(
            height: 400,
            decoration: BoxDecoration(
              color: ThemeClass.primaryColor,
              border: Border.all(
                color: Colors.blue,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Car Rentals',
                      style: GoogleFonts.raleway().copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Car Rentals is associated and working under the management of Sunway Transport which is a registered Car Rental Service and Company approved by government of Nepal. The Company Offers Car Rental Service in Nepal. The head office is located in Kamalpokhari, Kathmandu. As a Car Rentals Company & Agency, we have been offering car rental service in Nepal including van, jeep, mini and big bus rental service.',
                      style: GoogleFonts.raleway().copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 1,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Flexible(
            child: Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: const Image(
                image: AssetImage('images/rent_car.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Flexible(
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                color: ThemeClass.primaryColor,
                border: Border.all(
                  color: Colors.blue,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Car Rentals',
                        style: GoogleFonts.raleway().copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 35,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Car Rentals is associated and working under the management of Sunway Transport which is a registered Car Rental Service and Company approved by government of Nepal. The Company Offers Car Rental Service in Nepal. The head office is located in Kamalpokhari, Kathmandu. As a Car Rentals Company & Agency, we have been offering car rental service in Nepal including van, jeep, mini and big bus rental service.',
                        style: GoogleFonts.raleway().copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
