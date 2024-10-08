import 'package:avetol/core/constants.dart';
import 'package:avetol/core/services/sharedPreferences.dart';
import 'package:avetol/features/common/errorFlushbar.dart';
import 'package:avetol/features/common/formatDate.dart';
import 'package:avetol/features/common/getLanguageValueByKey.dart';
import 'package:avetol/features/guidelines/presentation/screens/aboutScreen.dart';
import 'package:avetol/features/guidelines/presentation/screens/feedbackScreen.dart';
import 'package:avetol/features/guidelines/presentation/screens/helpcenterScreen.dart';
import 'package:avetol/features/guidelines/presentation/screens/privacyPolicyScreen.dart';
import 'package:avetol/features/guidelines/presentation/screens/termsAndConditionsScreen.dart';
import 'package:avetol/features/home/data/models/profile.dart';
import 'package:avetol/features/home/presentation/blocs/home_bloc.dart';
import 'package:avetol/features/home/presentation/blocs/home_event.dart';
import 'package:avetol/features/home/presentation/blocs/home_state.dart';
import 'package:avetol/features/home/presentation/screens/languageScreen.dart';
import 'package:avetol/features/home/presentation/screens/manageProfileScreen.dart';
import 'package:avetol/features/home/presentation/screens/moviesScreen.dart';
import 'package:avetol/features/home/presentation/screens/myListScreen.dart';
import 'package:avetol/features/home/presentation/screens/signOutDialog.dart';
import 'package:avetol/features/home/presentation/screens/tvShowScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var avatar;
  final prefs = PrefService();
  var language;
  void fetchLanguage() async {
    language = await prefs.readLanguage();
  }

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    await Future.delayed(Duration(seconds: 2));

    BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
    refreshController.refreshCompleted();
  }

  final List<Map<String, dynamic>> plans = [
    {
      'gradientStart': const Color(0xFF148CCF),
      'gradientEnd': const Color(0xFF2314CF)
    },
    {
      'gradientStart': const Color(0xFF0AB5A0),
      'gradientEnd': const Color(0xFF078129)
    },
  ];
  @override
  void initState() {
    super.initState();
    fetchLanguage();
    BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          print(state);
          if (state is ProfileLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (state is ProfileSuccessfulState) {
            return buildInitialInput(profile: state.profile);
          } else if (state is ProfileFailureState) {
            return errorFlushbar(context: context, message: state.error);
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildInitialInput({required Profile profile}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(profile.user.avatar_url);
    return SmartRefresher(
      controller: refreshController,
      enablePullDown: true,
      onRefresh: onRefresh,
      header: WaterDropMaterialHeader(
        backgroundColor: blackColor,
        color: primaryColor,
      ),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = SizedBox.shrink();
          } else if (mode == LoadStatus.loading) {
            body = Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: primaryColor,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Loading...',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            );
          } else if (mode == LoadStatus.failed) {
            body = Text('Load Failed! Click retry!');
          } else if (mode == LoadStatus.canLoading) {
            body = Text('Release to load more');
          } else {
            body = SizedBox.shrink();
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 530,
              width: width,
              child: Stack(
                children: [
                  Positioned(
                    left: -70,
                    child: Container(
                      height: 328,
                      width: 328,
                      decoration: BoxDecoration(
                          gradient: RadialGradient(colors: [
                        const Color(0xFF1D49BA).withOpacity(0.51),
                        const Color(0xFF1D49BA).withOpacity(0)
                      ])),
                      child: Center(
                        child: Container(
                          height: 99,
                          width: 99,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      profile.user.avatar_url.toString()),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 45,
                    left: 31,
                    child: Text(
                      "Account",
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: height > 850 ? fontSize33 : fontSize28,
                          fontWeight: FontWeight.w900),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Positioned(
                    top: 125,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 145, right: 24),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 22,
                              ),
                              SizedBox(
                                width: width * 0.52,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profile.user.full_name,
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: height < 720
                                              ? fontSize20
                                              : fontSize24,
                                          fontWeight: FontWeight.w900),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                    Text(
                                      profile.user.email.isEmpty
                                          ? profile.user.phone
                                          : profile.user.email,
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: fontSize13,
                                          fontWeight: FontWeight.w300),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                    Text(
                                      'Basic Plan',
                                      style: TextStyle(
                                          color: primaryColor,
                                          fontSize: fontSize16,
                                          fontWeight: FontWeight.w300),
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: width,
                          margin: const EdgeInsets.only(top: 40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 24, right: 14),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "My List",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: fontSize20,
                                          fontWeight: FontWeight.w900),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          PersistentNavBarNavigator
                                              .pushNewScreen(context,
                                                  screen: MyListScreen(
                                                      profile: profile),
                                                  withNavBar: false,
                                                  pageTransitionAnimation:
                                                      PageTransitionAnimation
                                                          .cupertino);
                                        },
                                        icon: Icon(
                                          Icons.arrow_forward_ios,
                                          color: whiteColor,
                                        ))
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                width: width,
                                height: 200,
                                child: profile.myList.isEmpty
                                    ? Center(
                                        child: Text(
                                          "You haven't saved any movies yet",
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      )
                                    : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        padding:
                                            const EdgeInsets.only(left: 24),
                                        itemCount: profile.myList.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              if (profile
                                                  .myList[index]
                                                  .attachments
                                                  .movie_thumbnail!
                                                  .isNotEmpty) {
                                                BlocProvider.of<MoviesBloc>(
                                                        context)
                                                    .add(GetMoviesEvent(profile
                                                        .myList[index].id));
                                                PersistentNavBarNavigator
                                                    .pushNewScreen(context,
                                                        screen: MoviesScreen(
                                                            movieId: profile
                                                                .myList[index]
                                                                .id),
                                                        withNavBar: false,
                                                        pageTransitionAnimation:
                                                            PageTransitionAnimation
                                                                .cupertino);
                                              } else {
                                                BlocProvider.of<TvShowBloc>(
                                                        context)
                                                    .add(GetTvShowEvent(profile
                                                        .myList[index].id));
                                                PersistentNavBarNavigator
                                                    .pushNewScreen(context,
                                                        screen: TvShowScreen(
                                                            tvShowId: profile
                                                                .myList[index]
                                                                .id),
                                                        withNavBar: false,
                                                        pageTransitionAnimation:
                                                            PageTransitionAnimation
                                                                .cupertino);
                                              }
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Stack(
                                                  children: [
                                                    Container(
                                                      width: 270,
                                                      height: 162,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 14),
                                                      decoration: BoxDecoration(
                                                          color: versionTxtColor
                                                              .withOpacity(0.6),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      22)),
                                                    ),
                                                    Container(
                                                      width: 270,
                                                      height: 162,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              right: 14),
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: NetworkImage(profile
                                                                      .myList[
                                                                          index]
                                                                      .attachments
                                                                      .movie_thumbnail!
                                                                      .isNotEmpty
                                                                  ? profile
                                                                      .myList[
                                                                          index]
                                                                      .attachments
                                                                      .movie_thumbnail
                                                                      .toString()
                                                                  : profile
                                                                      .myList[
                                                                          index]
                                                                      .attachments
                                                                      .tv_show_thumbnail
                                                                      .toString()),
                                                              fit:
                                                                  BoxFit.cover),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      22)),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 11,
                                                ),
                                                Text(
                                                  getLanguageValueByKey(
                                                      profile
                                                          .myList[index].title,
                                                      language),
                                                  style: TextStyle(
                                                      color: whiteColor,
                                                      fontSize: fontSize16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Settings",
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: fontSize20,
                            fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      buildTile(
                          title: "Manage Profile",
                          signOut: false,
                          onInteraction: () {
                            BlocProvider.of<ProfileBloc>(context)
                                .add(GetAvatarEvent());
                            PersistentNavBarNavigator.pushNewScreen(context,
                                screen: ManageProfile(
                                  first_name: profile.user.first_name,
                                  last_name: profile.user.last_name,
                                  email: profile.user.email,
                                  dob: formatDateWithoutTime(
                                      DateTime.parse(profile.user.dob)),
                                  phone: profile.user.phone,
                                  avatar_id: profile.user.avatar_id,
                                  avatar_url: profile.user.avatar_url,
                                ),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino);
                          }),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: SizedBox(
                          width: width - 30,
                          child: ElevatedButton(
                            onPressed: () {
                              PersistentNavBarNavigator.pushNewScreen(context,
                                  screen: LanguageScreen(),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: profileButtonBg,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 26),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Language',
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.w300,
                                      fontSize: fontSize16),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      language.toString().toUpperCase(),
                                      style: TextStyle(
                                          color: englishBtnTxt,
                                          fontWeight: FontWeight.w300,
                                          fontSize: fontSize16),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      color: whiteColor,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 45, left: 17),
                  child: Text(
                    "Subscription Plan",
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: fontSize20,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 17),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: fontSize16, fontWeight: FontWeight.w300),
                        children: [
                          TextSpan(
                              text: "Current plan ",
                              style: TextStyle(color: englishBtnTxt)),
                          const TextSpan(
                              text: "Basic",
                              style: TextStyle(color: primaryColor))
                        ]),
                  ),
                ),
                SizedBox(
                  width: width,
                  height: 137,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 17),
                      itemCount: plans.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 7, right: 7, top: 5),
                            padding: const EdgeInsets.only(
                                left: 18, top: 18, right: 14, bottom: 14),
                            width: 301,
                            height: 137,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      plans[index]['gradientStart'],
                                      plans[index]['gradientEnd']
                                    ])),
                            child: Stack(children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: index == 1
                                    ? Text(
                                        "Basic",
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontSize: fontSize26,
                                            fontWeight: FontWeight.w900),
                                      )
                                    : RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                              color: whiteColor,
                                              fontSize: fontSize26,
                                            ),
                                            children: const [
                                              TextSpan(
                                                  text: "Upgrade to \n",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300)),
                                              TextSpan(
                                                  text: "Premium",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900))
                                            ]),
                                      ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  "\$5.99",
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontSize: fontSize20,
                                      fontWeight: FontWeight.w900),
                                ),
                              ),
                              index == 1
                                  ? Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        "Active",
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontSize: fontSize20,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    )
                                  : const SizedBox.shrink()
                            ]),
                          ),
                        );
                      }),
                ),
                const SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About",
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: fontSize20,
                            fontWeight: FontWeight.w900),
                      ),
                      buildTile(
                          title: "About Us",
                          signOut: false,
                          onInteraction: () {
                            PersistentNavBarNavigator.pushNewScreen(context,
                                screen: AboutUsScreen(),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino);
                          }),
                      buildTile(
                          title: "Help Center",
                          signOut: false,
                          onInteraction: () {
                            PersistentNavBarNavigator.pushNewScreen(context,
                                screen: HelpCenterScreen(),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino);
                          }),
                      buildTile(
                          title: "Privacy Policy",
                          signOut: false,
                          onInteraction: () {
                            PersistentNavBarNavigator.pushNewScreen(context,
                                screen: PrivacyPolicyScreen(),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino);
                          }),
                      buildTile(
                          title: "Terms and Conditions",
                          signOut: false,
                          onInteraction: () {
                            PersistentNavBarNavigator.pushNewScreen(context,
                                screen: TermsAndConditionsScreen(),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino);
                          }),
                      buildTile(
                          title: "Feedback",
                          signOut: false,
                          onInteraction: () {
                            PersistentNavBarNavigator.pushNewScreen(context,
                                screen: FeedbackScreen(),
                                withNavBar: false,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino);
                          }),
                      SizedBox(
                        height: height < 720 ? 45 : 75,
                      ),
                      buildTile(
                          title: "Sign out",
                          signOut: true,
                          onInteraction: () async {
                            showDialog(
                                context: context,
                                barrierColor: blackColor.withOpacity(0.3),
                                builder: (context) {
                                  return SignoutDialog();
                                });
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  height: height < 720 ? 20 : 50,
                ),
                Center(
                  child: Text(
                    "Version 2.0.1",
                    style: TextStyle(
                        color: versionTxtColor,
                        fontSize: fontSize15,
                        fontWeight: FontWeight.w300),
                  ),
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildTile(
      {required String title,
      required bool signOut,
      required VoidCallback onInteraction}) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width - 30,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: ElevatedButton(
          onPressed: onInteraction,
          style: ElevatedButton.styleFrom(
            backgroundColor: profileButtonBg,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: signOut ? Colors.red : whiteColor,
                    fontWeight: FontWeight.w300,
                    fontSize: fontSize16),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: whiteColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
