import 'package:avetol/Theme/theme.dart';
import 'package:avetol/core/services/sharedPreferences.dart';
import 'package:avetol/features/auth/signin/presentation/screens/signinScreen.dart';
import 'package:avetol/features/auth/signup/presentation/screens/signupScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final prefs = PrefService();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return OnBoardingSlider(
      hasFloatingButton: false,
      finishButtonText: 'Register',
      onFinish: () {
        prefs.board();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SigninScreen()));
      },
      finishButtonStyle: FinishButtonStyle(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          backgroundColor: Theme.of(context).custom.primaryColor
          // backgroundColor: kDarkBlueColor,
          ),
      skipTextButton: Text(
        AppLocalizations.of(context)!.skip,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Text(
        '',
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailingFunction: () {
        // Navigator.push(
        //   context,
        //   CupertinoPageRoute(
        //     builder: (context) => const LoginPage(),
        //   ),
        // );
      },
      controllerColor: Colors.white,
      totalPage: 3,
      headerBackgroundColor: Colors.black,
      pageBackgroundColor: Colors.black,
      background: [
        Image.asset(
          'images/onboard1.png',
          fit: BoxFit.cover,
          height: height,
          width: width,
        ),
        Image.asset(
          'images/onboard2.png',
          fit: BoxFit.cover,
          height: height * 0.8,
          width: width,
        ),
        Image.asset(
          'images/onboard3.png',
          fit: BoxFit.cover,
          width: width,
          height: height * 0.8,
        ),
      ],
      speed: 1.8,
      pageBodies: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // const SizedBox(
              //   height: 480,
              // ),
              // Text(
              //   'On your way...',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //   //  color: kDarkBlueColor,
              //     fontSize: 24.0,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // const Text(
              //   'to find the perfect looking Onboarding for your app?',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     color: Colors.black26,
              //     fontSize: 18.0,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // const SizedBox(
              //   height: 480,
              // ),
              // Text(
              //   'You’ve reached your destination.',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //  //   color: kDarkBlueColor,
              //     fontSize: 24.0,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // const Text(
              //   'Sliding with animation',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     color: Colors.black26,
              //     fontSize: 18.0,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // const SizedBox(
              //   height: 480,
              // ),
              // Text(
              //   'Start now!',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //    // color: kDarkBlueColor,
              //     fontSize: 24.0,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              // const Text(
              //   'Where everything is possible and customize your onboarding.',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //     color: Colors.black26,
              //     fontSize: 18.0,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),

              InkWell(
                onTap: () {
                  prefs.board();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()));
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).custom.primaryColor),
                  height: MediaQuery.sizeOf(context).height * 0.06,
                  width: MediaQuery.sizeOf(context).width * 0.7,
                  child: Center(
                      child: Text(
                    "Get Started",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              InkWell(
                  onTap: () {
                    prefs.board();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SigninScreen()));
                  },
                  child: Center(
                      child: Text(
                    "Log in",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ))),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.05,
              )
            ],
          ),
        ),
      ],
    );
  }
}
