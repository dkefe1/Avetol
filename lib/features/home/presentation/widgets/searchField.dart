// import 'dart:async';

// import 'package:avetol/core/constants.dart';
// import 'package:avetol/features/home/data/models/movieModel.dart';
// import 'package:avetol/features/home/presentation/blocs/home_bloc.dart';
// import 'package:avetol/features/home/presentation/blocs/home_event.dart';
// import 'package:avetol/features/home/presentation/blocs/home_state.dart';
// import 'package:avetol/features/home/presentation/screens/moviesScreen.dart';
// import 'package:avetol/features/home/presentation/screens/tvShowScreen.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// List<String> searchedItems = [];
// bool resultsDisplayed = false;
// Widget searchField({
//   required BuildContext context,
//   required TextEditingController controller,
//   required String hintText,
// }) {
//   controller.addListener(() {
//     final query = controller.text;
//     if (query.isNotEmpty) {
//       BlocProvider.of<SearchBloc>(context).add(GetSearchEvent(query));
//     }
//   });

//   return TextFormField(
//     controller: controller,
//     onTap: () {
//       showSearch(
//           context: context,
//           delegate: MySearchDelegate(
//               searchBloc: BlocProvider.of<SearchBloc>(context)));
//     },
//     //These methods won't be triggered because this text form is only used to trigger showSearch
//     //
//     // onFieldSubmitted: (query) async {
//     //   if (query.isNotEmpty) {
//     //     BlocProvider.of<SearchBloc>(context).add(GetSearchEvent(query));
//     //   }
//     // },
//     // onChanged: (query) {
//     //   // triggerSearch(query);
//     //   print("111111111111111111111111111111");
//     // },
//     decoration: InputDecoration(
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(26)),
//         filled: true,
//         fillColor: whiteColor,
//         hintText: hintText,
//         hintStyle: TextStyle(
//             color: searchHintColor,
//             fontSize: fontSize15,
//             fontWeight: FontWeight.w300)),
//   );
// }

// class MySearchDelegate extends SearchDelegate {
//   final SearchBloc searchBloc;
//   late Timer _debounce;
//   // bool searchTriggered = false;
//   MySearchDelegate({required this.searchBloc}) {
//     _debounce = Timer(Duration.zero, () {});
//   }
//   void triggerSearch(String query) {
//     if (_debounce.isActive) _debounce.cancel();
//     _debounce = Timer(Duration(milliseconds: 300), () {
//       if (query.isNotEmpty) {
//         searchBloc.add(GetSearchEvent(query));
//       }
//     });
//   }

//   @override
//   ThemeData appBarTheme(BuildContext context) {
//     return ThemeData(
//       colorScheme: ColorScheme.dark(),
//       appBarTheme: AppBarTheme(toolbarHeight: 100),
//       primaryColor: primaryColor,
//       inputDecorationTheme: InputDecorationTheme(
//         contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//         border: InputBorder.none,
//         disabledBorder:
//             OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
//         enabledBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: primaryColor),
//             borderRadius: BorderRadius.circular(15)),
//         focusedBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: primaryColor)),
//       ),
//     );
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     if (query.isNotEmpty) {
//       searchBloc.add(GetSearchEvent(query));
//     }
//     return IconButton(
//       onPressed: () {
//         if (resultsDisplayed) {
//           close(context, null);
//           BlocProvider.of<CategoryBloc>(context).add(GetCategoryEvent());
//         } else {
//           close(context, null);
//         }
//         FocusScope.of(context).unfocus();
//       },
//       icon: const Icon(Icons.arrow_back),
//     );
//   }

//   @override
//   List<Widget>? buildActions(BuildContext context) => [
//         query.isEmpty
//             ? IconButton(
//                 icon: const Icon(Icons.clear),
//                 onPressed: () {
//                   if (query.isEmpty) {
//                     close(context, null);
//                     FocusScope.of(context).unfocus();
//                   } else {
//                     query = '';
//                   }
//                 },
//               )
//             : ElevatedButton(
//                 onPressed: () async {
//                   final searchText = query;
//                   if (searchText.isNotEmpty) {
//                     searchedItems.add(query);
//                     print(searchedItems.toString());
//                     // await pref.storeSearchSuggestion(searchedItems);
//                     // searchSuggestionList = await pref.getSearchSuggestion();
//                     // print(searchSuggestionList.toString() + "0000000000");
//                     BlocProvider.of<SearchBloc>(context)
//                         .add(GetSearchEvent(searchText));
//                     showResults(
//                         context); // This method needs to be called so that it automatically displays the searched Items list.
//                   }
//                 },
//                 child: Text(
//                   'Search',
//                   style: TextStyle(color: primaryColor),
//                 ),
//               ),
//       ];

//   @override
//   Widget buildResults(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     int selectedIndex = 0;
//     List<String> filterContent = ["All", "Movies", "TvShow"];

//     return BlocBuilder<SearchBloc, SearchState>(
//       bloc: searchBloc,
//       builder: (_, state) {
//         if (state is SearchLoadingState) {
//           return Center(
//               child: CircularProgressIndicator(
//             color: primaryColor,
//             semanticsLabel: "Searching",
//           ));
//         } else if (state is SearchSuccessfulState) {
//           var searchResults = state.searchList;
//           List combinedList = [
//             ...searchResults.movies,
//             ...searchResults.tvShows
//           ];

//           return StatefulBuilder(
//               builder: (BuildContext context, StateSetter setState) {
//             print(combinedList.length.toString() +
//                 "   ==========================");
//             int listLength = 0;
//             if (selectedIndex == 0) {
//               listLength = combinedList.length;
//             } else if (selectedIndex == 1) {
//               listLength = searchResults.movies.length;
//             } else if (selectedIndex == 2) {
//               listLength = searchResults.tvShows.length;
//             }
//             return searchResults.movies.isEmpty && searchResults.tvShows.isEmpty
//                 ? Center(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "No Results Found",
//                           style: TextStyle(
//                             color: whiteColor,
//                             fontSize: fontSize16,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         RichText(
//                             textAlign: TextAlign.center,
//                             text: TextSpan(
//                                 style: TextStyle(
//                                   color: searchHintColor,
//                                   fontSize: fontSize12,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                                 children: [
//                                   TextSpan(text: "There is no result for "),
//                                   TextSpan(
//                                       text: query.toString(),
//                                       style: TextStyle(color: primaryColor)),
//                                   TextSpan(text: "\nplease try again."),
//                                 ]))
//                       ],
//                     ),
//                   )
//                 : SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           RichText(
//                               text: TextSpan(
//                                   style: TextStyle(fontSize: fontSize14),
//                                   children: [
//                                 TextSpan(
//                                     text: (listLength).toString(),
//                                     style: TextStyle(color: primaryColor)),
//                                 TextSpan(
//                                     text: " results found",
//                                     style: TextStyle(color: primaryColor))
//                               ])),
//                           const SizedBox(
//                             height: 15,
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(
//                                 height: 45,
//                                 width: width,
//                                 child: ListView.builder(
//                                     shrinkWrap: true,
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount: filterContent.length,
//                                     itemBuilder: ((context, index) {
//                                       return InkWell(
//                                         onTap: () {
//                                           setState(() {
//                                             selectedIndex = index;
//                                           });
//                                         },
//                                         child: Container(
//                                           margin: const EdgeInsets.symmetric(
//                                               horizontal: 7),
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 15, vertical: 5),
//                                           decoration: BoxDecoration(
//                                               color: selectedIndex == index
//                                                   ? whiteColor.withOpacity(0.5)
//                                                   : blackColor.withOpacity(0.6),
//                                               border: selectedIndex == index
//                                                   ? Border.all(
//                                                       color: whiteColor,
//                                                       width: 1)
//                                                   : Border.all(width: 0),
//                                               borderRadius:
//                                                   BorderRadius.circular(10)),
//                                           child: Center(
//                                             child: Text(
//                                               filterContent[index],
//                                               style: TextStyle(
//                                                   color: whiteColor,
//                                                   fontSize: fontSize18,
//                                                   fontWeight: FontWeight.w400),
//                                               textAlign: TextAlign.center,
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     })),
//                               ),
//                               const SizedBox(
//                                 height: 20,
//                               ),
//                               GridView.builder(
//                                 shrinkWrap: true,
//                                 physics: const NeverScrollableScrollPhysics(),
//                                 itemCount: listLength,
//                                 gridDelegate:
//                                     const SliverGridDelegateWithFixedCrossAxisCount(
//                                         crossAxisCount: 2,
//                                         crossAxisSpacing: 16,
//                                         mainAxisSpacing: 6),
//                                 itemBuilder: (context, index) {
//                                   var item = combinedList[index];
//                                   if (selectedIndex == 0) {
//                                     item = combinedList[index];
//                                   } else if (selectedIndex == 1) {
//                                     item = searchResults.movies[index];
//                                   } else if (selectedIndex == 2) {
//                                     item = searchResults.tvShows[index];
//                                   }
//                                   bool isMovie = item is MovieModel;
//                                   return GestureDetector(
//                                     onTap: () {
//                                       if (isMovie) {
//                                         BlocProvider.of<MoviesBloc>(context)
//                                             .add(GetMoviesEvent(searchResults
//                                                 .movies[index].id));
//                                         Navigator.of(context).push(
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     MoviesScreen(
//                                                       movieId: searchResults
//                                                           .movies[index].id,
//                                                     )));
//                                       } else {
//                                         BlocProvider.of<TvShowBloc>(context)
//                                             .add(GetTvShowEvent(searchResults
//                                                 .tvShows[index].id));
//                                         Navigator.of(context).push(
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     TvShowScreen(
//                                                       tvShowId: searchResults
//                                                           .tvShows[index].id,
//                                                     )));
//                                       }
//                                     },
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Stack(
//                                           children: [
//                                             Container(
//                                               height: 109,
//                                               width: 163,
//                                               decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(22),
//                                                   color: versionTxtColor
//                                                       .withOpacity(0.6)),
//                                             ),
//                                             Container(
//                                               height: 109,
//                                               width: 163,
//                                               decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(22),
//                                                   image: DecorationImage(
//                                                       image: NetworkImage(isMovie
//                                                           ? searchResults
//                                                               .movies[index]
//                                                               .attachments
//                                                               .movie_thumbnail
//                                                               .toString()
//                                                           : searchResults
//                                                               .tvShows[index]
//                                                               .attachments
//                                                               .tv_show_thumbnail
//                                                               .toString()),
//                                                       fit: BoxFit.cover)),
//                                             ),
//                                           ],
//                                         ),
//                                         Text(
//                                           isMovie
//                                               ? searchResults
//                                                   .movies[index].title[0].value
//                                               : searchResults.tvShows[index]
//                                                   .title[0].value,
//                                           style: TextStyle(
//                                               color: whiteColor,
//                                               fontSize: fontSize14,
//                                               fontWeight: FontWeight.w600),
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//           });
//         } else if (state is SearchFailureState) {
//           return Center(
//               child: Text("Couldn't display your Search, \nPlease Try again"));
//         }
//         return Container();
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     if (query.isNotEmpty) {
//       BlocProvider.of<SearchBloc>(context).add(GetSearchEvent(query));
//     }
//     triggerSearch(query);
//     return Container();
//   }
// }

import 'dart:async';

import 'package:avetol/core/constants.dart';
import 'package:avetol/features/home/presentation/blocs/home_bloc.dart';
import 'package:avetol/features/home/presentation/blocs/home_event.dart';
import 'package:avetol/features/home/presentation/blocs/home_state.dart';
import 'package:avetol/features/home/presentation/screens/moviesScreen.dart';
import 'package:avetol/features/home/presentation/screens/tvShowScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<String> searchedItems = [];
bool resultsDisplayed = false;
Widget searchField({
  required BuildContext context,
  required TextEditingController controller,
  required String hintText,
}) {
  controller.addListener(() {
    final query = controller.text;
    if (query.isNotEmpty) {
      BlocProvider.of<SearchBloc>(context).add(GetSearchEvent(query));
    }
  });

  return TextFormField(
    controller: controller,
    onTap: () {
      showSearch(
          context: context,
          delegate: MySearchDelegate(
              searchBloc: BlocProvider.of<SearchBloc>(context)));
    },
    //These methods won't be triggered because this text form is only used to trigger showSearch
    //
    // onFieldSubmitted: (query) async {
    //   if (query.isNotEmpty) {
    //     BlocProvider.of<SearchBloc>(context).add(GetSearchEvent(query));
    //   }
    // },
    // onChanged: (query) {
    //   // triggerSearch(query);
    //   print("111111111111111111111111111111");
    // },
    decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(26)),
        filled: true,
        fillColor: whiteColor,
        hintText: hintText,
        hintStyle: TextStyle(
            color: searchHintColor,
            fontSize: fontSize15,
            fontWeight: FontWeight.w300)),
  );
}

class MySearchDelegate extends SearchDelegate {
  final SearchBloc searchBloc;
  late Timer _debounce;
  // bool searchTriggered = false;
  MySearchDelegate({required this.searchBloc}) {
    _debounce = Timer(Duration.zero, () {});
  }
  void triggerSearch(String query) {
    if (_debounce.isActive) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: 300), () {
      if (query.isNotEmpty) {
        searchBloc.add(GetSearchEvent(query));
      }
    });
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      colorScheme: ColorScheme.dark(),
      appBarTheme: AppBarTheme(toolbarHeight: 100),
      primaryColor: primaryColor,
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        border: InputBorder.none,
        disabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor),
            borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor)),
      ),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    if (query.isNotEmpty) {
      searchBloc.add(GetSearchEvent(query));
    }
    return IconButton(
      onPressed: () {
        if (resultsDisplayed) {
          close(context, null);
          BlocProvider.of<CategoryBloc>(context).add(GetCategoryEvent());
        } else {
          close(context, null);
        }
        FocusScope.of(context).unfocus();
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        query.isEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  if (query.isEmpty) {
                    close(context, null);
                    FocusScope.of(context).unfocus();
                  } else {
                    query = '';
                  }
                },
              )
            : ElevatedButton(
                onPressed: () async {
                  final searchText = query;
                  if (searchText.isNotEmpty) {
                    searchedItems.add(query);
                    print(searchedItems.toString());
                    // await pref.storeSearchSuggestion(searchedItems);
                    // searchSuggestionList = await pref.getSearchSuggestion();
                    // print(searchSuggestionList.toString() + "0000000000");
                    BlocProvider.of<SearchBloc>(context)
                        .add(GetSearchEvent(searchText));
                    showResults(
                        context); // This method needs to be called so that it automatically displays the searched Items list.
                  }
                },
                child: Text(
                  'Search',
                  style: TextStyle(color: primaryColor),
                ),
              ),
      ];

  @override
  Widget buildResults(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      bloc: searchBloc,
      builder: (_, state) {
        print(state);
        if (state is SearchLoadingState) {
          return Center(
              child: CircularProgressIndicator(
            color: primaryColor,
            semanticsLabel: "Searching",
          ));
        } else if (state is SearchSuccessfulState) {
          var searchResults = state.searchList;
          return searchResults.movies.isEmpty && searchResults.tvShows.isEmpty
              ? Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No Results Found",
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: fontSize16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                              style: TextStyle(
                                color: searchHintColor,
                                fontSize: fontSize12,
                                fontWeight: FontWeight.w500,
                              ),
                              children: [
                                TextSpan(text: "There is no result for "),
                                TextSpan(
                                    text: query.toString(),
                                    style: TextStyle(color: primaryColor)),
                                TextSpan(text: "\nplease try again."),
                              ]))
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: TextSpan(
                                style: TextStyle(fontSize: fontSize14),
                                children: [
                              TextSpan(
                                  text: (searchResults.movies.length +
                                          searchResults.tvShows.length)
                                      .toString(),
                                  style: TextStyle(color: primaryColor)),
                              TextSpan(
                                  text: " results found",
                                  style: TextStyle(color: primaryColor))
                            ])),
                        const SizedBox(
                          height: 15,
                        ),
                        Visibility(
                          visible: searchResults.movies.isNotEmpty,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Movies",
                                style: TextStyle(
                                    color: whiteColor,
                                    fontSize: fontSize26,
                                    fontWeight: FontWeight.w900),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: searchResults.movies.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 6),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<MoviesBloc>(context).add(
                                          GetMoviesEvent(
                                              searchResults.movies[index].id));
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MoviesScreen(
                                                    movieId: searchResults
                                                        .movies[index].id,
                                                  )));
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: 109,
                                              width: 163,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(22),
                                                  color: versionTxtColor
                                                      .withOpacity(0.6)),
                                            ),
                                            Container(
                                              height: 109,
                                              width: 163,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(22),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          searchResults
                                                              .movies[index]
                                                              .attachments
                                                              .movie_thumbnail
                                                              .toString()),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          searchResults
                                              .movies[index].title[0].value,
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: fontSize14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: searchResults.tvShows.isNotEmpty,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "TvShows",
                                style: TextStyle(
                                    color: whiteColor,
                                    fontSize: fontSize26,
                                    fontWeight: FontWeight.w900),
                              ),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: searchResults.tvShows.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 16,
                                        mainAxisSpacing: 6),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<TvShowBloc>(context).add(
                                          GetTvShowEvent(
                                              searchResults.tvShows[index].id));
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  TvShowScreen(
                                                    tvShowId: searchResults
                                                        .tvShows[index].id,
                                                  )));
                                    },
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: 109,
                                              width: 163,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(22),
                                                  color: versionTxtColor
                                                      .withOpacity(0.6)),
                                            ),
                                            Container(
                                              height: 109,
                                              width: 163,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(22),
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          searchResults
                                                              .tvShows[index]
                                                              .attachments
                                                              .tv_show_thumbnail
                                                              .toString()),
                                                      fit: BoxFit.cover)),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          searchResults
                                              .tvShows[index].title[0].value,
                                          style: TextStyle(
                                              color: whiteColor,
                                              fontSize: fontSize14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
        } else if (state is SearchFailureState) {
          return Center(
              child: Text("Couldn't display your Search, \nPlease Try again"));
        }
        return Container();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isNotEmpty) {
      BlocProvider.of<SearchBloc>(context).add(GetSearchEvent(query));
    }
    triggerSearch(query);
    return Container();
  }
}
