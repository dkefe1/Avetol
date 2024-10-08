import 'package:avetol/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class phoneTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final bool autofocus;
  final String hintText;
  final VoidCallback onInteraction;
  final Function(String) onCountryCodeChanged;
  const phoneTextFormField(
      {required this.controller,
      required this.autofocus,
      required this.hintText,
      required this.onInteraction,
      required this.onCountryCodeChanged,
      super.key});

  @override
  State<phoneTextFormField> createState() => _phoneTextFormFieldState();
}

class _phoneTextFormFieldState extends State<phoneTextFormField> {
  String _selectedCountryCode = '+251';

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      dropdownTextStyle: TextStyle(color: whiteColor),
      autovalidateMode: AutovalidateMode.disabled,
      controller: widget.controller,
      autofocus: widget.autofocus,
      onChanged: (phone) {
        widget.onInteraction();
      },
      onCountryChanged: (phone) {
        setState(() {
          _selectedCountryCode = phone.dialCode;
          widget.onCountryCodeChanged(_selectedCountryCode);
        });
      },
      onSubmitted: (phone) {
        _appendCountryCode();
      },
      initialCountryCode: 'ET',
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        LengthLimitingTextInputFormatter(9)
      ],
      keyboardType: TextInputType.phone,
      style: TextStyle(color: whiteColor, fontSize: fontSize16),
      decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
              color: hintColor,
              fontSize: fontSize18,
              fontWeight: FontWeight.w400)),
    );
  }

  void _appendCountryCode() {
    final currentText = widget.controller.text.trim();
    final newText = '$_selectedCountryCode$currentText';
    widget.controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
