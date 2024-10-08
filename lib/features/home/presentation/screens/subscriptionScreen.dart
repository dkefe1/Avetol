import 'package:avetol/core/constants.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/errorText.dart';
import 'package:avetol/features/home/presentation/screens/indexScreen.dart';
import 'package:avetol/features/home/presentation/widgets/giftCardTextForm.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  TextEditingController giftCardController = TextEditingController();

  bool giftCardNumisEmpty = false;
  bool invalidGiftCardNum = false;
  @override
  void dispose() {
    super.dispose();
    giftCardController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     onPressed: () {
        //       PersistentNavBarNavigator.pushNewScreen(context,
        //           screen: IndexScreen(pageIndex: 3),
        //           withNavBar: false,
        //           pageTransitionAnimation: PageTransitionAnimation.cupertino);
        //     },
        //     icon: Icon(
        //       Icons.arrow_back_ios,
        //       color: whiteColor.withOpacity(0.8),
        //     )),
        title: RichText(
            text: TextSpan(
                style: TextStyle(
                  color: whiteColor,
                ),
                children: [
              TextSpan(
                  text: "Choose your plan\n",
                  style: TextStyle(
                      fontSize: fontSize20, fontWeight: FontWeight.w900)),
              TextSpan(
                  text: "Ethiopia",
                  style: TextStyle(
                      fontSize: fontSize16, fontWeight: FontWeight.w300))
            ])),
        toolbarHeight: height * 0.08,
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 27, right: 27, bottom: 20),
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const IndexScreen(pageIndex: 0)));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.fromLTRB(29, 23, 34, 15),
              decoration: BoxDecoration(
                color: tileColor,
                borderRadius: BorderRadius.circular(29),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(
                          style: TextStyle(
                            color: whiteColor,
                          ),
                          children: [
                        TextSpan(
                            text: "Avetol Free\n",
                            style: TextStyle(
                                fontSize: fontSize30,
                                fontWeight: FontWeight.w900)),
                        TextSpan(
                            text: "with Advertising",
                            style: TextStyle(
                                fontSize: fontSize18,
                                fontWeight: FontWeight.w300))
                      ])),
                  const SizedBox(
                    height: 12,
                  ),
                  Divider(
                    color: whiteColor.withOpacity(0.32),
                  ),
                  SizedBox(
                    height: width < 380 ? 50 : 80,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Free",
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: fontSize30,
                            fontWeight: FontWeight.w900),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: IndexScreen(pageIndex: 0),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(29),
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [Color(0xFF0AB22F), Color(0xFF0D16DE)])),
              child: Container(
                padding: const EdgeInsets.fromLTRB(29, 23, 34, 15),
                decoration: BoxDecoration(
                  color: secondTileColor,
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Avetol Premium",
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: fontSize30,
                          fontWeight: FontWeight.w900),
                    ),
                    Divider(
                      color: whiteColor.withOpacity(0.32),
                    ),
                    SizedBox(
                      height: width < 380 ? 50 : 80,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          "images/ethiotel.png",
                          height: 60,
                          width: width < 380 ? 150 : 180,
                        ),
                        RichText(
                            text: TextSpan(
                                style: TextStyle(
                                  color: whiteColor,
                                ),
                                children: [
                              TextSpan(
                                  text: "120 ",
                                  style: TextStyle(
                                      fontSize: fontSize30,
                                      fontWeight: FontWeight.w900)),
                              TextSpan(
                                  text: "Birr",
                                  style: TextStyle(
                                      fontSize: fontSize15,
                                      fontWeight: FontWeight.w300))
                            ])),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.only(top: 23, bottom: 15),
            decoration: BoxDecoration(
              color: thirdTileColor,
              borderRadius: BorderRadius.circular(29),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: width < 380 ? 60 : 95,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Text(
                    "Gift Card",
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: fontSize30,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 30),
                  child: giftCardTextForm(
                      controller: giftCardController,
                      hintText: "333 444 555 ***",
                      onInteraction: () {
                        setState(() {
                          giftCardNumisEmpty = false;
                          invalidGiftCardNum = false;
                        });
                      },
                      onSubmit: () {
                        if (giftCardController.text.isEmpty) {
                          return setState(() {
                            giftCardNumisEmpty = true;
                          });
                        }
                        if (giftCardController.text.length != 16) {
                          return setState(() {
                            invalidGiftCardNum = true;
                          });
                        }
                        PersistentNavBarNavigator.pushNewScreen(context,
                            screen: IndexScreen(pageIndex: 0),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino);
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 5),
                  child: Column(
                    children: [
                      giftCardNumisEmpty
                          ? errorText(
                              text: "Please Enter your Gift Card Number")
                          : SizedBox.shrink(),
                      invalidGiftCardNum
                          ? errorText(
                              text: "Please Enter a valid Gift Card Number")
                          : SizedBox.shrink(),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
