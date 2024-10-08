import 'package:avetol/core/constants.dart';
import 'package:avetol/core/services/sharedPreferences.dart';
import 'package:avetol/features/common/errorFlushbar.dart';
import 'package:avetol/features/common/formatDate.dart';
import 'package:avetol/features/home/data/models/favorites.dart';
import 'package:avetol/features/home/data/models/homePage.dart';
import 'package:avetol/features/home/data/models/movieModel.dart';
import 'package:avetol/features/home/data/models/tvShowModel.dart';
import 'package:avetol/features/home/presentation/blocs/home_bloc.dart';
import 'package:avetol/features/home/presentation/blocs/home_event.dart';
import 'package:avetol/features/home/presentation/blocs/home_state.dart';
import 'package:avetol/features/home/presentation/screens/categoryScreen.dart';
import 'package:avetol/features/home/presentation/screens/indexScreen.dart';
import 'package:avetol/features/home/presentation/screens/moviesScreen.dart';
import 'package:avetol/features/home/presentation/screens/originalsScreen.dart';
import 'package:avetol/features/home/presentation/screens/tvShowScreen.dart';
import 'package:avetol/features/videoPlayer.dart/landscapePlayer/videoPlayer.dart';
import 'package:avetol/features/home/presentation/widgets/buildCategory.dart';
import 'package:avetol/features/home/presentation/widgets/buildMovieInfo.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final prefs = PrefService();
  var language;
  void fetchLanguage() async {
    language = await prefs.readLanguage();
  }

  int activeIndex = 0;
  bool isBookmarked = false;
  Map<String, bool> bookmarkStates = {};

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  void onRefresh() async {
    await Future.delayed(Duration(seconds: 2));

    BlocProvider.of<HomePageBloc>(context).add(GetHomePageEvent());
    refreshController.refreshCompleted();
  }

  final channelsImages = [
    "images/posters/ebs.jpg",
    "images/posters/kana.jpg",
  ];

  @override
  void initState() {
    super.initState();
    fetchLanguage();
    fetchInitialBookmarks();
    BlocProvider.of<HomePageBloc>(context).add(GetHomePageEvent());
  }

  void fetchInitialBookmarks() async {
    List<Map<String, String>> bookmarks = await prefs.checkOnMyList();
    setState(() {
      for (var bookmark in bookmarks) {
        bookmarkStates[bookmark['id']!] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomePageBloc, HomePageState>(
        listener: (context, state) {},
        builder: (context, state) {
          print(state);
          if (state is HomePageLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (state is HomePageSuccessfulState) {
            return buildInitialInput(homePage: state.homePage);
          } else if (state is HomePageFailureState) {
            return errorFlushbar(context: context, message: state.error);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget buildInitialInput({required HomePage homePage}) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bool isPopularMovie = homePage.popular.isNotEmpty &&
        homePage.popular[activeIndex] is MovieModel;
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
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    if (isPopularMovie) {
                      BlocProvider.of<MoviesBloc>(context).add(
                          GetMoviesEvent(homePage.popular[activeIndex].id));
                      PersistentNavBarNavigator.pushNewScreen(context,
                          screen: MoviesScreen(
                              movieId: homePage.popular[activeIndex].id),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino);
                    } else {
                      BlocProvider.of<TvShowBloc>(context).add(
                          GetTvShowEvent(homePage.popular[activeIndex].id));
                      PersistentNavBarNavigator.pushNewScreen(context,
                          screen: TvShowScreen(
                              tvShowId: homePage.popular[activeIndex].id),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino);
                    }
                  },
                  child: CarouselSlider.builder(
                      itemCount: homePage.popular.length,
                      itemBuilder: (context, index, realIndex) {
                        final carouselItem = homePage.popular[index];
                        final carouselImage = isPopularMovie
                            ? (carouselItem as MovieModel)
                                .attachments
                                .movie_thumbnail
                                .toString()
                            : (carouselItem as TvShowModel)
                                .attachments
                                .tv_show_thumbnail
                                .toString();
                        final color = isPopularMovie
                            ? (carouselItem as MovieModel).color
                            : (carouselItem as TvShowModel).color;
                        // Future<void> checkIfBookmarked() async {
                        //   bool result = await prefs.isOnMyList(
                        //       isPopularMovie
                        //           ? (carouselItem as MovieModel).id
                        //           : (carouselItem as TvShowModel).id,
                        //       isPopularMovie ? "Movie" : "TvShow");
                        //   setState(() {
                        //     isBookmarked = result;
                        //   });
                        // }

                        return buildImage(carouselImage, color, index);
                      },
                      options: CarouselOptions(
                          height: height * 0.75,
                          autoPlay: true,
                          autoPlayInterval: const Duration(seconds: 5),
                          autoPlayCurve: Curves.easeInOut,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 500),
                          enlargeCenterPage: false,
                          enlargeFactor: 0.3,
                          viewportFraction: 1.0,
                          onPageChanged: (index, reason) async {
                            setState(() => activeIndex = index);
                            final item = homePage.popular[index];
                            final itemId = item.id;
                            final itemType =
                                isPopularMovie ? "MOVIE" : "TVSHOW";
                            bool isBookmarked =
                                await prefs.isOnMyList(itemId, itemType);
                            setState(() {
                              bookmarkStates[itemId] = isBookmarked;
                            });
                          })),
                ),
                Positioned.fill(
                  top: 0,
                  child: Stack(
                    children: [
                      Container(
                        height: height * 0.15,
                        padding: EdgeInsets.only(left: width * 0.1),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(int.parse(homePage
                                      .popular[activeIndex].color
                                      .replaceAll("#", "0xFF")))
                                  .withOpacity(0.8),
                              blackColor.withOpacity(0),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 32,
                        left: width * 0.1,
                        child: Image.asset(
                          "images/logo.png",
                          height: 39,
                          width: 97,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                    bottom: 200,
                    child: SizedBox(
                      width: width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image.asset(
                            "images/logoSmall.png",
                            height: 20,
                            width: 20,
                          ),
                          Text(
                            isPopularMovie ? "Movie" : "SERIES",
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: fontSize15,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    )),
                Positioned(
                    bottom: 120,
                    child: SizedBox(
                      width: width,
                      child: Center(
                        child: Image.network(
                          homePage
                              .popular[activeIndex].attachments.tv_show_title
                              .toString(),
                          height: 80,
                          width: 290,
                        ),
                      ),
                    )),
                Positioned(
                  bottom: 100,
                  child: SizedBox(
                    width: width,
                    child: Center(
                      child: buildMovieInfo(
                          15,
                          // getLanguageValueByKey(
                          homePage.popular[activeIndex].genres[0].name[0].value,
                          // language),
                          isPopularMovie
                              ? convertToMinutes((homePage.popular[activeIndex]
                                              as MovieModel)
                                          .duration)
                                      .toString() +
                                  " min"
                              : "${homePage.popular[activeIndex].seasons_count} Seasons",
                          formatDate(
                              homePage.popular[activeIndex].release_date)),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 35,
                    child: SizedBox(
                      width: width,
                      child: Center(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              primaryButtonColor)),
                                  onPressed: () {
                                    PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: VideoPlayer(),
                                        withNavBar: false,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 16),
                                    child: Text(
                                      "Watch Now",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: fontSize15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )),
                              const SizedBox(
                                width: 7,
                              ),
                              IconButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              secondaryButtonColor)),
                                  onPressed: () async {
                                    final itemId =
                                        homePage.popular[activeIndex].id;
                                    final itemType =
                                        isPopularMovie ? "MOVIE" : "TVSHOW";
                                    setState(() {
                                      bookmarkStates[itemId] =
                                          !(bookmarkStates[itemId] ?? false);
                                    });
                                    print(
                                        "${bookmarkStates[itemId]} 111111111111111111");
                                    if (bookmarkStates[itemId] == true) {
                                      await prefs.addToMyList(itemId, itemType);
                                      BlocProvider.of<FavoritesBloc>(context)
                                          .add(PostFavoritesEvent(
                                        Favorites(
                                            content_type: itemType,
                                            content_id: itemId),
                                      ));
                                    } else {
                                      await prefs.removeFromMyList(itemId);
                                      BlocProvider.of<FavoritesBloc>(context)
                                          .add(DelFavoritesEvent(
                                        Favorites(
                                            content_type: itemType,
                                            content_id: itemId),
                                      ));
                                    }
                                  },
                                  icon: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: bookmarkStates[homePage
                                                .popular[activeIndex].id] ==
                                            true
                                        ? Icon(Icons.bookmark)
                                        : Icon(Icons.add),
                                  ))
                            ]),
                      ),
                    )),
                Positioned(
                    bottom: 10,
                    child: SizedBox(
                        width: width,
                        child: Center(child: buildIndicator(homePage)))),
              ],
            ),
            Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.topCenter,
                        colors: [
                          blackColor,
                          Color(int.parse(homePage.popular[activeIndex].color
                                  .replaceAll("#", "0xFF")))
                              .withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ),
                buildHorizontalList(
                    title: "Continue Watching",
                    dataList: homePage.continueWatching,
                    onInteraction: (movieId) {
                      BlocProvider.of<MoviesBloc>(context)
                          .add(GetMoviesEvent(movieId));
                      PersistentNavBarNavigator.pushNewScreen(context,
                          screen: MoviesScreen(movieId: movieId),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino);
                    },
                    trending: false,
                    continueWatching: true,
                    exclusive: false),
              ],
            ),
            buildHorizontalList(
                title: "Trending",
                dataList: homePage.trending,
                onInteraction: (tvShowId) {
                  BlocProvider.of<TvShowBloc>(context)
                      .add(GetTvShowEvent(tvShowId));
                  PersistentNavBarNavigator.pushNewScreen(context,
                      screen: TvShowScreen(tvShowId: tvShowId),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino);
                },
                trending: true,
                continueWatching: false,
                exclusive: false),
            Visibility(
              visible: homePage.original.isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 29, top: 25, right: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "images/logoBlue.png",
                              width: 80,
                              height: 30,
                            ),
                            Text(
                              "Originals",
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: fontSize20,
                                  fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        TextButton(
                            onPressed: () {
                              BlocProvider.of<HomePageBloc>(context)
                                  .add(GetHomePageEvent());
                              PersistentNavBarNavigator.pushNewScreen(context,
                                  screen: OriginalsScreen(),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino);
                            },
                            child: Text(
                              "View all",
                              style: TextStyle(
                                  color: primaryColor,
                                  fontSize: fontSize14,
                                  fontWeight: FontWeight.w300),
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: width,
                    height: 355,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 24),
                        itemCount: homePage.original.length,
                        itemBuilder: (BuildContext context, int index) {
                          var item = homePage.original[index];
                          bool isMovie = item is MovieModel;

                          var originalsImage = isMovie
                              ? (item as MovieModel)
                                  .attachments
                                  .movie_thumbnail
                                  .toString()
                              : (item as TvShowModel)
                                  .attachments
                                  .tv_show_thumbnail
                                  .toString();
                          var color = isMovie
                              ? (item as MovieModel).color
                              : (item as TvShowModel).color;
                          var title = isMovie
                              ? (item as MovieModel)
                                  .attachments
                                  .movie_title
                                  .toString()
                              : (item as TvShowModel)
                                  .attachments
                                  .tv_show_title
                                  .toString();
                          var genre = isMovie
                              ? (item as MovieModel).genres[0].name
                              : (item as TvShowModel).genres[0].name;
                          var durationOrSeasons = isMovie
                              ? convertToMinutes((item as MovieModel).duration)
                                      .toString() +
                                  " min"
                              : (item as TvShowModel).seasons_count +
                                  " Seasons";
                          var releaseDate = isMovie
                              ? (item as MovieModel).release_date
                              : (item as TvShowModel).release_date;
                          return GestureDetector(
                            onTap: () {
                              if (isMovie) {
                                BlocProvider.of<MoviesBloc>(context).add(
                                    GetMoviesEvent(
                                        homePage.original[index].id));
                                PersistentNavBarNavigator.pushNewScreen(context,
                                    screen: MoviesScreen(
                                        movieId: homePage.original[index].id),
                                    withNavBar: false,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino);
                              } else {
                                BlocProvider.of<TvShowBloc>(context).add(
                                    GetTvShowEvent((item as TvShowModel).id));
                                PersistentNavBarNavigator.pushNewScreen(context,
                                    screen: TvShowScreen(
                                        tvShowId: (item as TvShowModel).id),
                                    withNavBar: false,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino);
                              }
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: 270,
                                  height: 355,
                                  margin: const EdgeInsets.only(right: 21),
                                  decoration: BoxDecoration(
                                      color: versionTxtColor.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(25)),
                                ),
                                Container(
                                  width: 270,
                                  height: 355,
                                  margin: const EdgeInsets.only(right: 21),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(originalsImage),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(25)),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 21),
                                    constraints: const BoxConstraints.expand(
                                        width: 270, height: 300),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      gradient: LinearGradient(
                                        begin: Alignment.center,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(int.parse(color.replaceAll(
                                                  "#", "0xFF")))
                                              .withOpacity(0),
                                          Color(int.parse(
                                              color.replaceAll("#", "0xFF"))),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 100,
                                  child: SizedBox(
                                    width: 270,
                                    child: Text(
                                      isMovie ? "A Movie" : "A TV Show",
                                      style: TextStyle(
                                          color: whiteColor,
                                          fontSize: fontSize8,
                                          fontWeight: FontWeight.w600),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 40,
                                  child: SizedBox(
                                    width: 270,
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 3, bottom: 6),
                                        child: Image.network(
                                          title,
                                          height: 40,
                                          width: 140,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 26,
                                  child: SizedBox(
                                    width: 270,
                                    child: Center(
                                      child: buildMovieInfo(
                                          15,
                                          // getLanguageValueByKey(
                                          genre[0].value,
                                          // language),
                                          durationOrSeasons,
                                          formatDate(releaseDate)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
            Visibility(
              visible: homePage.ads[0].poster.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: Image.network(
                  homePage.ads[0].poster,
                  height: 293,
                  width: width,
                ),
              ),
            ),
            buildHorizontalList(
                title: "Avetol Shows",
                dataList: homePage.tvShows,
                onInteraction: (movieId) {
                  BlocProvider.of<TvShowBloc>(context)
                      .add(GetTvShowEvent(movieId));
                  PersistentNavBarNavigator.pushNewScreen(context,
                      screen: TvShowScreen(tvShowId: movieId),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino);
                },
                trending: false,
                continueWatching: false,
                exclusive: false),
            Visibility(
              visible: true,
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Text(
                            "Avetol Live Channels",
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: fontSize20,
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Padding(
                              padding: EdgeInsets.only(right: 13),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: whiteColor,
                              ),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: width,
                      height: 115,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 24),
                          itemCount: channelsImages.length,
                          itemBuilder: (BuildContext context, int index) {
                            var channelsImage = channelsImages[index];

                            return GestureDetector(
                              onTap: () {
                                PersistentNavBarNavigator.pushNewScreen(context,
                                    screen: IndexScreen(pageIndex: 2),
                                    withNavBar: false,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino);
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    //width: 270, height: 162
                                    width: 212,
                                    height: 115,
                                    margin: const EdgeInsets.only(right: 21),
                                    decoration: BoxDecoration(
                                        color: versionTxtColor.withOpacity(0.6),
                                        borderRadius:
                                            BorderRadius.circular(22)),
                                  ),
                                  Container(
                                    width: 212,
                                    height: 115,
                                    margin: const EdgeInsets.only(right: 21),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(channelsImage),
                                            fit: BoxFit.cover),
                                        borderRadius:
                                            BorderRadius.circular(22)),
                                  ),
                                ],
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ),
            ),
            buildHorizontalList(
                title: "Exclusives",
                dataList: homePage.exclusive,
                onInteraction: (movieId) {
                  BlocProvider.of<MoviesBloc>(context)
                      .add(GetMoviesEvent(movieId));
                  PersistentNavBarNavigator.pushNewScreen(context,
                      screen: MoviesScreen(movieId: movieId),
                      withNavBar: false,
                      pageTransitionAnimation:
                          PageTransitionAnimation.cupertino);
                },
                trending: false,
                continueWatching: false,
                exclusive: true),
            Visibility(
              visible: homePage.ads[1].poster.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Stack(
                  children: [
                    Image.network(
                      homePage.ads[1].poster,
                      height: 394,
                      width: width,
                    ),
                    Positioned(
                      top: 38,
                      right: 25,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(6, 3, 6, 0),
                        decoration: BoxDecoration(
                            border: Border.all(color: whiteColor, width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          "AD",
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: fontSize16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: homePage.genres.isNotEmpty,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, top: 15),
                    child: Text(
                      "Categories",
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: fontSize20,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: width,
                    height: 162,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 24),
                        itemCount: homePage.genres.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 21),
                            child: buildCategory(
                                context,
                                270,
                                162,
                                Color(int.parse(
                                    "0xFF${homePage.genres[index].color_formatted}")),
                                Color(int.parse(
                                        "0xFF${homePage.genres[index].color_formatted}"))
                                    .withOpacity(0),
                                // getLanguageValueByKey(
                                homePage.genres[index].name[0].value,
                                // language),
                                () {
                              BlocProvider.of<CategoryBloc>(context).add(
                                  GetCategoryDetailEvent(
                                      homePage.genres[index].id));
                              PersistentNavBarNavigator.pushNewScreen(context,
                                  screen: CategoryScreen(),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino);
                            }),
                          );
                        }),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHorizontalList(
      {required String title,
      required List<dynamic> dataList,
      required Function(String) onInteraction,
      required bool trending,
      required bool continueWatching,
      required bool exclusive}) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 25),
          child: Text(
            title,
            style: TextStyle(
                color: whiteColor,
                fontSize: fontSize20,
                fontWeight: FontWeight.w900),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          width: width,
          height: exclusive ? 243 : 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 24),
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int index) {
                var item = dataList[index];
                var isMovie = item is MovieModel;

                var tileImage = isMovie
                    ? item.attachments.movie_thumbnail.toString()
                    : item.attachments.tv_show_thumbnail.toString();
                // var status = dataList[index]['status'] != null
                //     ? double.parse(dataList[index]['status']) / 100
                //     : 0.0;
                var status = 0.2;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        onInteraction(item.id);
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: exclusive
                                ? width > 750
                                    ? 361
                                    : 320
                                : 270,
                            height: exclusive ? 203 : 162,
                            margin: const EdgeInsets.only(right: 21),
                            decoration: BoxDecoration(
                                color: versionTxtColor.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(22)),
                          ),
                          Container(
                            width: exclusive
                                ? width > 750
                                    ? 361
                                    : 320
                                : 270,
                            height: exclusive ? 203 : 162,
                            margin: const EdgeInsets.only(right: 21),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(tileImage),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(22)),
                          ),
                          trending
                              ? Positioned(
                                  top: 11,
                                  right: 36,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                        color: whiteColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "images/logoSmall.png",
                                          height: 15,
                                          width: 15,
                                        ),
                                        Text(
                                          " PLUS",
                                          style: TextStyle(
                                              color: trendingColor,
                                              fontSize: fontSize10),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          continueWatching
                              ? Positioned(
                                  bottom: 0,
                                  left: 3,
                                  child: Container(
                                    width: 270 * status,
                                    height: 11,
                                    decoration: const BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(22))),
                                  ))
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 11,
                    ),
                    Text(
                      // getLanguageValueByKey(
                      item.title[0].value,
                      //  language),
                      style: TextStyle(
                          color: whiteColor,
                          fontSize: fontSize16,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                );
              }),
        )
      ],
    );
  }

  Widget buildIndicator(HomePage homepage) {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: homepage.popular.length,
      effect: ScrollingDotsEffect(
          dotWidth: 8,
          dotHeight: 8,
          activeDotColor: indicatorColor,
          dotColor: inactiveIndicatorColor),
    );
  }

  Widget buildImage(String carouselImage, String gradientColor, int index) {
    return Stack(
      children: [
        // Image Container
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(carouselImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  blackColor.withOpacity(0),
                  Color(int.parse(gradientColor.replaceAll("#", "0xFF")))
                      .withOpacity(0.9),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
