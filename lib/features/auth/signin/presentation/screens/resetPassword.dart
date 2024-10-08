import 'package:avetol/features/auth/signin/data/models/changeForgotPassword.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_bloc.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_event.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_state.dart';
import 'package:avetol/features/auth/signin/presentation/screens/signinScreen.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/errorText.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/passwordFormField.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:avetol/features/common/errorFlushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String phone;

  const ResetPasswordScreen({required this.phone, super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool isChecked = false;

  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final signinFormKey = GlobalKey<FormState>();

  bool isPwdEmpty = false;
  bool isConfirmPwdEmpty = false;
  bool isPwdInvalid = false;
  bool isPwdDifferent = false;

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SigninBloc, SigninState>(
        listener: (context, state) {
          print(state);
          if (state is ChangeForgotPasswordLoadingState) {
            isLoading = true;
          } else if (state is ChangeForgotPasswordSuccessfulState) {
            isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Password Reset Successful!"),
                backgroundColor: Colors.green, // Adjust color as needed
              ),
            );
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SigninScreen()));
          } else if (state is ChangeForgotPasswordFailureState) {
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
          key: signinFormKey,
          child: Column(
            children: [
              SizedBox(
                height: height * 0.17,
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
                height: 80,
              ),
              passwordFormField(
                  controller: passwordController,
                  labelText: "Password",
                  onInteraction: () {
                    setState(() {
                      isPwdEmpty = false;
                      isPwdInvalid = false;
                      isPwdDifferent = false;
                    });
                  }),
              isPwdEmpty
                  ? errorText(text: 'Please enter a Password')
                  : const SizedBox.shrink(),
              isPwdInvalid
                  ? errorText(text: 'Password must be at least 6 characters')
                  : const SizedBox.shrink(),
              isPwdDifferent
                  ? errorText(text: "Your password doesn't match")
                  : const SizedBox.shrink(),
              passwordFormField(
                  controller: confirmPasswordController,
                  labelText: "Confirm Password",
                  onInteraction: () {
                    setState(() {
                      isConfirmPwdEmpty = false;
                      isPwdDifferent = false;
                    });
                  }),
              isConfirmPwdEmpty
                  ? errorText(text: 'Please confirm your Password')
                  : const SizedBox.shrink(),
              isPwdDifferent
                  ? errorText(text: "Your password doesn't match")
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 60,
              ),
              const SizedBox(
                height: 34,
              ),
              submitButton(
                  text: isLoading ? "Making Changes..." : "Change Password",
                  disable: isLoading,
                  onInteraction: () {
                    if (signinFormKey.currentState!.validate()) {
                      if (passwordController.text.isEmpty) {
                        return setState(() {
                          isPwdEmpty = true;
                        });
                      }
                      if (confirmPasswordController.text.isEmpty) {
                        return setState(() {
                          isConfirmPwdEmpty = true;
                        });
                      }
                      if (passwordController.text.length < 6) {
                        return setState(() {
                          isPwdInvalid = true;
                        });
                      }
                      if (passwordController.text !=
                          confirmPasswordController.text) {
                        return setState(() {
                          isPwdDifferent = true;
                        });
                      }

                      final changePassword =
                          BlocProvider.of<SigninBloc>(context);
                      changePassword.add(PostChangeForgotPasswordEvent(
                          ChangeForgotPassword(
                              phone: widget.phone,
                              password: passwordController.text,
                              password_confirmation:
                                  confirmPasswordController.text)));
                    }
                  }),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}
