import 'package:avetol/core/constants.dart';
import 'package:avetol/core/services/sharedPreferences.dart';
import 'package:avetol/features/home/presentation/widgets/buildMovieInfo.dart';
import 'package:avetol/features/home/presentation/widgets/buildTextColumn.dart';
import 'package:flutter/material.dart';

class SeriesMovieScreen extends StatefulWidget {
  const SeriesMovieScreen({super.key});

  @override
  State<SeriesMovieScreen> createState() => _SeriesMovieScreenState();
}

class _SeriesMovieScreenState extends State<SeriesMovieScreen> {
  final prefs = PrefService();
  var language;
  void fetchLanguage() async {
    language = await prefs.readLanguage();
  }

  final List<Map<String, dynamic>> trailer = [
    {
      'image': "images/posters/sweetness.jpg",
      'title': "Sweetness in the Belly",
    },
    {
      'image': "images/posters/kemis.jpg",
      'title': "Kemis Yelebesku Let",
    },
  ];

  final List<Map<String, dynamic>> series = [
    {
      'image': "images/posters/episode1.jpg",
      'title': "The Wedding",
      'episode': "Episode 1",
      'duration': '30:32'
    },
    {
      'image': "images/posters/episode2.jpg",
      'title': "Lost in the sea",
      'episode': "Episode 2",
      'duration': '30:32'
    },
    {
      'image': "images/posters/episode3.jpg",
      'title': "Outcast",
      'episode': "Episode 3",
      'duration': '30:32'
    },
    {
      'image': "images/posters/episode4.jpg",
      'title': "Serving the life of deaths",
      'episode': "Episode 4",
      'duration': '30:32'
    },
    {
      'image': "images/posters/episode5.jpg",
      'title': "Accepted",
      'episode': "Episode 5",
      'duration': '30:32'
    },
    {
      'image': "images/posters/episode6.jpg",
      'title': "The final say",
      'episode': "Episode 6",
      'duration': '30:32'
    },
  ];

  late ScrollController _episodeScrollController;
  late ScrollController _seasonScrollController;
  late ScrollController _screenScrollController;
  int selectedSeason = 0;
  bool hideArrowLeft = true;
  bool hideArrowRight = false;

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
    _episodeScrollController = ScrollController();
    _seasonScrollController = ScrollController();
    _screenScrollController = ScrollController();
    _seasonScrollController.addListener(_onSeasonScroll);
    _episodeScrollController.addListener(_onEpisodeScroll);
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
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * 0.08,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
              border: Border.all(color: whiteColor, width: 2),
              shape: BoxShape.circle),
          child: Center(
            child: IconButton(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: whiteColor,
                size: 26,
              ),
            ),
          ),
        ),
        actions: [
          // IconButton(
          //   padding: EdgeInsets.all(8),
          //   onPressed: () {},
          //   icon: Icon(
          //     Icons.add,
          //     color: whiteColor,
          //   ),
          //   style: ButtonStyle(
          //       backgroundColor: MaterialStateProperty.all(appbarBtnColor)),
          // ),
          IconButton(
            padding: const EdgeInsets.all(8),
            onPressed: () {},
            icon: const Icon(
              Icons.share,
              color: whiteColor,
              size: 26,
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(appbarBtnColor)),
          ),
          const SizedBox(
            width: 16,
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
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
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/posters/sweetness2.jpg'),
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
                        const Color(0xFF8A5C00)
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
                          Image.asset("images/logoSmall.png"),
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
                    bottom: 85,
                    child: SizedBox(
                      width: width,
                      child: Center(
                        child: Image.asset('images/posters/sweetnessTitle.png',
                            height: 140, width: width * 0.83),
                      ),
                    )),
                Positioned(
                  bottom: 80,
                  child: SizedBox(
                    width: width,
                    child: Center(
                      child: buildMovieInfo(15, "Drama", "2 Seasons", "2023"),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 20,
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
                                              const Color(0xFF000000)
                                                  .withOpacity(0.4))),
                                  onPressed: () {},
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 16),
                                    child: Text(
                                      "Watch Now S1 EP1",
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
                                              const Color(0xFF000000)
                                                  .withOpacity(0.4))),
                                  onPressed: () {},
                                  icon: const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.add,
                                      color: whiteColor,
                                    ),
                                  ))
                            ]),
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
                    color: const Color(0xFF563902),
                    child: ListView.builder(
                        controller: _seasonScrollController,
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 28),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedSeason = index;
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
                                      "Season ${index + 1}",
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
                                            color: const Color(0xFF865A02))
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
            SizedBox(
              height: 550,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      width: width,
                      height: 400,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.center,
                          colors: [
                            const Color(0xFF875A01).withOpacity(0.4),
                            blackColor,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: ListView.builder(
                        controller: _episodeScrollController,
                        itemCount: series.length,
                        itemBuilder: (context, index) {
                          var seriesImages = series[index]['image'];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 27, vertical: 5),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 119,
                                  width: 182,
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xFF875A01)
                                                .withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(22),
                                            image: DecorationImage(
                                                image: AssetImage(seriesImages),
                                                fit: BoxFit.cover)),
                                        height: 119,
                                        width: 192,
                                      ),
                                      Positioned(
                                        left: 12,
                                        bottom: 6,
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
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: width * 0.3,
                                      child: Text(
                                        series[index]['title'],
                                        style: TextStyle(
                                            color: whiteColor,
                                            fontSize: fontSize18,
                                            fontWeight: FontWeight.w900),
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                      ),
                                    ),
                                    Text(
                                      series[index]['episode'],
                                      style: TextStyle(
                                          color: episodesTxtColor,
                                          fontSize: fontSize16,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      series[index]['duration'],
                                      style: TextStyle(
                                          color: durationTxtColor,
                                          fontSize: fontSize14,
                                          fontWeight: FontWeight.w300),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: buildHorizontalList(
                title: "Trailers",
                dataList: trailer,
                onInteraction: () {},
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              height: 300,
              width: width,
              decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage("images/posters/seriesAd.jpg"),
                    fit: BoxFit.cover),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              height: 980,
              width: width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    const Color(0xFF875B02),
                    const Color(0xFF875B02).withOpacity(0),
                  ])),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 33, vertical: 30),
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
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur tincidunt tellus id nulla tempor, sed congue metus dignissim. Pellentesque eget orci maximus, varius tellus vitae, vulputate arcu. Aenean ultrices at tortor nec gravida. Aliquam eget augue nulla. Donec sit amet viverra massa. Maecenas ac sapien lacinia,",
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: fontSize15,
                              fontWeight: FontWeight.w300),
                          softWrap: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 23),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildTextColumn("Genre", "Drama | Biography"),
                              buildTextColumn("Released", "2023"),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                        buildTextColumn("Duration", "6 Seasons | 154 Episodes"),
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
                    height: 190,
                    width: width,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 5, right: 20),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: GestureDetector(
                              onTap: () {},
                              child: Column(
                                children: [
                                  Container(
                                    height: 115,
                                    width: 115,
                                    margin: const EdgeInsets.only(bottom: 12),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'images/posters/showEpisode${index + 2}.jpg'),
                                            fit: BoxFit.cover)),
                                  ),
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      'Danayit Mekbib',
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
                        dataList: trailer,
                        onInteraction: () {}),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildHorizontalList(
      {required String title,
      required List<Map<String, dynamic>> dataList,
      required VoidCallback onInteraction}) {
    double width = MediaQuery.of(context).size.width;
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
                  var tileImage = dataList[index]['image'];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: onInteraction,
                        child: Stack(
                          children: [
                            Container(
                              width: 270,
                              height: 162,
                              margin: const EdgeInsets.only(right: 21),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(tileImage),
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
                        dataList[index]['title'],
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
