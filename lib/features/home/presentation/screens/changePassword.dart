import 'package:avetol/core/constants.dart';
import 'package:avetol/features/auth/signin/data/models/changePassword.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_bloc.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_event.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_state.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/errorText.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:avetol/features/common/errorFlushbar.dart';
import 'package:avetol/features/home/presentation/widgets/profilePasswordFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final changePwdFormKey = GlobalKey<FormState>();
  TextEditingController currentPwdController = TextEditingController();
  TextEditingController newPwdController = TextEditingController();
  TextEditingController confirmNewPwdController = TextEditingController();

  bool isCurrentPwdEmpty = false;
  bool isNewPwdInvalid = false;
  bool isNewPwdEmpty = false;
  bool isConfirmNewPwdEmpty = false;
  bool isPwdDifferent = false;

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    currentPwdController.dispose();
    newPwdController.dispose();
    confirmNewPwdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * 0.08,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: whiteColor.withOpacity(0.8),
            )),
        // title: Text(
        //   "Change password",
        //   style: TextStyle(
        //       color: whiteColor,
        //       fontSize: fontSize20,
        //       fontWeight: FontWeight.w900),
        // ),
      ),
      body: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
          print(state);
          if (state is ChangePasswordLoadingState) {
            isLoading = true;
            Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (state is ChangePasswordSuccessfulState) {
            isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Password changed Successfully!"),
                backgroundColor: Colors.green, // Adjust color as needed
              ),
            );
            Navigator.of(context).pop();
          } else if (state is ChangePasswordFailureState) {
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
    double height = MediaQuery.of(context).size.height;
    return Form(
      key: changePwdFormKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                'Change Password',
                style: TextStyle(
                    color: whiteColor,
                    fontSize: fontSize20,
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: height < 720 ? 15 : 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  profilePasswordFormField(
                      controller: currentPwdController,
                      labelText: "Current Password",
                      onInteraction: () {
                        setState(() {
                          isCurrentPwdEmpty = false;
                        });
                      }),
                  isCurrentPwdEmpty
                      ? errorText(text: 'Please enter your current password')
                      : SizedBox.shrink(),
                  profilePasswordFormField(
                      controller: newPwdController,
                      labelText: "New Password",
                      onInteraction: () {
                        setState(() {
                          isNewPwdEmpty = false;
                          isNewPwdInvalid = false;
                        });
                      }),
                  isNewPwdEmpty
                      ? errorText(text: 'Please enter your new password')
                      : SizedBox.shrink(),
                  isPwdDifferent
                      ? errorText(text: "Your password doesn't match")
                      : SizedBox.shrink(),
                  isNewPwdInvalid
                      ? errorText(
                          text: 'Your password must be at least 6 characters')
                      : SizedBox.shrink(),
                  profilePasswordFormField(
                      controller: confirmNewPwdController,
                      labelText: "Confirm Password",
                      onInteraction: () {
                        setState(() {
                          isConfirmNewPwdEmpty = false;
                        });
                      }),
                  isConfirmNewPwdEmpty
                      ? errorText(text: 'Please confirm you password')
                      : SizedBox.shrink(),
                  isPwdDifferent
                      ? errorText(text: "Your Password doesn't match")
                      : SizedBox.shrink(),
                  submitButton(
                      text: "Change Password",
                      disable: isLoading,
                      onInteraction: () {
                        if (changePwdFormKey.currentState!.validate()) {
                          if (currentPwdController.text.isEmpty) {
                            return setState(() {
                              isCurrentPwdEmpty = true;
                            });
                          }
                          if (newPwdController.text.isEmpty) {
                            return setState(() {
                              isNewPwdEmpty = true;
                            });
                          }
                          if (confirmNewPwdController.text.isEmpty) {
                            return setState(() {
                              isConfirmNewPwdEmpty = true;
                            });
                          }
                          if (newPwdController.text.length < 6) {
                            return setState(() {
                              isNewPwdInvalid = true;
                            });
                          }
                          if (newPwdController.text !=
                              confirmNewPwdController.text) {
                            return setState(() {
                              isPwdDifferent = true;
                            });
                          }
                          final changePwd =
                              BlocProvider.of<ChangePasswordBloc>(context);

                          changePwd.add(PostChangePasswordEvent(ChangePassword(
                              password: currentPwdController.text,
                              new_password: newPwdController.text,
                              new_password_confirmation:
                                  confirmNewPwdController.text)));
                        }
                      }),
                  const SizedBox(
                    height: 40,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
