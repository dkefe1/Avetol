import 'package:avetol/core/constants.dart';
import 'package:avetol/features/auth/signin/data/models/forgotPasswordRequest.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_bloc.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_event.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_state.dart';
import 'package:avetol/features/auth/signin/presentation/screens/OTPScreen.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/errorText.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/phoneTextFormField.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:avetol/features/common/errorFlushbar.dart';
import 'package:avetol/features/common/successFlushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool isChecked = false;

  TextEditingController phoneController = TextEditingController();

  final forgotPwdFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isPhoneEmpty = false;

  String _selectedCountryCode = '251';

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
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
          if (state is ForgotPasswordLoadingState) {
            isLoading = true;
          } else if (state is ForgotPasswordSuccessfulState) {
            isLoading = false;
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => OTPScreen(
                      phone:
                          "${_selectedCountryCode}" + "${phoneController.text}",
                    )));
            successFlushBar(
                context: context, message: "OTP Code sent to your phone");
          } else if (state is ForgotPasswordFailureState) {
            isLoading = false;
            print(state.error);
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
        padding: const EdgeInsets.only(left: 40, right: 40),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              const Color(0xFF091451),
              const Color(0xFF091451).withOpacity(0)
            ])),
        child: Form(
          key: forgotPwdFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.13,
              ),
              Center(
                child: Image.asset(
                  "images/logoBlue.png",
                  height: 98,
                  width: 185,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              phoneTextFormField(
                controller: phoneController,
                autofocus: true,
                hintText: "Your Phone Number",
                onInteraction: () {
                  setState(() {
                    isPhoneEmpty = false;
                  });
                },
                onCountryCodeChanged: (countryCode) {
                  setState(() {
                    _selectedCountryCode = countryCode;
                  });
                },
              ),
              isPhoneEmpty
                  ? errorText(text: 'Please enter your Phone Number')
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 40,
              ),
              const SizedBox(
                height: 34,
              ),
              submitButton(
                  text: isLoading ? "Please wait..." : "Send OTP",
                  disable: isLoading,
                  onInteraction: () {
                    if (forgotPwdFormKey.currentState!.validate()) {
                      if (phoneController.text.isEmpty) {
                        setState(() {
                          isPhoneEmpty = true;
                        });
                      } else {
                        final signin = BlocProvider.of<SigninBloc>(context);
                        signin.add(PostForgotPasswordEvent(ForgotPassword(
                            phone: "${_selectedCountryCode}" +
                                "${phoneController.text}")));
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
