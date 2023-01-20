import 'package:car_rental_service/providers/car.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../pages/car_details_page.dart';

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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider<TheCar>.value(
              value: car,
              child: CarDetailsPage(
                carId: car.id,
              ),
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
          Positioned(
            top: 5,
            left: 5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 15,
                ),
                Text(
                  car.rating.toString(),
                  style: GoogleFonts.raleway().copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
