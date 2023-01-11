import 'package:car_rental_service/pages/about_us_page.dart';
import 'package:car_rental_service/pages/bookings_page.dart';
import 'package:car_rental_service/pages/home_page.dart';
import 'package:car_rental_service/utilities/themes.dart';
import 'package:car_rental_service/widgets/on_hover_widget.dart';
import 'package:car_rental_service/widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/car.dart';
import '../providers/cars_provider.dart';
import '../widgets/car_widget.dart';
import '../widgets/header_widget.dart';
import '../widgets/search_widget.dart';

class CarsPage extends StatefulWidget {
  static String routeName = '/carsPage';
  const CarsPage({Key? key}) : super(key: key);

  @override
  State<CarsPage> createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> with TickerProviderStateMixin {
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
        Provider.of<CarsProvider>(context, listen: false).getAllCars();
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

  Widget homeView(bool isMobileView) {
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
              toBookingsPage: () {
                Navigator.pushNamed(context, BookingsPage.routeName);
              },
              toCarsPage: () {},
              toAboutUsPage: () {
                Navigator.pushNamed(context, AboutUsPage.routeName);
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Our Collections',
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
                        const Text('And'),
                        TextButton(
                          onPressed: () async {
                            setState(() {});
                          },
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Consumer<CarsProvider>(
                    builder: (context, carsData, child) {
                      return RefreshIndicator(
                        key: _refreshIndicatorKey,
                        onRefresh: () async {
                          await carsData.getAllCars();
                        },
                        child: carsData.cars.isEmpty
                            ? const Center(
                                child: Text('No Cars available.'),
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
                                itemCount: carsData.cars.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return ChangeNotifierProvider<TheCar>.value(
                                    value: carsData.cars[index],
                                    child: CarWidget(
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
