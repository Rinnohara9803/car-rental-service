import 'package:car_rental_service/models/car.dart';
import 'package:car_rental_service/pages/add_cars_page.dart';
import 'package:car_rental_service/providers/cars_provider.dart';
import 'package:car_rental_service/widgets/on_hover_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

import '../widgets/my_car_widget.dart';

class ManageCarsPage extends StatefulWidget {
  static String routeName = '/manageCarsPage';
  const ManageCarsPage({Key? key}) : super(key: key);

  @override
  State<ManageCarsPage> createState() => _ManageCarsPageState();
}

class _ManageCarsPageState extends State<ManageCarsPage> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  Future? _getAllCarsData;

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
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Our Collections',
                style: GoogleFonts.raleway().copyWith(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              SizedBox(
                height: 38,
                child: ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.purple,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AddCarsPage.routeName);
                  },
                  icon: const Icon(Icons.car_rental),
                  label: Text(
                    'Add Cars',
                    style: GoogleFonts.raleway().copyWith(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder(
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
                                    child: MyCarWidget(
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
          ),
        ],
      ),
    );
  }
}
