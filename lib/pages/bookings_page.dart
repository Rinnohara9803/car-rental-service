import 'package:car_rental_service/pages/about_us_page.dart';
import 'package:car_rental_service/pages/cars_page.dart';
import 'package:car_rental_service/utilities/themes.dart';
import 'package:car_rental_service/widgets/on_hover_widget.dart';
import 'package:car_rental_service/widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../widgets/header_widget.dart';
import '../widgets/search_widget.dart';
import 'home_page.dart';

class BookingsPage extends StatefulWidget {
  static String routeName = '/bookingsPage';
  const BookingsPage({Key? key}) : super(key: key);

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage>
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
              toBookingsPage: () {},
              toCarsPage: () {
                Navigator.pushNamed(context, CarsPage.routeName);
              },
              toAboutUsPage: () {
                Navigator.pushNamed(context, AboutUsPage.routeName);
              },
            ),
            Container(
              height: 800,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}
