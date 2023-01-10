import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utilities/constants.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 10,
        ),
        child: TextFormField(
          keyboardType: TextInputType.name,
          validator: (value) {},
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
              'Search for cars ...',
              style: GoogleFonts.raleway().copyWith(),
            ),
            errorBorder: errorBorder,
            focusedBorder: focusedBorder,
            focusedErrorBorder: focusedErrorBorder,
            prefixIcon: const Icon(Icons.search),
          ),
          onSaved: (text) {},
        ),
      ),
    );
    // return Expanded(
    //   child: Container(
    //     padding: const EdgeInsets.symmetric(
    //       vertical: 4,
    //       horizontal: 10,/'
    //     ),
    //     margin: const EdgeInsets.only(
    //       right: 10,
    //     ),
    //     height: 40,
    //     decoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(
    //         20,
    //       ),
    //       color: const Color.fromARGB(255, 227, 221, 221),
    //     ),
    //     child: Row(
    //       children: const [
    //         Icon(Icons.search),
    //         SizedBox(
    //           width: 5,
    //         ),
    //         Text('Search for cars ....'),
    //       ],
    //     ),
    //   ),
    // );
  }
}
