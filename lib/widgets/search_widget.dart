import 'package:flutter/material.dart';

import '../pages/search_page.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, SearchPage.routeName);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 10,
          ),
          margin: const EdgeInsets.only(
            right: 10,
          ),
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              10,
            ),
            border: Border.all(
              color: Colors.black,
            ),
            color: const Color.fromARGB(255, 227, 221, 221),
          ),
          child: Row(
            children: const [
              Icon(Icons.search),
              SizedBox(
                width: 5,
              ),
              Text('Search for cars ....'),
            ],
          ),
        ),
      ),
    );
  }
}

