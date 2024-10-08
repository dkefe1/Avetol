import 'package:avetol/core/constants.dart';
import 'package:avetol/features/common/errorFlushbar.dart';
import 'package:avetol/features/home/presentation/blocs/home_bloc.dart';
import 'package:avetol/features/home/presentation/blocs/home_state.dart';
import 'package:avetol/features/videoPlayer.dart/landscapePlayer/videoPlayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class EpisodesListWidget extends StatelessWidget {
  final String hexColor;
  final ScrollController episodesScrollController;

  const EpisodesListWidget(
      {required this.hexColor, required this.episodesScrollController});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return BlocBuilder<EpisodesBloc, EpisodesState>(
      builder: (context, state) {
        print(state.toString());
        if (state is EpisodesLoadingState) {
          return Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [
                  Color(int.parse(hexColor.replaceAll("#", "0xFF")))
                      .withOpacity(0.4),
                  blackColor,
                ],
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
          );
        } else if (state is EpisodesSuccessfulState) {
          var episodes = state.tvShow.episodes;
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.center,
                colors: [
                  Color(int.parse(hexColor.replaceAll("#", "0xFF")))
                      .withOpacity(0.4),
                  blackColor,
                ],
              ),
            ),
            child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 5, bottom: 15),
                controller: episodesScrollController,
                itemCount: episodes.length,
                itemBuilder: (context, index) {
                  var seriesImages = episodes[index].thumbnail.toString();
                  return GestureDetector(
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreen(context,
                          screen: VideoPlayer(),
                          withNavBar: false,
                          pageTransitionAnimation:
                              PageTransitionAnimation.cupertino);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 27,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 119,
                            width: 192,
                            child: Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    color: versionTxtColor.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  height: 119,
                                  width: 192,
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                      color: const Color(0xFF875A01)
                                          .withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(22),
                                      image: DecorationImage(
                                          image: NetworkImage(seriesImages),
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
                                  episodes[index].title[0].value,
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontSize: fontSize18,
                                      fontWeight: FontWeight.w900),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                              Text(
                                "Episode ${episodes[index].episode_number}",
                                style: TextStyle(
                                    color: episodesTxtColor,
                                    fontSize: fontSize16,
                                    fontWeight: FontWeight.w300),
                              ),
                              Text(
                                episodes[index].duration,
                                style: TextStyle(
                                    color: durationTxtColor,
                                    fontSize: fontSize14,
                                    fontWeight: FontWeight.w300),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          );
        } else if (state is EpisodesFailureState) {
          return errorFlushbar(
              context: context,
              message: "Something went wrong. Please try again!");
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
