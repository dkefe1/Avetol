import 'package:avetol/core/constants.dart';
import 'package:avetol/core/services/sharedPreferences.dart';
import 'package:avetol/features/common/errorFlushbar.dart';
import 'package:avetol/features/common/getLanguageValueByKey.dart';
import 'package:avetol/features/home/data/models/movieModel.dart';
import 'package:avetol/features/home/data/models/tvShowModel.dart';
import 'package:avetol/features/home/presentation/blocs/home_bloc.dart';
import 'package:avetol/features/home/presentation/blocs/home_event.dart';
import 'package:avetol/features/home/presentation/blocs/home_state.dart';
import 'package:avetol/features/home/presentation/screens/indexScreen.dart';
import 'package:avetol/features/home/presentation/screens/moviesScreen.dart';
import 'package:avetol/features/home/presentation/screens/tvShowScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class OriginalsScreen extends StatefulWidget {
  const OriginalsScreen({super.key});

  @override
  State<OriginalsScreen> createState() => _OriginalsScreenState();
}

class _OriginalsScreenState extends State<OriginalsScreen> {
  final prefs = PrefService();
  var language;
  void fetchLanguage() async {
    language = await prefs.readLanguage();
  }

  bool isLoading = false;

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
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: IndexScreen(pageIndex: 0), withNavBar: false);
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
      body: BlocConsumer<HomePageBloc, HomePageState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is HomePageLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (state is HomePageSuccessfulState) {
            return buildPage(originals: state.homePage.original);
          } else if (state is HomePageFailureState) {
            return errorFlushbar(context: context, message: state.error);
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildPage({required List<dynamic> originals}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
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
          Center(
            child: Text(
              "Originals",
              style: TextStyle(
                  color: whiteColor,
                  fontSize: fontSize40,
                  fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: width,
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(27, 55, 27, 30),
                itemCount: originals.length,
                // + category[0].tv_shows.length,
                itemBuilder: (context, index) {
                  var item = originals[index];
                  bool isMovie = item is MovieModel;
                  var imageUrl = isMovie
                      ? (item as MovieModel)
                          .attachments
                          .movie_thumbnail
                          .toString()
                      : (item as TvShowModel)
                          .attachments
                          .tv_show_thumbnail
                          .toString();
                  var title = isMovie
                      ? getLanguageValueByKey(
                          (item as MovieModel).title, language)
                      : getLanguageValueByKey(
                          (item as TvShowModel).title, language);
                  var description = isMovie
                      ? getLanguageValueByKey(
                          (item as MovieModel).description, language)
                      : getLanguageValueByKey(
                          (item as TvShowModel).description, language);

                  return GestureDetector(
                    onTap: () {
                      if (isMovie) {
                        BlocProvider.of<MoviesBloc>(context)
                            .add(GetMoviesEvent((item as MovieModel).id));

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MoviesScreen(
                                  movieId: (item as MovieModel).id,
                                )));
                      } else {
                        BlocProvider.of<MoviesBloc>(context)
                            .add(GetMoviesEvent((item as TvShowModel).id));

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TvShowScreen(
                                tvShowId: (item as TvShowModel).id)));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 26),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 376,
                            height: 221,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover)),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            title,
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: fontSize20,
                                fontWeight: FontWeight.w900),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                          Text(
                            description,
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
    );
  }
}
