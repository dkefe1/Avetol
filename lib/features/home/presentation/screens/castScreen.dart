import 'package:avetol/core/constants.dart';
import 'package:avetol/core/services/sharedPreferences.dart';
import 'package:avetol/features/common/errorFlushbar.dart';
import 'package:avetol/features/common/formatDate.dart';
import 'package:avetol/features/home/data/models/cast.dart';
import 'package:avetol/features/common/getLanguageValueByKey.dart';
import 'package:avetol/features/home/data/models/movieModel.dart';
import 'package:avetol/features/home/presentation/blocs/home_bloc.dart';
import 'package:avetol/features/home/presentation/blocs/home_event.dart';
import 'package:avetol/features/home/presentation/blocs/home_state.dart';
import 'package:avetol/features/home/presentation/screens/moviesScreen.dart';
import 'package:avetol/features/home/presentation/widgets/buildMovieInfo.dart';
import 'package:avetol/features/home/presentation/widgets/expandableText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CastScreen extends StatefulWidget {
  final String? role;
  CastScreen({this.role, super.key});

  @override
  State<CastScreen> createState() => _CastScreenState();
}

class _CastScreenState extends State<CastScreen> {
  final prefs = PrefService();
  var language;
  void fetchLanguage() async {
    language = await prefs.readLanguage();
  }

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
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
        title: Text(
          "Cast",
          style: TextStyle(
              color: whiteColor,
              fontSize: fontSize20,
              fontWeight: FontWeight.w900),
        ),
      ),
      body: BlocConsumer<CastBloc, CastState>(
        listener: (context, state) {},
        builder: (context, state) {
          print(state);
          if (state is CastLoadingState) {
            isLoading = true;
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (state is CastSuccessfulState) {
            isLoading = false;
            return buildInitialInput(cast: state.castInfo);
          } else if (state is CastFailureState) {
            isLoading = false;
            return errorFlushbar(context: context, message: state.error);
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildInitialInput({required Cast cast}) {
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 360,
            width: width,
            child: Stack(
              children: [
                Positioned(
                  left: -70,
                  child: Container(
                    height: 328,
                    width: 328,
                    decoration: BoxDecoration(
                        gradient: RadialGradient(colors: [
                      const Color(0xFF1D49BA).withOpacity(0.51),
                      const Color(0xFF1D49BA).withOpacity(0)
                    ])),
                    child: Center(
                      child: Container(
                        height: 116,
                        width: 116,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(cast
                                    .cast.attachments.cast_avatar
                                    .toString()),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 125,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 145, right: 24),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 22,
                            ),
                            SizedBox(
                              width: width * 0.52,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getLanguageValueByKey(
                                        cast.cast.name, language),
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontSize: fontSize24,
                                        fontWeight: FontWeight.w900),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                  Text(
                                    widget.role != null
                                        ? widget.role.toString()
                                        : '',
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontSize: fontSize15,
                                        fontWeight: FontWeight.w300),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: width,
                        margin: const EdgeInsets.only(top: 50),
                        padding: const EdgeInsets.only(left: 39, right: 22),
                        child: ExpandableText(
                            text: getLanguageValueByKey(
                                cast.cast.description, language),
                            style: TextStyle(
                                color: whiteColor,
                                fontSize: fontSize15,
                                fontWeight: FontWeight.w300),
                            maxLines: 6),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 39),
            child: Text(
              'Movies/Series',
              style: TextStyle(
                  color: whiteColor,
                  fontSize: fontSize24,
                  fontWeight: FontWeight.w900),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ),
          SizedBox(
            width: width,
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(27, 11, 27, 30),
                itemCount: cast.works.length,
                itemBuilder: (context, index) {
                  var item = cast.works[index];
                  var isMovie = item is MovieModel;
                  var tileImage = isMovie
                      ? item.attachments.movie_thumbnail.toString()
                      : item.attachments.tv_show_thumbnail.toString();
                  return GestureDetector(
                    onTap: () {
                      BlocProvider.of<MoviesBloc>(context)
                          .add(GetMoviesEvent(item.id));
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              MoviesScreen(movieId: item.id)));
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
                                    image: NetworkImage(tileImage),
                                    fit: BoxFit.cover)),
                          ),
                          Text(
                            getLanguageValueByKey(item.title, language),
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
                              ? buildWorksInfo(
                                  14,
                                  "${convertToMinutes(item.duration).toString()} mins",
                                  formatDate(item.release_date))
                              : buildWorksInfo(
                                  14,
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
    );
  }
}
