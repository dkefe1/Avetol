import 'package:avetol/core/constants.dart';
import 'package:avetol/core/services/sharedPreferences.dart';
import 'package:avetol/features/common/errorFlushbar.dart';
import 'package:avetol/features/common/formatDate.dart';
import 'package:avetol/features/common/getLanguageValueByKey.dart';
import 'package:avetol/features/home/data/models/favorites.dart';
import 'package:avetol/features/home/data/models/movies.dart';
import 'package:avetol/features/home/data/models/related.dart';
import 'package:avetol/features/home/presentation/blocs/home_bloc.dart';
import 'package:avetol/features/home/presentation/blocs/home_event.dart';
import 'package:avetol/features/home/presentation/blocs/home_state.dart';
import 'package:avetol/features/home/presentation/screens/castScreen.dart';
import 'package:avetol/features/home/presentation/widgets/buildMovieInfo.dart';
import 'package:avetol/features/home/presentation/widgets/buildTextColumn.dart';
import 'package:avetol/features/home/presentation/widgets/buildTextListColumn.dart';
import 'package:avetol/features/videoPlayer.dart/landscapePlayer/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glass/glass.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

// ignore: must_be_immutable
class MoviesScreen extends StatefulWidget {
  final String movieId;
  MoviesScreen({required this.movieId, super.key});

  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final prefs = PrefService();
  var language;
  void fetchLanguage() async {
    language = await prefs.readLanguage();
  }

  final List<Map<String, dynamic>> movies = [
    {
      'title': "Watch Full Movie",
    },
    {
      'title': "Trailer",
    },
  ];

  late ScrollController _episodeScrollController;
  late ScrollController _seasonScrollController;
  late ScrollController _screenScrollController;
  int selectedSeason = 0;
  bool hideArrowLeft = true;
  bool hideArrowRight = false;
  bool isLoading = false;
  bool isBookmarked = false;

  String title = "";
  bool titleVisible = false;

  void hideBtns() {
    if (_seasonScrollController.offset ==
        _seasonScrollController.position.minScrollExtent) {
      setState(() {
        hideArrowLeft = true;
        hideArrowRight = false;
      });
    } else if (_seasonScrollController.offset ==
        _seasonScrollController.position.maxScrollExtent) {
      setState(() {
        hideArrowRight = true;
        hideArrowLeft = false;
      });
    }
  }

  void _onSeasonScroll() {
    // Update the visibility of arrow buttons based on scroll position
    setState(() {
      hideArrowLeft = _seasonScrollController.offset <=
          _seasonScrollController.position.minScrollExtent;
      hideArrowRight = _seasonScrollController.offset >=
          _seasonScrollController.position.maxScrollExtent;
    });
  }

  void _onEpisodeScroll() {
    setState(() {
      if (_episodeScrollController.offset ==
          _episodeScrollController.position.maxScrollExtent) {
        _episodeScrollController.position.didEndScroll();
        _screenScrollController.position.didStartScroll();
      } else if (_episodeScrollController.offset ==
          _episodeScrollController.position.minScrollExtent) {
        _episodeScrollController.position.didEndScroll();
        _screenScrollController.position.didStartScroll();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchLanguage();
    checkIfBookmarked();
    _episodeScrollController = ScrollController();
    _seasonScrollController = ScrollController();
    _screenScrollController = ScrollController();
    _seasonScrollController.addListener(_onSeasonScroll);
    _episodeScrollController.addListener(_onEpisodeScroll);
    _screenScrollController.addListener(_printPosition);
  }

  void _printPosition() {
    print('Scroll position: ${_screenScrollController.position.pixels}');
    if (_screenScrollController.position.pixels > 650) {
      setState(() {
        titleVisible = true;
      });
    } else {
      setState(() {
        titleVisible = false;
      });
    }
  }

  Future<void> checkIfBookmarked() async {
    bool result = await prefs.isOnMyList(widget.movieId, "Movie");
    setState(() {
      isBookmarked = result;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _episodeScrollController.dispose();
    _seasonScrollController.dispose();
    _screenScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    print(titleVisible.toString());
    return Scaffold(
      // appBar: AppBar(
      //   leading: SizedBox(),
      //   toolbarHeight: height * 0.08,
      //   scrolledUnderElevation: 0,
      //   surfaceTintColor: Colors.transparent,
      //   backgroundColor: Colors.transparent,
      // ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.08),
        child: Container(
          child: AppBar(
            toolbarHeight: height * 0.08,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            leading: Container(
              margin: const EdgeInsets.only(left: 15),
              padding: const EdgeInsets.only(left: 4),
              decoration: BoxDecoration(
                  border: Border.all(color: whiteColor, width: 2),
                  shape: BoxShape.circle),
              child: IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: whiteColor,
                  size: 20,
                ),
              ),
            ),
            title: Visibility(
              visible: titleVisible,
              child: Text(
                title,
                style: TextStyle(
                    color: whiteColor,
                    fontSize: fontSize24,
                    fontWeight: FontWeight.w700),
              ),
            ),
            centerTitle: true,
            actions: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                    border: Border.all(color: whiteColor, width: 2),
                    shape: BoxShape.circle),
                child: IconButton(
                  padding: const EdgeInsets.all(8),
                  onPressed: () async {
                    setState(() {
                      isBookmarked = !isBookmarked;
                    });
                    if (isBookmarked) {
                      await prefs.addToMyList(widget.movieId, "Movie");
                      BlocProvider.of<FavoritesBloc>(context).add(
                          PostFavoritesEvent(Favorites(
                              content_type: "MOVIE",
                              content_id: widget.movieId)));
                    } else {
                      prefs.removeFromMyList(widget.movieId);
                      BlocProvider.of<FavoritesBloc>(context).add(
                          DelFavoritesEvent(Favorites(
                              content_type: "MOVIE",
                              content_id: widget.movieId)));
                    }
                    BlocConsumer<FavoritesBloc, FavoritesState>(
                      listener: (context, state) {
                        if (state is FavoritesSuccessfulState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Movie added to my List!"),
                              backgroundColor:
                                  Colors.green, // Adjust color as needed
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return Container();
                      },
                    );
                  },
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.add,
                    color: whiteColor,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                    border: Border.all(color: whiteColor, width: 2),
                    shape: BoxShape.circle),
                child: IconButton(
                  padding: const EdgeInsets.all(8),
                  onPressed: () {},
                  icon: Icon(
                    Icons.share,
                    color: whiteColor,
                    size: 20,
                  ),
                ),
              )
            ],
          ),
        ).asGlass(enabled: titleVisible, tintColor: Colors.transparent),
      ),
      extendBodyBehindAppBar: true,
      body: BlocConsumer<MoviesBloc, MoviesState>(
        listener: (context, state) {},
        builder: (context, state) {
          print(state);
          if (state is MoviesLoadingState) {
            isLoading = true;
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (state is MoviesSuccessfulState) {
            isLoading = false;

            return buildInitialInput(movieInfo: state.movies);
          } else if (state is MoviesFailureState) {
            isLoading = false;
            return errorFlushbar(context: context, message: state.error);
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildInitialInput({required Movies movieInfo}) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var trailer = [];
    trailer.add(movieInfo.movie.attachments.movie_trailer.toString());
    trailer.add(movieInfo.movie.attachments.movie_trailer_thumbnail.toString());

    title = getLanguageValueByKey(movieInfo.movie.title, language);
    return SingleChildScrollView(
      controller: _screenScrollController,
      child: Column(
        children: [
          SizedBox(
            height: height * 0.7,
            width: width,
            child: Stack(children: [
              Container(
                height: height * 0.7,
                width: width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(movieInfo
                            .movie.attachments.movie_thumbnail
                            .toString()),
                        fit: BoxFit.fill)),
              ),
              Container(
                height: height * 0.7,
                width: width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                      blackColor.withOpacity(0),
                      Color(int.parse(
                          "${movieInfo.movie.color}".replaceAll("#", "0xFF")))
                    ])),
              ),
              Positioned(
                  bottom: 220,
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
                          "MOVIE",
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: fontSize15,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  )),
              Positioned(
                  bottom: 100,
                  child: SizedBox(
                    width: width,
                    child: Center(
                      child: Image.network(
                          movieInfo.movie.attachments.movie_title.toString(),
                          height: 120,
                          width: width * 0.8),
                    ),
                  )),
              Positioned(
                bottom: 80,
                child: SizedBox(
                  width: width,
                  child: Center(
                    child: buildMovieInfo(
                        15,
                        getLanguageValueByKey(
                            movieInfo.genres[0].name, language),
                        convertToMinutes(movieInfo.movie.duration).toString() +
                            " min",
                        formatDate(movieInfo.movie.release_date)),
                  ),
                ),
              ),
              Positioned(
                  bottom: 20,
                  child: SizedBox(
                    width: width,
                    child: Center(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(whiteColor)),
                          onPressed: () {
                            PersistentNavBarNavigator.pushNewScreen(context,
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
                                  color: blackColor,
                                  fontSize: fontSize15,
                                  fontWeight: FontWeight.w500),
                            ),
                          )),
                    ),
                  )),
            ]),
          ),
          SizedBox(
            height: 225,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    width: width,
                    height: 225,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [
                          Color(int.parse("${movieInfo.movie.color}"
                                  .replaceAll("#", "0xFF")))
                              .withOpacity(0.6),
                          blackColor,
                        ],
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 27, top: 42),
                    itemCount: trailer.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              movies[index]['title'],
                              style: TextStyle(
                                  color: whiteColor,
                                  fontSize: fontSize18,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Stack(
                            children: [
                              Container(
                                width: 242,
                                height: 139,
                                margin: const EdgeInsets.only(right: 17),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    color: versionTxtColor.withOpacity(0.6)),
                              ),
                              Container(
                                width: 242,
                                height: 139,
                                margin: const EdgeInsets.only(right: 17),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    image: DecorationImage(
                                        image: NetworkImage(trailer[index]),
                                        fit: BoxFit.cover)),
                              ),
                              Positioned(
                                bottom: 8,
                                left: 12,
                                child: Container(
                                  width: 23,
                                  height: 23,
                                  decoration: BoxDecoration(
                                      color: playBtnBgColor,
                                      shape: BoxShape.circle),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: whiteColor,
                                    size: 10,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      );
                    })
              ],
            ),
          ),
          Visibility(
              visible: movieInfo.ads.poster.isNotEmpty,
              child: Column(
                children: [
                  const SizedBox(
                    height: 65,
                  ),
                  Container(
                    height: 265,
                    width: 376,
                    margin: const EdgeInsets.symmetric(horizontal: 27),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      image: DecorationImage(
                          image: NetworkImage(movieInfo.ads.poster),
                          fit: BoxFit.cover),
                    ),
                  ),
                ],
              )),
          const SizedBox(
            height: 44,
          ),
          Container(
            height: 950,
            width: width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color(int.parse(
                      "${movieInfo.movie.color}".replaceAll("#", "0xFF"))),
                  Color(int.parse(
                          "${movieInfo.movie.color}".replaceAll("#", "0xFF")))
                      .withOpacity(0),
                ])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(33, 30, 33, 15),
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
                      Text(
                        getLanguageValueByKey(
                            movieInfo.movie.description, language),
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: fontSize15,
                            fontWeight: FontWeight.w300),
                        softWrap: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 23),
                        child: buildTextListColumn(
                            "Genre",
                            Wrap(
                              direction: Axis.horizontal,
                              spacing: 8.0, // Add spacing between items
                              children: List.generate(
                                  movieInfo.movie.genres.length, (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0), // Add spacing between items
                                  child: Text(
                                    "${getLanguageValueByKey(movieInfo.movie.genres[index].name, language)}${index == movieInfo.movie.genres.length - 1 ? "" : " | "}",
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: fontSize15,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    softWrap: true, // Enable soft wrapping
                                    overflow: TextOverflow.visible,
                                  ),
                                );
                              }),
                            )),
                      ),
                      buildTextColumn(
                          "Released", formatDate(movieInfo.movie.release_date)),
                      buildTextColumn(
                          "Duration",
                          convertToMinutes(movieInfo.movie.duration)
                                  .toString() +
                              " min"),
                      buildTextColumn("Director", "Yohannis Girma"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, bottom: 15),
                  child: Text(
                    'Cast',
                    style: TextStyle(
                        color: whiteColor,
                        fontSize: fontSize20,
                        fontWeight: FontWeight.w900),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: height < 720 ? 170 : 190,
                  width: width,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 5, right: 20),
                      itemCount: movieInfo.casts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: height < 720 ? 8 : 16),
                          child: GestureDetector(
                            onTap: () {
                              BlocProvider.of<CastBloc>(context)
                                  .add(GetCastEvent(movieInfo.casts[index].id));
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CastScreen(
                                        role: movieInfo.casts[index].role.role,
                                      )));
                            },
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: height < 720 ? 95 : 115,
                                      width: height < 720 ? 95 : 115,
                                      margin: const EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              versionTxtColor.withOpacity(0.6)),
                                    ),
                                    Container(
                                      height: height < 720 ? 95 : 115,
                                      width: height < 720 ? 95 : 115,
                                      margin: const EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: NetworkImage(movieInfo
                                                  .casts[index]
                                                  .attachments
                                                  .cast_avatar
                                                  .toString()),
                                              fit: BoxFit.cover)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    getLanguageValueByKey(
                                        movieInfo.casts[index].name, language),
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontSize: fontSize15,
                                        fontWeight: FontWeight.w500),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                Expanded(
                  child: buildHorizontalList(
                      title: "More Like This",
                      dataList: movieInfo.related,
                      onInteraction: () {}),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildHorizontalList(
      {required String title,
      required List<Related> dataList,
      required VoidCallback onInteraction}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24),
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
            height: 200,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 24),
                itemCount: dataList.length,
                itemBuilder: (BuildContext context, int index) {
                  var tileImage =
                      dataList[index].attachments.movie_thumbnail.toString();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<MoviesBloc>(context)
                              .add(GetMoviesEvent(dataList[index].id));
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MoviesScreen(
                                    movieId: dataList[index].id,
                                  )));
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: height < 720 ? 210 : 270,
                              height: height < 720 ? 120 : 162,
                              margin: const EdgeInsets.only(right: 21),
                              decoration: BoxDecoration(
                                  color: versionTxtColor.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(22)),
                            ),
                            Container(
                              width: height < 720 ? 210 : 270,
                              height: height < 720 ? 120 : 162,
                              margin: const EdgeInsets.only(right: 21),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(tileImage),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(22)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 11,
                      ),
                      Text(
                        getLanguageValueByKey(dataList[index].title, language),
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
      ),
    );
  }
}
