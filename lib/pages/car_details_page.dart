import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CarDetailsPage extends StatefulWidget {
  static String routeName = '/carDetailsPage';
  const CarDetailsPage({super.key});

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
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
      child: Column(
        children: [
          SizedBox(
            height: 400,
            width: double.infinity,
            child: Row(
              children: [
                const Expanded(
                  flex: 5,
                  child: SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      placeholderFit: BoxFit.cover,
                      placeholder: AssetImage(
                        'images/loading.gif',
                      ),
                      image: AssetImage(
                        'images/car.jpg',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
