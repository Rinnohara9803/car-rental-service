import 'package:car_rental_service/pages/manage_cars_page.dart';
import 'package:car_rental_service/pages/sign_in_page.dart';
import 'package:car_rental_service/services/shared_services.dart';
import 'package:flutter/material.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';

import '../utilities/themes.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FocusedMenuHolder(
      onPressed: () {},
      duration: const Duration(
        seconds: 0,
      ),
      animateMenuItems: false,
      menuWidth: 200,
      menuItems: [
        FocusedMenuItem(
          title: const Text('Profile'),
          onPressed: () {},
        ),
        if (SharedService.email == 'admin@email.com')
          FocusedMenuItem(
            title: const Text('Manage Cars'),
            onPressed: () {
              Navigator.pushNamed(
                context,
                ManageCarsPage.routeName,
              );
            },
          ),
        FocusedMenuItem(
          title: const Text('Log Out'),
          backgroundColor: Colors.redAccent,
          trailingIcon: const Icon(
            Icons.logout,
          ),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              SignInPage.routeName,
              (route) => false,
            );
          },
        ),
      ],
      blurBackgroundColor: Colors.transparent,
      openWithTap: true,
      child: CircleAvatar(
        radius: 27,
        backgroundColor: ThemeClass.primaryColor,
        child: const CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage(
            'images/user.png',
          ),
        ),
      ),
    );
  }
}
