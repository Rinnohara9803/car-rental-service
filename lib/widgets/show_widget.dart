import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utilities/themes.dart';

class ShowWidget extends StatelessWidget {
  const ShowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        color: ThemeClass.primaryColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage('images/car.png'),
                height: 140,
                width: 140,
              ),
              Text(
                'Car Rentals',
                style: GoogleFonts.raleway().copyWith(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    
  }
}
