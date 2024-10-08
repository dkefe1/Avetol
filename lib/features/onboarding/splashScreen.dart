import 'package:avetol/core/services/sharedPreferences.dart';
import 'package:avetol/features/auth/signin/presentation/screens/signinScreen.dart';
import 'package:avetol/features/home/presentation/screens/indexScreen.dart';
import 'package:avetol/features/onboarding/onboardingScreen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final prefs = PrefService();

  Future<Object> futureNavigator({required BuildContext context}) async {
    bool boarded = await prefs.getBoarded();
    bool loggedIn = await prefs.readLogin();
    await Future.delayed(Duration(seconds: 2));
    return boarded
        ? loggedIn
            ? IndexScreen(
                pageIndex: 0,
              )
            : SigninScreen()
        : OnboardingScreen();
  }

  Future navigate() async {
    await Future.delayed(Duration(seconds: 2));
    prefs.getBoarded().then((value) {
      if (value == null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => OnboardingScreen()));
      } else {
        prefs.readLogin().then((value) {
          if (value == null) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SigninScreen()));
          } else {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => IndexScreen(
                      pageIndex: 0,
                    )));
          }
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF0096EA), Color(0xFF1408A2)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            Image.asset(
              "images/logo.png",
              height: height < 700 ? 85 : 100,
              width: height < 700 ? 190 : 220,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Image.asset(
                "images/ethiotel.png",
                height: height < 700 ? 60 : 72,
                width: height < 700 ? 200 : 240,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
