import 'package:avetol/core/constants.dart';
import 'package:avetol/core/services/sharedPreferences.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_bloc.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_event.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_state.dart';
import 'package:avetol/features/auth/signin/presentation/screens/signinScreen.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:avetol/features/common/errorFlushbar.dart';
import 'package:avetol/features/common/successFlushbar.dart';
import 'package:avetol/features/home/presentation/widgets/logoutButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class SignoutDialog extends StatefulWidget {
  const SignoutDialog({super.key});

  @override
  State<SignoutDialog> createState() => _SignoutDialogState();
}

class _SignoutDialogState extends State<SignoutDialog> {
  final prefs = PrefService();
  bool isLoading = false;
  bool isLoggingOut = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: AlertDialog(
            insetPadding: EdgeInsets.zero,
            actionsAlignment: MainAxisAlignment.end,
            backgroundColor: blackColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25))),
            content: Container(
              height: 150,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Logout",
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: fontSize18,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "Are you sure you want to log out?",
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: fontSize16,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width * 0.31,
                        child: submitButton(
                          text: "Cancel",
                          disable: false,
                          onInteraction: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(
                        width: width * 0.31,
                        child: logoutButton(
                            text: isLoading ? "Signing Out.." : "Sign Out",
                            disable: isLoading,
                            onInteraction: () async {
                              print(await prefs.readToken());
                              if (!isLoggingOut) {
                                setState(() {
                                  isLoggingOut = true;
                                  isLoading = true;
                                });
                                BlocProvider.of<LogoutBloc>(context)
                                    .add(DelLogoutEvent());
                              }
                            }),
                      ),
                    ],
                  ),
                  BlocConsumer<LogoutBloc, LogoutState>(
                    listener: (context, state) {
                      print(state);
                      if (state is LogoutLoadingState) {
                        setState(() {
                          isLoading = true;
                        });
                        Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        );
                      } else if (state is LogoutSuccessfulState) {
                        setState(() {
                          isLoading = false;
                          isLoggingOut = false;
                        });

                        PersistentNavBarNavigator.pushNewScreen(context,
                            screen: SigninScreen(),
                            withNavBar: false,
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino);
                        successFlushBar(
                            context: context,
                            message: "Logged out Successfully!");
                        prefs.removeToken();
                        prefs.logout();
                      } else if (state is LogoutFailureState) {
                        setState(() {
                          isLoading = false;
                          isLoggingOut = false;
                        });
                        errorFlushbar(context: context, message: state.error);
                      }
                    },
                    builder: (context, state) {
                      return Container();
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
