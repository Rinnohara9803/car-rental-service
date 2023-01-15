import 'dart:io';

import 'package:car_rental_service/pages/home_page.dart';
import 'package:car_rental_service/pages/sign_up_page.dart';
import 'package:car_rental_service/services/auth_service.dart';
import 'package:car_rental_service/utilities/themes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../utilities/toasts.dart';
import '../widgets/circular_progress_indicator.dart';
import '../widgets/general_textformfield.dart';

class SignInPage extends StatefulWidget {
  static String routeName = '/signInPage';
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
      await AuthService.signInuser(
              _emailController.text, _passwordController.text)
          .then((value) {
        Navigator.pushNamed(context, HomePage.routeName);
      });
    } on SocketException {
      FlutterToasts.showNoInternetConnectionSnackBar(context);
    } catch (e) {
      FlutterToasts.showErrorToast(
        context,
        e.toString(),
      );
    }
    setState(() {
      _isLoading = false;
    });
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
                      'Let\'s',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway().copyWith(
                        fontSize: 35,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      ' Sign In',
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
                  'Hey, Enter your details to sign in to your account.',
                  style: GoogleFonts.raleway().copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 3,
                    bottom: 5,
                  ),
                  child: Text(
                    'Email',
                    style: GoogleFonts.raleway().copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                GeneralTextFormField(
                  hasPrefixIcon: true,
                  hasSuffixIcon: false,
                  controller: _emailController,
                  label: 'Email',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email.';
                    }
                    if (!value.contains('@') || !value.endsWith('.com')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  textInputType: TextInputType.emailAddress,
                  iconData: Icons.mail_outline,
                  autoFocus: false,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 3,
                    bottom: 5,
                  ),
                  child: Text(
                    'Password',
                    style: GoogleFonts.raleway().copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                GeneralTextFormField(
                  hasPrefixIcon: true,
                  hasSuffixIcon: true,
                  controller: _passwordController,
                  label: 'Password',
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'Please enter your password.';
                    } else if (value.trim().length < 6) {
                      return 'Please enter at least 6 characters.';
                    }
                    return null;
                  },
                  textInputType: TextInputType.name,
                  iconData: Icons.lock,
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
                                'Sign In',
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
