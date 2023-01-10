import 'dart:async';
import 'package:flutter/material.dart';

class SlidingWidgets extends StatefulWidget {
  final int height;
  const SlidingWidgets({Key? key, required this.height}) : super(key: key);

  @override
  State<SlidingWidgets> createState() => _SlidingWidgetsState();
}

class _SlidingWidgetsState extends State<SlidingWidgets> {
  int _currentPage = 0;
  final PageController _pageController = PageController(
    initialPage: 0,
  );
  bool end = false;
  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 7), (Timer timer) {
      if (_currentPage == 2) {
        end = true;
      } else if (_currentPage == 0) {
        end = false;
      }

      if (end == false) {
        _currentPage++;
      } else {
        _currentPage--;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeIn,
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 20,
      child: SizedBox(
        height: widget.height.toDouble(),
        child: PageView(
          controller: _pageController,
          children: const [
            FadeInImage(
              fit: BoxFit.fill,
              placeholder: AssetImage(
                'images/loading.gif',
              ),
              placeholderFit: BoxFit.cover,
              image: AssetImage(
                'images/slide1.gif',
              ),
            ),
            FadeInImage(
              fit: BoxFit.cover,
              placeholderFit: BoxFit.cover,
              placeholder: AssetImage(
                'images/loading.gif',
              ),
              image: AssetImage(
                'images/slide2.webp',
              ),
            ),
            FadeInImage(
              fit: BoxFit.fill,
              placeholderFit: BoxFit.cover,
              placeholder: AssetImage(
                'images/loading.gif',
              ),
              image: NetworkImage(
                'images/slide3.webp',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
