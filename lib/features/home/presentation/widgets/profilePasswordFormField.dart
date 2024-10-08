import 'package:avetol/core/constants.dart';
import 'package:flutter/material.dart';

class profilePasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final VoidCallback onInteraction;
  const profilePasswordFormField(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.onInteraction});

  @override
  State<profilePasswordFormField> createState() =>
      _profilePasswordFormFieldState();
}

class _profilePasswordFormFieldState extends State<profilePasswordFormField> {
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: TextFormField(
        controller: widget.controller,
        onChanged: (value) {
          widget.onInteraction();
        },
        obscureText: hidePassword,
        style: const TextStyle(color: whiteColor),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 25, horizontal: 30),
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
              icon: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  hidePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: whiteColor.withOpacity(0.8),
                ),
              )),
          labelText: widget.labelText,
          labelStyle: TextStyle(
              color: whiteColor,
              fontSize: fontSize18,
              fontWeight: FontWeight.w400),
          // hintText: widget.hintText,
          // hintStyle: TextStyle(
          //     color: whiteColor.withOpacity(0.8),
          //     fontSize: fontSize18,
          //     fontWeight: FontWeight.w400),
          filled: true,
          fillColor: otpInputFillColor,
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
