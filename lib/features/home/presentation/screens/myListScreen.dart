import 'package:avetol/core/constants.dart';
import 'package:avetol/features/common/formatDate.dart';
import 'package:avetol/features/home/data/models/movieModel.dart';
import 'package:avetol/features/home/data/models/profile.dart';
import 'package:avetol/features/home/data/models/tvShowModel.dart';
import 'package:avetol/features/home/presentation/blocs/home_bloc.dart';
import 'package:avetol/features/home/presentation/blocs/home_event.dart';
import 'package:avetol/features/home/presentation/screens/moviesScreen.dart';
import 'package:avetol/features/home/presentation/screens/tvShowScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyListScreen extends StatefulWidget {
  final Profile profile;
  MyListScreen({required this.profile, super.key});

  @override
  State<MyListScreen> createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen> {
  var listLength;
  int selectedIndex = 0;
  List<String> filterContent = ["All", "Movies", "TvShow"];
  @override
  Widget build(BuildContext context) {
    final Profile profile = widget.profile;
    List<MovieModel> movieList = profile.myList
        .where((item) => item is MovieModel)
        .cast<MovieModel>()
        .toList();
    List<TvShowModel> tvShowList = profile.myList
        .where((item) => item is TvShowModel)
        .cast<TvShowModel>()
        .toList();

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List combinedList = [...movieList, ...tvShowList];
    if (selectedIndex == 0) {
      listLength = combinedList.length;
    } else if (selectedIndex == 1) {
      listLength = movieList.length;
    } else if (selectedIndex == 2) {
      listLength = tvShowList.length;
    }
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * 0.08,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: whiteColor,
              size: 24,
            )),
        title: Text(
          'My List',
          style: TextStyle(
              color: whiteColor,
              fontSize: fontSize30,
              fontWeight: FontWeight.w900),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 45,
              width: width,
              child: ListView.builder(
                  padding: const EdgeInsets.only(left: 27),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: filterContent.length,
                  itemBuilder: ((context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        decoration: BoxDecoration(
                            color: selectedIndex == index
                                ? whiteColor.withOpacity(0.5)
                                : blackColor.withOpacity(0.6),
                            border: selectedIndex == index
                                ? Border.all(color: whiteColor, width: 1)
                                : Border.all(color: whiteColor, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            filterContent[index],
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: fontSize18,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  })),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 30),
                //   child: Text(
                //     'Movies',
                //     style: TextStyle(
                //         color: whiteColor,
                //         fontSize: fontSize28,
                //         fontWeight: FontWeight.w600),
                //   ),
                // ),
                SizedBox(
                  width: width,
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(27, 25, 27, 10),
                      itemCount: listLength,
                      itemBuilder: (context, index) {
                        var item = combinedList[index];
                        if (selectedIndex == 0) {
                          item = combinedList[index];
                        } else if (selectedIndex == 1) {
                          item = movieList[index];
                        } else if (selectedIndex == 2) {
                          item = tvShowList[index];
                        } else {
                          item = combinedList[index];
                        }
                        bool isMovie = item is MovieModel;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 26),
                          child: GestureDetector(
                            onTap: () {
                              if (isMovie) {
                                BlocProvider.of<MoviesBloc>(context)
                                    .add(GetMoviesEvent(item.id));
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MoviesScreen(
                                          movieId: item.id,
                                        )));
                              } else {
                                BlocProvider.of<TvShowBloc>(context)
                                    .add(GetTvShowEvent(item.id));
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        TvShowScreen(tvShowId: item.id)));
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 376,
                                  height: 221,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      image: DecorationImage(
                                          image: NetworkImage(isMovie
                                              ? item.attachments.movie_thumbnail
                                                  .toString()
                                              : item
                                                  .attachments.tv_show_thumbnail
                                                  .toString()),
                                          fit: BoxFit.cover)),
                                ),
                                Text(
                                  item.title[0].value,
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontSize: fontSize20,
                                      fontWeight: FontWeight.w900),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                                isMovie
                                    ? Text(
                                        "${convertToMinutes(item.duration).toString()}  mins",
                                        style: TextStyle(
                                            color: durationTxtColor,
                                            fontSize: fontSize15,
                                            fontWeight: FontWeight.w500),
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                      )
                                    : Text(
                                        "${item.seasons_count} Seasons | ${item.episodes_count} Episodes",
                                        style: TextStyle(
                                            color: durationTxtColor,
                                            fontSize: fontSize15,
                                            fontWeight: FontWeight.w500),
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                      )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.only(left: 30),
            //       child: Text(
            //         "TvShow/Series",
            //         style: TextStyle(
            //             color: whiteColor,
            //             fontSize: fontSize28,
            //             fontWeight: FontWeight.w600),
            //       ),
            //     ),
            //     SizedBox(
            //       width: width,
            //       child: ListView.builder(
            //           shrinkWrap: true,
            //           physics: const NeverScrollableScrollPhysics(),
            //           padding: const EdgeInsets.fromLTRB(27, 25, 27, 30),
            //           itemCount: tvShowList.length,
            //           itemBuilder: (context, index) {
            //             var item = tvShowList[index];

            //             return Padding(
            //               padding: const EdgeInsets.only(bottom: 26),
            //               child: InkWell(
            //                 onTap: () {},
            //                 child: Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Stack(
            //                       children: [
            //                         Container(
            //                           width: 376,
            //                           height: 221,
            //                           decoration: BoxDecoration(
            //                               borderRadius:
            //                                   BorderRadius.circular(22),
            //                               color:
            //                                   versionTxtColor.withOpacity(0.6)),
            //                         ),
            //                         Container(
            //                           width: 376,
            //                           height: 221,
            //                           decoration: BoxDecoration(
            //                               borderRadius:
            //                                   BorderRadius.circular(22),
            //                               image: DecorationImage(
            //                                   image: NetworkImage(item
            //                                       .attachments.tv_show_thumbnail
            //                                       .toString()),
            //                                   fit: BoxFit.cover)),
            //                         ),
            //                       ],
            //                     ),
            //                     Text(
            //                       item.title[0].value,
            //                       style: TextStyle(
            //                           color: whiteColor,
            //                           fontSize: fontSize20,
            //                           fontWeight: FontWeight.w900),
            //                       softWrap: true,
            //                       overflow: TextOverflow.visible,
            //                     ),
            //                     Text(
            //                       "${item.seasons_count} Seasons | ${item.episodes_count} Episodes",
            //                       style: TextStyle(
            //                           color: durationTxtColor,
            //                           fontSize: fontSize15,
            //                           fontWeight: FontWeight.w500),
            //                       softWrap: true,
            //                       overflow: TextOverflow.visible,
            //                     )
            //                   ],
            //                 ),
            //               ),
            //             );
            //           }),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
