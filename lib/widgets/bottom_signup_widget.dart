import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomSignUpWidget extends StatelessWidget {
  const BottomSignUpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account ? ',
          style: GoogleFonts.raleway().copyWith(
            letterSpacing: 1,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            'Sign Up',
            style: GoogleFonts.raleway().copyWith(
              letterSpacing: 1,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
