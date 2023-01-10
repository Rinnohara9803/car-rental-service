import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utilities/constants.dart';

class GeneralTextFormField extends StatefulWidget {
  final bool hasSuffixIcon;
  final bool hasPrefixIcon;
  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final TextInputType textInputType;
  final IconData iconData;
  final bool autoFocus;
  const GeneralTextFormField({
    Key? key,
    required this.hasPrefixIcon,
    required this.hasSuffixIcon,
    required this.controller,
    required this.label,
    required this.validator,
    required this.textInputType,
    required this.iconData,
    required this.autoFocus,
  }) : super(key: key);

  @override
  State<GeneralTextFormField> createState() => _GeneralTextFormFieldState();
}

class _GeneralTextFormFieldState extends State<GeneralTextFormField> {
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: widget.autoFocus,
      obscureText: widget.hasSuffixIcon ? isVisible : false,
      keyboardType: widget.textInputType,
      validator: widget.validator,
      controller: widget.controller,
      decoration: InputDecoration(
        // isDense: true,
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
        errorBorder: errorBorder,
        focusedBorder: focusedBorder,
        focusedErrorBorder: focusedErrorBorder,
        label: Text(
          widget.label,
          style: GoogleFonts.raleway(),
        ),
        prefixIcon: widget.hasPrefixIcon
            ? Icon(
                widget.iconData,
              )
            : null,
        suffixIcon: widget.hasSuffixIcon
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
                icon: isVisible
                    ? const Icon(Icons.visibility)
                    : const Icon(Icons.visibility_off),
              )
            : null,
      ),
      onSaved: (text) {
        widget.controller.text = text!;
      },
    );
  }
}
