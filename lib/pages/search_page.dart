import 'dart:io';

import 'package:car_rental_service/providers/cars_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

import '../providers/car.dart';
import '../utilities/constants.dart';
import '../utilities/snackbars.dart';
import '../widgets/car_widget.dart';

class SearchPage extends StatefulWidget {
  static String routeName = '/searchPage';
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  final _formKey = GlobalKey<FormState>();

  String searchValue = '';

  Future? _getSearchData;

  Future _saveForm() async {
    try {
      setState(() {});
      await Provider.of<CarsProvider>(context, listen: false)
          .getCarsBySearch(searchValue)
          .then((value) {})
          .catchError((e) {
        SnackBars.showErrorSnackBar(context, e.toString());
      });
    } on SocketException {
      SnackBars.showNoInternetConnectionSnackBar(context);
    } catch (e) {
      SnackBars.showErrorSnackBar(
        context,
        e.toString(),
      );
    }
  }

  @override
  void initState() {
    _getSearchData = Provider.of<CarsProvider>(context, listen: false)
        .getCarsBySearch(searchValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: ResponsiveBuilder(
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 10,
                  ),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        isDense: true,
                        border: border,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 1.5,
                            color: Colors.black54,
                          ),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        label: Text(
                          'Search for cars',
                          style: GoogleFonts.raleway().copyWith(),
                        ),
                        errorBorder: errorBorder,
                        focusedBorder: focusedBorder,
                        focusedErrorBorder: focusedErrorBorder,
                        prefixIcon: const Icon(Icons.search),
                      ),
                      onSaved: (text) {
                        searchValue = text.toString();
                      },
                      onChanged: (text) {
                        searchValue = text.toString();
                      },
                    ),
                  ),
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
                  onPressed: () async {
                    await _saveForm();
                  },
                  icon: const Icon(Icons.search),
                  label: Text(
                    'Search',
                    style: GoogleFonts.raleway().copyWith(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: searchValue.isEmpty
                ? Center(
                    child: Text(
                      'Search for cars....',
                      style: GoogleFonts.raleway().copyWith(),
                    ),
                  )
                : FutureBuilder(
                    future: _getSearchData,
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
                                await _getSearchData;
                              },
                              child: carsData.searchData.isEmpty
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
                                      itemCount: carsData.searchData.length,
                                      itemBuilder: (BuildContext ctx, index) {
                                        return ChangeNotifierProvider<
                                            TheCar>.value(
                                          value: carsData.searchData[index],
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
          ),
        ],
      ),
    );
  }
}
