import 'package:car_rental_service/providers/car.dart';
import 'package:car_rental_service/pages/update_car_details_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/cars_provider.dart';
import '../utilities/snackbars.dart';

class MyCarWidget extends StatelessWidget {
  final bool isMobileView;
  const MyCarWidget({
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
        // Navigator.pushNamed(context, CarDetailsPage.routeName);
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
              child: Stack(
                children: [
                  ClipRRect(
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
                  Positioned(
                    right: 5,
                    top: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      child: Material(
                        color: Colors.purple,
                        child: InkWell(
                          splashColor: Colors.purple,
                          child: const SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChangeNotifierProvider<TheCar>.value(
                                  value: car,
                                  child: const UpdateCarDetailsPage(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 40,
                    top: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      child: Material(
                        color: Colors.red, // button color
                        child: InkWell(
                          splashColor: Colors.red, // inkwell color
                          child: const SizedBox(
                            width: 30,
                            height: 30,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Are you Sure?'),
                                  content: const Text(
                                    'Do you want to delete this car?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Provider.of<CarsProvider>(context,
                                                listen: false)
                                            .deleteCar(car.id)
                                            .then((value) {
                                          Navigator.of(context).pop();
                                          SnackBars.showNormalSnackbar(context,
                                              'Car deleted successfully.');
                                        }).catchError((e) {
                                          SnackBars.showErrorSnackBar(
                                              context, e.toString());
                                        });
                                      },
                                      child: const Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
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
