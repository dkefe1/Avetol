import 'package:avetol/core/constants.dart';
import 'package:flutter/material.dart';

class passwordFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final VoidCallback onInteraction;
  const passwordFormField(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.onInteraction});

  @override
  State<passwordFormField> createState() => _passwordFormFieldState();
}

class _passwordFormFieldState extends State<passwordFormField> {
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: (value) {
        widget.onInteraction();
      },
      obscureText: hidePassword,
      style: const TextStyle(color: whiteColor),
      decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
              icon: Icon(
                hidePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: whiteColor,
              )),
          labelText: widget.labelText,
          labelStyle: TextStyle(
              color: hintColor,
              fontSize: fontSize18,
              fontWeight: FontWeight.w400)),
    );
  }
}
