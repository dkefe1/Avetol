import 'package:avetol/core/constants.dart';
import 'package:avetol/core/services/sharedPreferences.dart';
import 'package:avetol/features/common/errorFlushbar.dart';
import 'package:avetol/features/common/formatDate.dart';
import 'package:avetol/features/common/getLanguageValueByKey.dart';
import 'package:avetol/features/home/data/models/genreDetail.dart';
import 'package:avetol/features/home/data/models/movieModel.dart';
import 'package:avetol/features/home/presentation/blocs/home_bloc.dart';
import 'package:avetol/features/home/presentation/blocs/home_event.dart';
import 'package:avetol/features/home/presentation/blocs/home_state.dart';
import 'package:avetol/features/home/presentation/screens/moviesScreen.dart';
import 'package:avetol/features/home/presentation/screens/tvShowScreen.dart';
import 'package:avetol/features/home/presentation/widgets/buildMovieInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final prefs = PrefService();
  var language;
  void fetchLanguage() async {
    language = await prefs.readLanguage();
  }

  bool isLoading = false;
  var listLength;
  int selectedIndex = 0;
  List<String> filterContent = ["All", "Movies", "TvShow"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchLanguage();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
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
              BlocProvider.of<CategoryBloc>(context).add(GetCategoryEvent());
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: whiteColor,
              size: 20,
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {},
        builder: (context, state) {
          print(state);
          if (state is CategoryDetailLoadingState) {
            isLoading = true;
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (state is CategoryDetailSuccessfulState) {
            return buildInitialInput(category: state.categoryDetail);
          } else if (state is CategoryDetailFailureState) {
            return errorFlushbar(context: context, message: state.error);
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildInitialInput({required GenreDetail category}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List combinedList = [...category.movies, ...category.tv_shows];

    if (selectedIndex == 0) {
      listLength = combinedList.length;
    } else if (selectedIndex == 1) {
      listLength = category.movies.length;
    } else if (selectedIndex == 2) {
      listLength = category.tv_shows.length;
    }
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
            Color(int.parse(category.color.replaceAll("#", "0xFF"))),
            blackColor
          ])),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.12,
            ),
            Center(
              child: Image.asset(
                'images/logoBlue.png',
                height: 40,
                width: 90,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Center(
                child: Text(
                  getLanguageValueByKey(category.name, language),
                  style: TextStyle(
                      color: whiteColor,
                      fontSize: fontSize40,
                      fontWeight: FontWeight.w900),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
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
                                : Border.all(width: 0),
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
            SizedBox(
              width: width,
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(27, 25, 27, 30),
                  itemCount: listLength,
                  itemBuilder: (context, index) {
                    var item = combinedList[index];
                    if (selectedIndex == 0) {
                      item = combinedList[index];
                    } else if (selectedIndex == 1) {
                      item = category.movies[index];
                    } else if (selectedIndex == 2) {
                      item = category.tv_shows[index];
                    } else {
                      item = combinedList[index];
                    }

                    bool isMovie = item is MovieModel;
                    return GestureDetector(
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
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 26),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 376,
                                  height: 221,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(22),
                                      color: versionTxtColor.withOpacity(0.6)),
                                ),
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
                              ],
                            ),
                            const SizedBox(
                              height: 10,
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
                            Text(
                              isMovie ? "Movie" : "TvShow",
                              style: TextStyle(
                                  color: durationTxtColor,
                                  fontSize: fontSize15,
                                  fontWeight: FontWeight.w500),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                            isMovie
                                ? buildMovieInfo(
                                    14,
                                    getLanguageValueByKey(
                                        category.name, language),
                                    "${convertToMinutes(item.duration).toString()} mins",
                                    formatDate(item.release_date))
                                : buildMovieInfo(
                                    14,
                                    getLanguageValueByKey(
                                        category.name, language),
                                    "${item.seasons_count} Seasons",
                                    formatDate(item.release_date))
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
