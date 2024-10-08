import 'package:avetol/core/constants.dart';
import 'package:avetol/core/services/sharedPreferences.dart';
import 'package:avetol/features/auth/signup/data/models/signup.dart';
import 'package:avetol/features/auth/signup/presentation/blocs/signup_bloc.dart';
import 'package:avetol/features/auth/signup/presentation/blocs/signup_event.dart';
import 'package:avetol/features/auth/signup/presentation/blocs/signup_state.dart';
import 'package:avetol/features/auth/signin/presentation/screens/signinScreen.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/dateFormField.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/emailFormField.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/emailValidation.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/errorText.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/passwordFormField.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/phoneTextFormField.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/textFormField.dart';
import 'package:avetol/features/common/errorFlushbar.dart';
import 'package:avetol/features/guidelines/presentation/screens/privacyPolicyScreen.dart';
import 'package:avetol/features/guidelines/presentation/screens/termsAndConditionsScreen.dart';
import 'package:avetol/features/home/presentation/screens/subscriptionScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final prefs = PrefService();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  DateTime firstDate = DateTime.now().subtract(Duration(days: 130 * 365));
  DateTime initialDate = DateTime.now().subtract(Duration(days: 21 * 365));
  DateTime lastDate = DateTime.now().subtract(Duration(days: 21 * 365));

  final signupFormKey = GlobalKey<FormState>();

  bool isFirstNameEmpty = false;
  bool isLastNameEmpty = false;
  bool isPwdEmpty = false;
  bool isConfirmPwdEmpty = false;
  bool isDobEmpty = false;
  bool isPhoneEmpty = false;
  bool isPwdDifferent = false;
  bool isPhoneInvalid = false;
  bool isEmailInvalid = false;
  bool isPwdInvalid = false;

  bool isLoading = false;

  String _selectedCountryCode = '251';

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    dobController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignupBloc, SignupState>(
        listener: (context, state) {
          print(state);
          if (state is SignupLoadingState) {
            isLoading = true;
          } else if (state is SignupSuccessfulState) {
            isLoading = false;
            prefs.login(passwordController.text);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Account Created Successfully!"),
                backgroundColor: Colors.green, // Adjust color as needed
              ),
            );
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const SubscriptionScreen()));
          } else if (state is SignupFailureState) {
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
        padding: width < 400
            ? const EdgeInsets.only(left: 30, right: 30)
            : const EdgeInsets.only(left: 40, right: 40),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
              const Color(0xFF091451),
              const Color(0xFF091451).withOpacity(0)
            ])),
        child: Form(
          key: signupFormKey,
          child: Column(
            children: [
              SizedBox(
                height: height < 720 ? height * 0.07 : height * 0.1,
              ),
              SizedBox(
                width: width,
                child: Text(
                  "Create Account",
                  style: TextStyle(
                      color: primaryColor,
                      fontSize: fontSize33,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: height < 720 ? 30 : 60,
              ),
              textFormField(
                  controller: firstNameController,
                  hintText: "First Name",
                  onInteraction: () {
                    setState(() {
                      isFirstNameEmpty = false;
                    });
                  }),
              isFirstNameEmpty
                  ? errorText(text: 'Please enter your First Name')
                  : const SizedBox.shrink(),
              SizedBox(
                height: height < 720 ? 5 : 25,
              ),
              textFormField(
                  controller: lastNameController,
                  hintText: "Last Name",
                  onInteraction: () {
                    setState(() {
                      isLastNameEmpty = false;
                    });
                  }),
              isLastNameEmpty
                  ? errorText(text: 'Please enter your Last Name')
                  : const SizedBox.shrink(),
              SizedBox(
                height: height < 720 ? 5 : 25,
              ),
              emailFormField(
                  controller: emailController,
                  hintText: "Email",
                  onInteraction: () {
                    setState(() {
                      isEmailInvalid = false;
                    });
                  }),
              isEmailInvalid
                  ? errorText(text: 'Please enter a valid Email')
                  : const SizedBox.shrink(),
              SizedBox(
                height: height < 720 ? 5 : 25,
              ),
              dateFormField(
                  controller: dobController,
                  hintText: "Date of Birth",
                  onPressed: () {
                    displayDatePicker(context);
                  },
                  onInteraction: () {
                    setState(() {
                      isDobEmpty = false;
                    });
                  }),
              isDobEmpty
                  ? errorText(text: "Please enter your Date of Birth")
                  : const SizedBox.shrink(),
              SizedBox(
                height: height < 720 ? 65 : 100,
              ),
              phoneTextFormField(
                controller: phoneController,
                autofocus: false,
                hintText: "Your Number",
                onInteraction: () {
                  setState(() {
                    isPhoneEmpty = false;
                    isPhoneInvalid = false;
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
              isPhoneInvalid
                  ? errorText(text: 'Please start your phone with 9')
                  : SizedBox.shrink(),
              SizedBox(
                height: height < 720 ? 0 : 25,
              ),
              passwordFormField(
                  controller: passwordController,
                  labelText: "Password",
                  onInteraction: () {
                    setState(() {
                      isPwdEmpty = false;
                      isPwdDifferent = false;
                      isPwdInvalid = false;
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
              SizedBox(
                height: height < 720 ? 5 : 25,
              ),
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
                  ? errorText(text: 'Please confirm you password')
                  : const SizedBox.shrink(),
              isPwdDifferent
                  ? errorText(text: "Your password doesn't match")
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 60,
              ),
              submitButton(
                  text: isLoading ? 'Creating account' : 'Create Account',
                  disable: isLoading,
                  onInteraction: () {
                    if (signupFormKey.currentState!.validate()) {
                      if (firstNameController.text.isEmpty) {
                        return setState(() {
                          isFirstNameEmpty = true;
                        });
                      }
                      if (lastNameController.text.isEmpty) {
                        return setState(() {
                          isLastNameEmpty = true;
                        });
                      }
                      if (dobController.text.isEmpty) {
                        return setState(() {
                          isDobEmpty = true;
                        });
                      }
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
                      if (phoneController.text.isEmpty) {
                        return setState(() {
                          isPhoneEmpty = true;
                        });
                      }
                      String phoneNumber = phoneController.text.trim();
                      if (phoneNumber.startsWith('0')) {
                        return setState(() {
                          isPhoneInvalid = true;
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

                      if (emailController.text.isNotEmpty) {
                        if (!isEmailValid(emailController.text)) {
                          return setState(() {
                            isEmailInvalid = true;
                          });
                        }
                      }

                      // if (!RegExp(r'^[0-9]{9}$')
                      //     .hasMatch(phoneController.text)) {
                      //   return setState(() {
                      //     isPhoneInvalid = true;
                      //   });
                      // }
                      print("Email:" + emailController.text);
                      print("password:" + passwordController.text);
                      print("Phone:" +
                          "${_selectedCountryCode}" +
                          "${phoneController.text}");
                      print("first_name:" + firstNameController.text);
                      print("last_name:" + lastNameController.text);
                      print("last_name:" + dobController.text);

                      final signup = BlocProvider.of<SignupBloc>(context);
                      signup.add(PostSignupEvent(Signup(
                        email: emailController.text,
                        password: passwordController.text,
                        phone: "${_selectedCountryCode}" +
                            "${phoneController.text}",
                        first_name: firstNameController.text,
                        last_name: lastNameController.text,
                        dob: dobController.text,
                      )));
                    }
                  }),
              SizedBox(
                height: height < 720 ? 20 : 40,
              ),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: TextStyle(
                          color: hintColor,
                          fontSize: fontSize10,
                          fontWeight: FontWeight.w400),
                      children: [
                        const TextSpan(text: "By logging in you agree to our "),
                        TextSpan(
                            text: "Terms & Conditions",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        TermsAndConditionsScreen()));
                              },
                            style: const TextStyle(color: whiteColor)),
                        const TextSpan(text: " and \n"),
                        TextSpan(
                            text: "Privacy Policy",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        PrivacyPolicyScreen()));
                              },
                            style: const TextStyle(color: whiteColor)),
                      ])),
              SizedBox(
                height: height < 720 ? 25 : 45,
              ),
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: TextStyle(
                          color: hintColor,
                          fontSize: fontSize14,
                          fontWeight: FontWeight.w400),
                      children: [
                        const TextSpan(text: "Already have an account? "),
                        TextSpan(
                            text: "Sign in",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const SigninScreen()));
                              },
                            style: const TextStyle(color: signinTextColor)),
                      ])),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future displayDatePicker(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: whiteColor,
              onSurface: primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final pickedDate = date.toLocal().toString().split(" ")[0];
      List<String> splittedDate = pickedDate.split("-");
      String dateFormat =
          "${splittedDate[0]}-${splittedDate[1]}-${splittedDate[2]}";
      setState(() {
        dobController.text = dateFormat;
      });
    }
  }
}
