import 'package:avetol/core/constants.dart';
import 'package:avetol/core/services/sharedPreferences.dart';
import 'package:avetol/features/common/errorFlushbar.dart';
import 'package:avetol/features/common/formatDate.dart';
import 'package:avetol/features/common/getLanguageValueByKey.dart';
import 'package:avetol/features/home/data/models/favorites.dart';
import 'package:avetol/features/home/data/models/related.dart';
import 'package:avetol/features/home/data/models/tvShow.dart';
import 'package:avetol/features/home/presentation/blocs/home_bloc.dart';
import 'package:avetol/features/home/presentation/blocs/home_event.dart';
import 'package:avetol/features/home/presentation/blocs/home_state.dart';
import 'package:avetol/features/home/presentation/screens/castScreen.dart';
import 'package:avetol/features/home/presentation/screens/episodesListWidget.dart';
import 'package:avetol/features/home/presentation/widgets/buildMovieInfo.dart';
import 'package:avetol/features/home/presentation/widgets/buildTextColumn.dart';
import 'package:avetol/features/home/presentation/widgets/buildTextListColumn.dart';
import 'package:avetol/features/videoPlayer.dart/landscapePlayer/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glass/glass.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class TvShowScreen extends StatefulWidget {
  final String tvShowId;
  const TvShowScreen({required this.tvShowId, super.key});

  @override
  State<TvShowScreen> createState() => _TvShowScreenState();
}

class _TvShowScreenState extends State<TvShowScreen> {
  final prefs = PrefService();
  var language;
  void fetchLanguage() async {
    language = await prefs.readLanguage();
  }

  late ScrollController _episodeScrollController;
  late ScrollController _seasonScrollController;
  late ScrollController _screenScrollController;
  int selectedSeason = 0;
  bool hideArrowLeft = true;
  bool hideArrowRight = false;

  String title = "";
  bool titleVisible = false;
  bool isBookmarked = false;
  bool isEpisodesLoaded = false;

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
        print("Reach Bottom of the Episodes Section");
      } else if (_episodeScrollController.offset ==
          _episodeScrollController.position.minScrollExtent) {
        _episodeScrollController.position.didEndScroll();
        _screenScrollController.position.didStartScroll();
        print("Reach Top of the Episodes Section");
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
    bool result = await prefs.isOnMyList(widget.tvShowId, "TVSHOW");
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
                      prefs.removeFromMyList(widget.tvShowId);
                      BlocProvider.of<FavoritesBloc>(context).add(
                          PostFavoritesEvent(Favorites(
                              content_type: "TVSHOW",
                              content_id: widget.tvShowId)));
                    } else {
                      await prefs.addToMyList(widget.tvShowId, "Movie");
                      BlocProvider.of<FavoritesBloc>(context).add(
                          DelFavoritesEvent(Favorites(
                              content_type: "TVSHOW",
                              content_id: widget.tvShowId)));
                    }

                    BlocConsumer<FavoritesBloc, FavoritesState>(
                      listener: (context, state) {
                        if (state is FavoritesSuccessfulState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("TvShow added to my List!"),
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
                margin: const EdgeInsets.only(right: 5),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                    border: Border.all(color: whiteColor, width: 2),
                    shape: BoxShape.circle),
                child: IconButton(
                  padding: const EdgeInsets.all(8),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.share,
                    color: whiteColor,
                    size: 26,
                  ),
                ),
              )
            ],
          ),
        ).asGlass(enabled: titleVisible, tintColor: Colors.transparent),
      ),

      extendBodyBehindAppBar: true,
      body: BlocConsumer<TvShowBloc, TvShowState>(
        listener: (context, state) {},
        builder: (context, state) {
          print(state);
          if (state is TvShowLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (state is TvShowSuccessfulState) {
            if (!isEpisodesLoaded) {
              BlocProvider.of<EpisodesBloc>(context).add(GetEpisodesBySeasonId(
                  state.tvShow.tvshow.id, state.tvShow.seasons[0].id));
              isEpisodesLoaded = true;
            }
            return buildInitialInput(tvShow: state.tvShow);
          } else if (state is TvShowFailureState) {
            return errorFlushbar(context: context, message: state.error);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildInitialInput({required TvShow tvShow}) {
    String hexColor = tvShow.tvshow.color;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    title = getLanguageValueByKey(tvShow.tvshow.title, language);
    return SingleChildScrollView(
      controller: _screenScrollController,
      child: Column(
        children: [
          SizedBox(
            height: height < 700 ? height * 0.8 : height * 0.7,
            width: width,
            child: Stack(children: [
              Container(
                height: height < 700 ? height * 0.8 : height * 0.7,
                width: width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(tvShow
                            .tvshow.attachments.tv_show_thumbnail
                            .toString()),
                        fit: BoxFit.fill)),
              ),
              Container(
                height: height < 700 ? height * 0.8 : height * 0.7,
                width: width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                      blackColor.withOpacity(0),
                      Color(int.parse(hexColor.replaceAll("#", "0xFF")))
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
                          "SERIES",
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
                          tvShow.tvshow.attachments.tv_show_title.toString(),
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
                            tvShow.tvshow.genres[0].name, language),
                        "${tvShow.seasons.length + 1} Seasons",
                        formatDate(tvShow.tvshow.release_date)),
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
                              "Watch Now S1 EP1",
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
            height: height * 0.085,
            child: Stack(
              children: [
                Container(
                  height: height * 0.085,
                  width: width,
                  color: Color(int.parse(hexColor.replaceAll("#", "0xFF")))
                      .withOpacity(0.6),
                  child: ListView.builder(
                      controller: _seasonScrollController,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 28),
                      itemCount: tvShow.seasons.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSeason = index;
                              print(
                                tvShow.tvshow.id,
                              );
                              print(tvShow.seasons[index].id);
                              BlocProvider.of<EpisodesBloc>(context).add(
                                  GetEpisodesBySeasonId(tvShow.tvshow.id,
                                      tvShow.seasons[index].id));
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 28),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox.shrink(),
                                  Text(
                                    "Season ${tvShow.seasons[index].season_number}",
                                    style: TextStyle(
                                        color: selectedSeason == index
                                            ? whiteColor
                                            : whiteColor.withOpacity(0.25),
                                        fontSize: fontSize16,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  selectedSeason == index
                                      ? Container(
                                          height: 6,
                                          width: 80,
                                          color: Color(int.parse(hexColor
                                              .replaceAll("#", "0xFF"))))
                                      : const SizedBox.shrink(),
                                ]),
                          ),
                        );
                      }),
                ),
                hideArrowRight
                    ? const SizedBox.shrink()
                    : Positioned(
                        top: 5,
                        bottom: 5,
                        right: 5,
                        child: IconButton(
                            color: blackColor.withOpacity(0.4),
                            onPressed: () {
                              _seasonScrollController.animateTo(
                                  _seasonScrollController.offset + 110,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.bounceIn);
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: whiteColor,
                              size: 20,
                            ))),
                hideArrowLeft
                    ? const SizedBox.shrink()
                    : Positioned(
                        top: 5,
                        bottom: 5,
                        left: 5,
                        child: IconButton(
                            color: blackColor.withOpacity(0.4),
                            onPressed: () {
                              _seasonScrollController.animateTo(
                                  _seasonScrollController.offset - 110,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.bounceIn);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: whiteColor,
                              size: 20,
                            )))
              ],
            ),
          ),
          EpisodesListWidget(
              hexColor: hexColor,
              episodesScrollController: _episodeScrollController),
          Container(
            height: 300,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  // image: AssetImage(tvShow.ads[0].poster.toString()),
                  image: AssetImage("images/posters/seriesAd.jpg"),
                  fit: BoxFit.cover),
            ),
          ),
          // const SizedBox(
          //   height: 44,
          // ),
          Container(
            height: 950,
            width: width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color(int.parse(hexColor.replaceAll("#", "0xFF"))),
                  Color(int.parse(hexColor.replaceAll("#", "0xFF")))
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
                            tvShow.tvshow.description, language),
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
                              spacing: 8.0,
                              children: List.generate(
                                  tvShow.tvshow.genres.length, (index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    "${getLanguageValueByKey(tvShow.tvshow.genres[index].name, language)}${index == tvShow.tvshow.genres.length - 1 ? "" : " |"}",
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: fontSize15,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                );
                              }),
                            )),
                      ),
                      buildTextColumn(
                          "Released", formatDate(tvShow.tvshow.release_date)),
                      buildTextColumn("Duration",
                          "${tvShow.tvshow.seasons_count} Seasons | ${tvShow.tvshow.episodes_count} Episodes"),
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
                      itemCount: tvShow.casts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: height < 720 ? 8 : 16),
                          child: GestureDetector(
                            onTap: () {
                              BlocProvider.of<CastBloc>(context)
                                  .add(GetCastEvent(tvShow.casts[index].id));
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CastScreen(
                                        role: tvShow.casts[index].role.role,
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
                                              image: NetworkImage(tvShow
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
                                        tvShow.casts[index].name, language),
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
                      dataList: tvShow.related,
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
                  var tileImage = dataList[index].attachments.tv_show_thumbnail;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<TvShowBloc>(context)
                              .add(GetTvShowEvent(dataList[index].id));
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TvShowScreen(
                                    tvShowId: dataList[index].id,
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
                                      image: NetworkImage(tileImage.toString()),
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
