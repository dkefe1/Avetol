import 'package:avetol/core/constants.dart';
import 'package:avetol/features/auth/signin/data/models/forgotPasswordRequest.dart';
import 'package:avetol/features/auth/signin/data/models/otp.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_bloc.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_event.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_state.dart';
import 'package:avetol/features/auth/signin/presentation/screens/resetPassword.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/errorText.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:avetol/features/common/errorFlushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  const OTPScreen({required this.phone, super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> otpControllers =
      List.generate(6, (_) => TextEditingController());

  final verifyOtpFormKey = GlobalKey<FormState>();

  bool otpEmpty = false;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: whiteColor.withOpacity(0.8),
            )),
      ),
      extendBodyBehindAppBar: true,
      body: BlocConsumer<SigninBloc, SigninState>(
        listener: (context, state) {
          print(state);
          if (state is OtpLoadingState) {
            isLoading = true;
          } else if (state is OtpSuccessfulState) {
            isLoading = false;
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => ResetPasswordScreen(
                      phone: widget.phone,
                    )));
          } else if (state is OtpFailureState) {
            isLoading = false;
            errorFlushbar(context: context, message: state.error);
          }
        },
        builder: (context, state) {
          return buildInitialInput();
        },
      ),
    );
  }

  Widget buildInitialInput() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.only(left: 40, right: 40),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              const Color(0xFF091451).withOpacity(0),
              const Color(0xFF091451),
            ])),
        child: Form(
          key: verifyOtpFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.14,
              ),
              Text(
                "Confirm Account",
                style: TextStyle(
                    color: primaryColor,
                    fontSize: fontSize30,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "A registration confirmation code will be sent to your phone number",
                style: TextStyle(
                    color: whiteColor.withOpacity(0.8),
                    fontSize: fontSize12,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: width < 390 ? 45 : 50,
                    height: width < 390 ? 40 : 45,
                    child: Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: TextField(
                        autofocus: true,
                        controller: otpControllers[index],
                        focusNode: _focusNodes[index],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        ],
                        onChanged: (value) {
                          _onOtpChanged(index, value);
                          otpEmpty = false;
                        },
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: fontSize16,
                            fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          counterText: '',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: whiteColor)),
                          fillColor: otpInputFillColor.withOpacity(0.5),
                          filled: true,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              otpEmpty
                  ? errorText(text: "Please Enter the OTP sent to your Phone")
                  : const SizedBox(),
              const SizedBox(
                height: 34,
              ),
              submitButton(
                  text: isLoading ? "Please wait..." : "Confirm",
                  disable: isLoading,
                  onInteraction: () {
                    if (verifyOtpFormKey.currentState!.validate()) {
                      bool anyEmpty = otpControllers
                          .any((controller) => controller.text.isEmpty);
                      if (anyEmpty) {
                        setState(() {
                          otpEmpty = true;
                        });
                      }
                      String otpCode = otpControllers
                          .map((controller) => controller.text)
                          .join();
                      final otpVerification =
                          BlocProvider.of<SigninBloc>(context);
                      otpVerification.add(PostOTPEvent(
                          OTP(phone: widget.phone, code: otpCode)));
                    }
                  }),
              SizedBox(
                height: height > 700 ? 22 : 15,
              ),
              SizedBox(
                width: width,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        BlocProvider.of<SigninBloc>(context).add(
                            PostForgotPasswordEvent(
                                ForgotPassword(phone: widget.phone)));
                      },
                      child: Text(
                        'Resend Code',
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: fontSize12,
                            fontWeight: FontWeight.w400),
                      )),
                ),
              ),
              SizedBox(
                height: height > 700 ? height * 0.4 : height * 0.28,
              ),
              RichText(
                  text: TextSpan(
                      style: TextStyle(
                          fontSize: fontSize10, fontWeight: FontWeight.w400),
                      children: [
                    TextSpan(
                        text:
                            "By clicking “ CONFIRM “  you accepted our  Terms & Conditions of the ",
                        style: TextStyle(color: whiteColor)),
                    TextSpan(
                        recognizer: TapGestureRecognizer()..onTap = () {},
                        text: "User Agreement",
                        style: TextStyle(color: signinTextColor))
                  ])),
              SizedBox(
                height: height * 0.05,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < otpControllers.length - 1) {
        _focusNodes[index].unfocus();
        otpControllers[index].text = value;
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        _focusNodes[index].unfocus();
        otpControllers[index].text = value;
      }
    } else {
      otpControllers[index].clear();

      if (index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
      }
    }
  }
}
