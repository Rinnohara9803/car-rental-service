import 'package:car_rental_service/models/booking_response.dart';
import 'package:car_rental_service/pages/about_us_page.dart';
import 'package:car_rental_service/pages/cars_page.dart';
import 'package:car_rental_service/providers/bookings_provider.dart';
import 'package:car_rental_service/utilities/themes.dart';
import 'package:car_rental_service/widgets/on_hover_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';
import '../widgets/header_widget.dart';
import '../widgets/my_booking_widget.dart';
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

  Future? _getAllCarsData;
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    _getAllCarsData =
        Provider.of<BookingsProvider>(context, listen: false).fetchBookings();
    super.initState();
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
              homePageColor: Colors.black,
              bookingsPageColor: ThemeClass.primaryColor,
              carsPageColor: Colors.black,
              aboutUsPageColor: Colors.black,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'My Bookings',
              style: GoogleFonts.raleway().copyWith(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            FutureBuilder(
              future: _getAllCarsData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                      childAspectRatio: 8 / 6,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: 6,
                    itemBuilder: (BuildContext ctx, index) {
                      return Shimmer.fromColors(
                        period: const Duration(
                          milliseconds: 1500,
                        ),
                        baseColor: Colors.blueGrey,
                        highlightColor: Colors.white,
                        direction: ShimmerDirection.ltr,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: Column(
                            children: [
                              Flexible(
                                flex: 3,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(
                                      10,
                                    ),
                                    topLeft: Radius.circular(
                                      10,
                                    ),
                                  ),
                                  child: Container(
                                    color: Colors.black12,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.circular(
                                      10,
                                    ),
                                    bottomLeft: Radius.circular(
                                      10,
                                    ),
                                  ),
                                  child: Container(
                                    color: Colors.black26,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(snapshot.error.toString()),
                      ],
                    ),
                  );
                } else {
                  return Consumer<BookingsProvider>(
                    builder: (context, bookingsData, child) {
                      return RefreshIndicator(
                        key: _refreshIndicatorKey,
                        onRefresh: () async {
                          await bookingsData.fetchBookings();
                        },
                        child: bookingsData.bookings.isEmpty
                            ? const SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: Center(
                                    child: Text('No Bookings available.')),
                              )
                            : GridView.builder(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 400,
                                  childAspectRatio: 8 / 6,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                ),
                                itemCount: bookingsData.bookings.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return ChangeNotifierProvider<
                                      BookingResponse>.value(
                                    value: bookingsData.bookings[index],
                                    child: MyBookingWidget(
                                      isMobileView: isMobileView,
                                    ),
                                  );
                                },
                              ),
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
