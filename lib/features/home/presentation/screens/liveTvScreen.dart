import 'package:avetol/core/constants.dart';
import 'package:avetol/features/videoPlayer.dart/orientationPlayer/controls.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class LiveTvScreen extends StatefulWidget {
  final String? videoUrl;
  const LiveTvScreen({this.videoUrl, super.key});

  @override
  State<LiveTvScreen> createState() => _LiveTvScreenState();
}

class _LiveTvScreenState extends State<LiveTvScreen> {
  late FlickManager flickManager;
  GlobalKey<_LiveTvScreenState> flickVideoPlayerKey = GlobalKey();

  String activeChannelImage = "images/posters/ebsLogo.jpg";
  String activeChannelTitle = "EBS TV";
  String activeChannelDesc = "Ethiopian Broadcasting Service";

  final channelsImages = [
    "images/posters/ebs.jpg",
    "images/posters/kana.jpg",
  ];
  final List<Map<String, dynamic>> forYou = [
    {
      'title': 'EBS TV',
      'image': 'images/posters/ebs.jpg',
    },
    {
      'title': 'Fana Tv',
      'image': 'images/posters/kana.jpg',
    },
  ];
  final List<Map<String, dynamic>> popular = [
    {
      'title': 'Kana Tv',
      'image': 'images/posters/kana.jpg',
    },
    {
      'title': 'EBS TV',
      'image': 'images/posters/ebs.jpg',
    },
    {
      'title': 'Fana Tv',
      'image': 'images/posters/ebs.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(Uri.parse(
            "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4")));
  }

  @override
  void dispose() {
    super.dispose();
    flickManager.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height < 850 ? 70 : 90,
        title: Row(
          children: [
            Text(
              "Live",
              style: TextStyle(
                  color: whiteColor,
                  fontSize: height > 850 ? fontSize33 : fontSize28,
                  fontWeight: FontWeight.w900),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              height: 20,
              width: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: live,
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 240,
            child: FlickVideoPlayer(
              key: flickVideoPlayerKey,
              flickManager: flickManager,
              preferredDeviceOrientationFullscreen: [
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ],
              flickVideoWithControls: FlickVideoWithControls(
                controls: CustomOrientationControls(),
              ),
              flickVideoWithControlsFullscreen: FlickVideoWithControls(
                videoFit: BoxFit.fitWidth,
                controls: CustomOrientationControls(),
              ),
            ),
          ),
          Stack(
            children: [
              Container(
                height: 81,
                width: width,
                color: liveDescriptionBg,
              ),
              Positioned(
                top: 16,
                left: 25,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage(
                                activeChannelImage,
                              ),
                              fit: BoxFit.fill)),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          activeChannelTitle,
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: fontSize16,
                              fontWeight: FontWeight.w900),
                        ),
                        Text(
                          activeChannelDesc,
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: fontSize12,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildHorizontalList(title: "For you", dataList: forYou),
                  buildHorizontalList(
                      title: "Popular Channels", dataList: popular),
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 7,
                                mainAxisSpacing: 6),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 123,
                                  width: 183,
                                  decoration: BoxDecoration(
                                      color: indicatorColor,
                                      borderRadius: BorderRadius.circular(19)),
                                ),
                                const SizedBox(
                                  height: 11,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Text(
                                    "EBS TV",
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontSize: fontSize16,
                                        fontWeight: FontWeight.w600),
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
          ),
        ],
      ),
    );
  }

  Widget buildHorizontalList({
    required String title,
    required List<Map<String, dynamic>> dataList,
  }) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 30),
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
            height: 160,
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
                        onTap: () {
                          setState(() {
                            activeChannelImage = tileImage;
                            activeChannelTitle = dataList[index]['title'];
                            activeChannelDesc = dataList[index]['title'];
                          });
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: 212,
                              height: 115,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(
                          dataList[index]['title'],
                          style: TextStyle(
                              color: whiteColor,
                              fontSize: fontSize16,
                              fontWeight: FontWeight.w600),
                        ),
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
