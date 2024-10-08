import 'package:avetol/core/constants.dart';
import 'package:avetol/core/services/sharedPreferences.dart';
import 'package:avetol/features/auth/signin/data/models/signin.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_bloc.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_event.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_state.dart';
import 'package:avetol/features/auth/signin/presentation/screens/forgotPasswordScreen.dart';
import 'package:avetol/features/auth/signup/presentation/screens/signupScreen.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/emailValidation.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/errorText.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/passwordFormField.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/phoneTextFormField.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/textFormField.dart';
import 'package:avetol/features/common/errorFlushbar.dart';
import 'package:avetol/features/home/presentation/screens/indexScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final prefs = PrefService();
  bool isChecked = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final signinFormKey = GlobalKey<FormState>();

  bool emailLogin = false;
  bool phoneLogin = true;
  bool isEmailEmpty = false;
  bool isPwdEmpty = false;
  bool isEmailInvalid = false;
  bool isPhoneInvalid = false;

  bool isLoading = false;

  String _selectedCountryCode = '251';

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadRememberMePreference();
  }

  void _loadRememberMePreference() async {
    print(await prefs.getPassword());
    bool? rememberMe = await prefs.getRememberMe();
    if (rememberMe != null) {
      setState(() {
        isChecked = rememberMe;
      });
      if (rememberMe) {
        phoneController.text = await prefs.getPhone();
        emailController.text = await prefs.getEmail();
        passwordController.text = await prefs.getPassword();
      }
    }
  }

  void _saveRememberMePreference(bool value) {
    prefs.setRememberMe(value);
    if (!value) {
      // Clear stored credentials if remember me is unchecked
      prefs.saveCredential('', '', '');
    }
  }

  void _saveLoginCredentials(String phone, String email, String password) {
    prefs.saveCredential(phone, email, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SigninBloc, SigninState>(
        listener: (context, state) {
          print(state);
          if (state is SigninLoadingState) {
            isLoading = true;
          } else if (state is SigninSuccessfulState) {
            isLoading = false;
            prefs.login(passwordController.text);
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const IndexScreen(
                      pageIndex: 0,
                    )));
          } else if (state is SigninFailureState) {
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
        padding: width < 400
            ? const EdgeInsets.only(left: 30, right: 30)
            : const EdgeInsets.only(left: 40, right: 40),
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
                height: height < 720
                    ? height < 650
                        ? height * 0.08
                        : height * 0.13
                    : height * 0.17,
              ),
              Center(
                child: Image.asset(
                  "images/logoBlue.png",
                  height: height < 720 ? 85 : 98,
                  width: height < 720 ? 160 : 185,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: height < 720
                    ? height < 650
                        ? 20
                        : 35
                    : 80,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        phoneLogin = !phoneLogin;
                        emailLogin = !emailLogin;
                      });
                    },
                    child: Text(
                      phoneLogin ? "Login with Email" : "Login with Phone",
                      style:
                          TextStyle(color: primaryColor, fontSize: fontSize13),
                    )),
              ),
              phoneLogin
                  ? phoneTextFormField(
                      controller: phoneController,
                      autofocus: true,
                      hintText: "Your Phone Number",
                      onInteraction: () {
                        setState(() {
                          isPhoneInvalid = false;
                        });
                      },
                      onCountryCodeChanged: (countryCode) {
                        setState(() {
                          _selectedCountryCode = countryCode;
                        });
                      },
                    )
                  : SizedBox.shrink(),
              isPhoneInvalid
                  ? errorText(text: 'Please start your phone with 9')
                  : SizedBox.shrink(),
              emailLogin
                  ? textFormField(
                      controller: emailController,
                      hintText: "Email",
                      onInteraction: () {})
                  : SizedBox.shrink(),
              emailLogin && isEmailEmpty
                  ? errorText(text: 'Please enter your Email')
                  : const SizedBox.shrink(),
              emailLogin && isEmailInvalid
                  ? errorText(text: 'Please enter a valid Email')
                  : const SizedBox.shrink(),
              SizedBox(
                height: height < 720 ? 15 : 40,
              ),
              passwordFormField(
                  controller: passwordController,
                  labelText: "Password",
                  onInteraction: () {}),
              isPwdEmpty
                  ? errorText(text: 'Please enter a Password')
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            if (value != null) {
                              setState(() {
                                isChecked = value;
                              });
                              _saveRememberMePreference(value);
                            }
                          }),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Remember me",
                        style: TextStyle(
                            color: hintColor,
                            fontSize: fontSize12,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ForgotPasswordScreen()));
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: hintColor,
                          fontSize: fontSize12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 34,
              ),
              submitButton(
                  text: isLoading ? "Signing In..." : "Sign in",
                  disable: isLoading,
                  onInteraction: () {
                    if (signinFormKey.currentState!.validate()) {
                      if (emailLogin) {
                        if (emailController.text.isEmpty) {
                          return setState(() {
                            isEmailEmpty = true;
                          });
                        } else {
                          setState(() {
                            isEmailEmpty = false;
                          });
                        }
                        if (!isEmailValid(emailController.text)) {
                          return setState(() {
                            isEmailInvalid = true;
                            print(isEmailInvalid);
                          });
                        } else {
                          setState(() {
                            isEmailInvalid = false;
                          });
                        }
                      }
                      if (phoneLogin) {
                        String phoneNumber = phoneController.text.trim();
                        if (phoneNumber.startsWith('0')) {
                          return setState(() {
                            isPhoneInvalid = true;
                          });
                        }
                      }
                      if (passwordController.text.isEmpty) {
                        return setState(() {
                          isPwdEmpty = true;
                        });
                      }
                      print(
                          "email:  ${emailLogin ? emailController.text : ""}");

                      print(
                          "phone: ${phoneLogin ? "${_selectedCountryCode}" + "${phoneController.text}" : ""}");
                      print('password: ' + passwordController.text);
                      if (isChecked) {
                        _saveLoginCredentials(
                            phoneLogin ? phoneController.text : '',
                            emailLogin ? emailController.text : '',
                            passwordController.text);
                      }

                      final signin = BlocProvider.of<SigninBloc>(context);
                      signin.add(PostSigninEvent(Signin(
                          identifier: phoneLogin
                              ? "${_selectedCountryCode}" +
                                  "${phoneController.text}"
                              : emailController.text,
                          password: passwordController.text)));
                    }
                  }),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Don't have an account?",
                style: TextStyle(
                    color: hintColor,
                    fontSize: fontSize14,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 7,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignUpScreen()));
                  },
                  style: ButtonStyle(
                      side: MaterialStateBorderSide.resolveWith((states) =>
                          const BorderSide(color: Color(0xFF777777), width: 1)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 20),
                      )),
                  child: Text(
                    "Create Account",
                    style: TextStyle(
                        color: createAccBtnColor,
                        fontSize: fontSize14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ),
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
