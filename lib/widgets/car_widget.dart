import 'package:car_rental_service/models/car.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../config.dart';
import '../pages/car_details_page.dart';
import '../providers/cars_provider.dart';
import '../utilities/snackbars.dart';

class CarWidget extends StatelessWidget {
  final bool isMobileView;
  const CarWidget({
    Key? key,
    required this.isMobileView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget detailWidget(IconData iconData, String value) {
      return Row(
        children: [
          Icon(
            iconData,
            color: Colors.white,
            size: 15,
          ),
          Text(
            value,
            style: GoogleFonts.raleway().copyWith(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ],
      );
    }

    final car = Provider.of<TheCar>(context);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, CarDetailsPage.routeName);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(
                    5,
                  ),
                  topRight: Radius.circular(
                    5,
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholderFit: BoxFit.cover,
                    placeholder: const AssetImage(
                      'images/loading.gif',
                    ),
                    image: NetworkImage(
                      car.image,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 70,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      car.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.raleway().copyWith(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    if (isMobileView)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              detailWidget(
                                Icons.power_rounded,
                                '${car.horsePower} hp',
                              ),
                              detailWidget(
                                Icons.power_settings_new,
                                '${car.mileage} km/l',
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 5,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Rs.${car.price}',
                                  style: GoogleFonts.raleway().copyWith(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  ' / hour',
                                  style: GoogleFonts.raleway().copyWith(
                                    color: Colors.white38,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (!isMobileView)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                detailWidget(
                                  Icons.power_rounded,
                                  '${car.horsePower} hp',
                                ),
                                detailWidget(
                                  Icons.power_settings_new,
                                  '${car.mileage} km/l',
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Rs.${car.price}',
                                  style: GoogleFonts.raleway().copyWith(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  ' / hour',
                                  style: GoogleFonts.raleway().copyWith(
                                    color: Colors.white38,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
