import 'dart:io';

import 'package:car_rental_service/pages/home_page.dart';
import 'package:car_rental_service/pages/sign_up_page.dart';
import 'package:car_rental_service/services/auth_service.dart';
import 'package:car_rental_service/services/shared_services.dart';
import 'package:car_rental_service/utilities/themes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../utilities/toasts.dart';
import '../widgets/circular_progress_indicator.dart';
import '../widgets/general_textformfield.dart';

class ProfilePage extends StatefulWidget {
  static String routeName = '/profilePage';
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _nameController;
  TextEditingController? _emailController;

  bool _isLoading = false;

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await AuthService.updateUserDetails(
        _emailController!.text,
        _nameController!.text,
      ).then((value) {
        Navigator.pushNamed(context, HomePage.routeName);
      });
    } on SocketException {
      FlutterToasts.showNoInternetConnectionSnackBar(context);
    } catch (e) {
      FlutterToasts.showErrorToast(
        context,
        'Something went wrong.',
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    _nameController = TextEditingController(text: SharedService.userName);
    _emailController = TextEditingController(text: SharedService.email);

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: ResponsiveBuilder(
          builder: (context, si) {
            if (si.deviceScreenType == DeviceScreenType.desktop) {
              return Row(
                children: [
                  showWidget(),
                  signInForm(),
                ],
              );
            } else if (si.deviceScreenType == DeviceScreenType.tablet) {
              return Row(
                children: [
                  showWidget(),
                  signInForm(),
                ],
              );
            } else {
              return signInForm1();
            }
          },
        ),
      ),
    );
  }

  Widget signInForm() {
    return Flexible(
      child: signInWidget(),
    );
  }

  Widget signInForm1() {
    return signInWidget();
  }

  Padding signInWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'Update',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway().copyWith(
                        fontSize: 35,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      ' Profile',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway().copyWith(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: ThemeClass.primaryColor,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  'Hey, Enter your details to update your profile.',
                  style: GoogleFonts.raleway().copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GeneralTextFormField(
                  hasPrefixIcon: true,
                  hasSuffixIcon: false,
                  controller: _nameController!,
                  label: 'Username',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your username.';
                    }

                    return null;
                  },
                  textInputType: TextInputType.emailAddress,
                  iconData: Icons.person,
                  autoFocus: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                GeneralTextFormField(
                  hasPrefixIcon: true,
                  hasSuffixIcon: false,
                  controller: _emailController!,
                  label: 'Email',
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please enter your email.';
                    }
                    if (!value.contains('@') || !value.endsWith('.com')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  textInputType: TextInputType.name,
                  iconData: Icons.email,
                  autoFocus: false,
                ),
                const SizedBox(
                  height: 30,
                ),
                Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                  child: InkWell(
                    onTap: () async {
                      _saveForm();
                    },
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: ThemeClass.primaryColor,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Center(
                        child: _isLoading
                            ? const ProgressIndicator1()
                            : Text(
                                'Update Profile',
                                style: GoogleFonts.raleway().copyWith(
                                  fontSize: 15,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      'Don\'t have an account ? ',
                      style: GoogleFonts.raleway().copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, SignUpPage.routeName);
                      },
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.raleway().copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: ThemeClass.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget showWidget() {
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
