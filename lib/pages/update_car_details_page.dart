import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:car_rental_service/widgets/show_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../providers/car.dart';
import '../utilities/toasts.dart';
import '../utilities/themes.dart';
import '../widgets/circular_progress_indicator.dart';
import '../widgets/general_textformfield.dart';

class UpdateCarDetailsPage extends StatefulWidget {
  static String routeName = '/updateCarDetailsPage';
  const UpdateCarDetailsPage({super.key});

  @override
  State<UpdateCarDetailsPage> createState() => _UpdateCarDetailsPageState();
}

class _UpdateCarDetailsPageState extends State<UpdateCarDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _carNameController;
  TextEditingController? _carDescriptionController;
  TextEditingController? _carNumberController;
  TextEditingController? _mileageController;
  TextEditingController? _horsePowerController;
  TextEditingController? _priceController;

  bool _isLoading = false;
  XFile? image;
  TheCar? car;

  void clearForm() {
    _carNameController!.clear();
    _carDescriptionController!.clear();
    _carNumberController!.clear();
    _mileageController!.clear();
    _horsePowerController!.clear();
    _priceController!.clear();
    setState(() {
      image = null;
    });
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    TheCar newCar = TheCar(
      id: '',
      name: _carNameController!.text,
      description: _carDescriptionController!.text,
      numberPlate: _carNumberController!.text,
      horsePower: int.parse(
        _horsePowerController!.text,
      ),
      mileage: int.parse(_mileageController!.text),
      rating: '',
      price: int.parse(
        _priceController!.text,
      ),
      image: '',
    );
    if (image == null) {
      await car!
          .updateCarWithoutImage(
        newCar,
      )
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }).catchError((e) {
        setState(() {
          _isLoading = false;
        });
        FlutterToasts.showErrorToast(context, e.toString());
      });
    } else {
      await car!
          .updateCarWithImage(
        newCar,
        image!,
      )
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      }).catchError((e) {
        if (e.toString() == 'XMLHttpRequest error.') {
          FlutterToasts.showErrorToast(
              context, 'Image size should be less than 2mb.');
          return;
        }
        FlutterToasts.showErrorToast(context, e.toString());
        setState(() {
          _isLoading = false;
        });
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  File? _selectedImage;
  String? _imageName;
  Uint8List webImage = Uint8List(8);

  Future<void> _pickImage() async {
    ImagePicker picker = ImagePicker();
    image = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (!kIsWeb) {
      if (image == null) {
        return;
      }
      _imageName = path.basename(image!.path);

      setState(() {
        _selectedImage = File(image!.path);
      });
    } else {
      var f = await image!.readAsBytes();
      webImage = f;
      setState(() {
        _selectedImage = File('a');
      });
    }
  }

  @override
  void didChangeDependencies() {
    car = Provider.of<TheCar>(context);
    _carNameController = TextEditingController(text: car!.name);
    _carDescriptionController = TextEditingController(text: car!.description);
    _carNumberController = TextEditingController(text: car!.numberPlate);
    _mileageController = TextEditingController(text: car!.mileage.toString());
    _horsePowerController =
        TextEditingController(text: car!.horsePower.toString());
    _priceController = TextEditingController(text: car!.price.toString());
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveBuilder(
        builder: (context, si) {
          if (si.deviceScreenType == DeviceScreenType.desktop) {
            return Row(
              children: [
                const ShowWidget(),
                ChangeNotifierProvider<TheCar>.value(
                  value: car!,
                  child: updateCarDetailsForm(),
                ),
              ],
            );
          } else if (si.deviceScreenType == DeviceScreenType.tablet) {
            return Row(
              children: [
                const ShowWidget(),
                ChangeNotifierProvider<TheCar>.value(
                  value: car!,
                  child: updateCarDetailsForm(),
                ),
              ],
            );
          } else {
            return ChangeNotifierProvider<TheCar>.value(
              value: car!,
              child: updateCarDetailsForm(),
            );
          }
        },
      ),
    );
  }

  Flexible updateCarDetailsForm() {
    final car = Provider.of<TheCar>(context);
    return Flexible(
      child: ChangeNotifierProvider<TheCar>.value(
        value: car,
        child: signInWidget(false),
      ),
    );
  }

  Widget signInForm1() {
    final car = Provider.of<TheCar>(context);
    return Flexible(
      child: ChangeNotifierProvider<TheCar>.value(
        value: car,
        child: signInWidget(true),
      ),
    );
  }

  Padding signInWidget(bool isMobileView) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 15,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                    'Hey,',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.raleway().copyWith(
                      fontSize: 35,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    ' Admin',
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
                'Hey, Update your details',
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
                  'Name',
                  style: GoogleFonts.raleway().copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              GeneralTextFormField(
                hasPrefixIcon: true,
                hasSuffixIcon: false,
                controller: _carNameController!,
                label: 'Name',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the name of the car.';
                  }

                  return null;
                },
                textInputType: TextInputType.emailAddress,
                iconData: Icons.car_rental,
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
                  'Description',
                  style: GoogleFonts.raleway().copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              GeneralTextFormField(
                hasPrefixIcon: true,
                hasSuffixIcon: false,
                controller: _carDescriptionController!,
                label: 'Description',
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter the description of the car.';
                  } else if (value.trim().length < 6) {
                    return 'Please enter at least 6 characters.';
                  }
                  return null;
                },
                textInputType: TextInputType.name,
                iconData: Icons.description,
                autoFocus: false,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 3,
                            bottom: 5,
                          ),
                          child: Text(
                            'Horse Power',
                            style: GoogleFonts.raleway().copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        GeneralTextFormField(
                          hasPrefixIcon: true,
                          hasSuffixIcon: false,
                          controller: _horsePowerController!,
                          label: 'Horse Power',
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Please enter the horse power of the car.';
                            }
                            if (int.tryParse(value) == null) {
                              return 'please provide a valid Number';
                            }
                            return null;
                          },
                          textInputType: TextInputType.number,
                          iconData: Icons.power_rounded,
                          autoFocus: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 3,
                            bottom: 5,
                          ),
                          child: Text(
                            'Mileage',
                            style: GoogleFonts.raleway().copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        GeneralTextFormField(
                          hasPrefixIcon: true,
                          hasSuffixIcon: false,
                          controller: _mileageController!,
                          label: 'Mileage',
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'Please enter the mileage of the car.';
                            }
                            if (int.tryParse(value) == null) {
                              return 'please provide a valid Number';
                            }
                            return null;
                          },
                          textInputType: TextInputType.number,
                          iconData: Icons.power_settings_new,
                          autoFocus: false,
                        ),
                      ],
                    ),
                  ),
                ],
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
                  'Price per hour',
                  style: GoogleFonts.raleway().copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              GeneralTextFormField(
                hasPrefixIcon: true,
                hasSuffixIcon: false,
                controller: _priceController!,
                label: 'Price per hour',
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return 'Please enter the rent price of the car.';
                  }
                  if (int.tryParse(value) == null) {
                    return 'please provide a valid Number';
                  }
                  return null;
                },
                textInputType: TextInputType.name,
                iconData: Icons.price_change,
                autoFocus: false,
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 1,
                  right: 1,
                ),
                child: _selectedImage != null
                    ? kIsWeb
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                            child: SizedBox(
                              height: !isMobileView ? 300 : 200,
                              width: !isMobileView ? 300 : double.infinity,
                              child: Image.memory(
                                webImage,
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                            child: SizedBox(
                              height: !isMobileView ? 300 : 200,
                              width: !isMobileView ? 300 : double.infinity,
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.fill,
                              ),
                            ),
                          )
                    : DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(15),
                        child: InkWell(
                          onTap: () {
                            _pickImage();
                          },
                          child: SizedBox(
                            height: !isMobileView ? 300 : 200,
                            width: !isMobileView ? 300 : double.infinity,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Update Image',
                                    style: GoogleFonts.raleway().copyWith(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (_selectedImage != null || image != null)
                Row(
                  children: [
                    SizedBox(
                      height: 38,
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.purple,
                          ),
                        ),
                        onPressed: () {
                          _pickImage();
                        },
                        icon: const Icon(Icons.edit),
                        label: Text(
                          'Edit Image',
                          style: GoogleFonts.raleway().copyWith(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      height: 38,
                      child: ElevatedButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.redAccent,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            image = null;
                          });
                        },
                        icon: const Icon(Icons.delete),
                        label: Text(
                          'Delete Image',
                          style: GoogleFonts.raleway().copyWith(),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Material(
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
                                    'Update Car Details',
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
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
