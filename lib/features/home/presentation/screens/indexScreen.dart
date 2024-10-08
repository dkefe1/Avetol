import 'package:avetol/core/constants.dart';
import 'package:avetol/features/home/presentation/screens/accountScreen.dart';
import 'package:avetol/features/home/presentation/screens/browseScreen.dart';
import 'package:avetol/features/home/presentation/screens/homeScreen.dart';
import 'package:avetol/features/home/presentation/screens/liveTvScreen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({required this.pageIndex, super.key});

  final int pageIndex;

  @override
  State<IndexScreen> createState() => _IndexScreenState(pageIndex: pageIndex);
}

class _IndexScreenState extends State<IndexScreen> {
  final pages = [
    const HomeScreen(),
    const BrowseScreen(),
    const LiveTvScreen(),
    const AccountScreen()
  ];
  _IndexScreenState({required this.pageIndex});

  int pageIndex = 0;
  late PersistentTabController controller;

  @override
  void initState() {
    super.initState();
    controller = PersistentTabController(initialIndex: pageIndex);
  }

  List<Widget> _buildScreens() {
    return [
      const HomeScreen(),
      const BrowseScreen(),
      const LiveTvScreen(),
      const AccountScreen()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
    return [
      PersistentBottomNavBarItem(
        // onPressed: (p0) {
        //   Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
        //       BottomNavbarPage.routeName,
        //       ModalRoute.withName(Homepage.routeName));
        // },
        icon: Icon(Iconsax.home),
        title: ("Home"),
        textStyle: TextStyle(fontSize: 10),
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: whiteColor,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Iconsax.search_normal),
        title: ("Browse"),
        textStyle: TextStyle(fontSize: 10),
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: whiteColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.tv),
        title: ("Live TV"),
        textStyle: TextStyle(fontSize: 10),
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: whiteColor,
      ),
      PersistentBottomNavBarItem(
        contentPadding: 10,
        icon: const Icon(Iconsax.user),
        title: ("Account"),
        textStyle: TextStyle(fontSize: 10),
        activeColorPrimary: primaryColor,
        inactiveColorPrimary: whiteColor,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: controller,

        screens: _buildScreens(),
        items: _navBarsItems(context),

        confineInSafeArea: true,
        backgroundColor: Colors.black, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true,
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(0.0),

          boxShadow: [
            BoxShadow(
              color: primaryColor,
              offset: const Offset(
                5.0,
                5.0,
              ),
              blurRadius: 10.0,
              spreadRadius: 2.0,
            ), //BoxShadow
            //BoxShadow
          ],
          // colorBehindNavBar: kColorWhite,
        ),

        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: const ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: const ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style8, // Choose the nav bar style with this property.
      ),
    );
  }
}
