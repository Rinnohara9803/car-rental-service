import 'package:car_rental_service/widgets/profile_widget.dart';
import 'package:car_rental_service/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'on_hover_widget.dart';

class HeaderWidget extends StatefulWidget {
  final bool isMobileView;
  final Function toHomePage;
  final Function toBookingsPage;
  final Function toCarsPage;
  final Function toAboutUsPage;
  final Color homePageColor;
  final Color bookingsPageColor;
  final Color carsPageColor;
  final Color aboutUsPageColor;
  const HeaderWidget({
    super.key,
    required this.isMobileView,
    required this.toHomePage,
    required this.toBookingsPage,
    required this.toCarsPage,
    required this.toAboutUsPage,
    required this.homePageColor,
    required this.bookingsPageColor,
    required this.carsPageColor,
    required this.aboutUsPageColor,
  });

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!widget.isMobileView) const SearchWidget(),
              if (!widget.isMobileView)
                Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                  ),
                  child: onHoverWidgets('Home', widget.homePageColor, () {
                    widget.toHomePage();
                  }),
                ),
              if (!widget.isMobileView)
                Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                  ),
                  child:
                      onHoverWidgets('Bookings', widget.bookingsPageColor, () {
                    widget.toBookingsPage();
                  }),
                ),
              if (!widget.isMobileView)
                Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                  ),
                  child: onHoverWidgets('Cars', widget.carsPageColor, () {
                    widget.toCarsPage();
                  }),
                ),
              if (!widget.isMobileView)
                Padding(
                  padding: const EdgeInsets.only(
                    right: 15,
                  ),
                  child:
                      onHoverWidgets('About Us', widget.aboutUsPageColor, () {
                    widget.toAboutUsPage();
                  }),
                ),
              if (widget.isMobileView) const SearchWidget(),
              const ProfileWidget(),
            ],
          ),
        ),
        if (widget.isMobileView)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                onHoverWidgets('Home', widget.homePageColor, () {
                  widget.toHomePage();
                }),
                onHoverWidgets('Bookings', widget.bookingsPageColor, () {
                  widget.toBookingsPage();
                }),
                onHoverWidgets('Cars', widget.carsPageColor, () {
                  widget.toCarsPage();
                }),
                onHoverWidgets('About Us', widget.aboutUsPageColor, () {
                  widget.toAboutUsPage();
                }),
              ],
            ),
          ),
      ],
    );
  }
}
