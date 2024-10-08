import 'package:avetol/core/constants.dart';
import 'package:avetol/core/services/sharedPreferences.dart';
import 'package:avetol/features/common/errorFlushbar.dart';
import 'package:avetol/features/home/data/models/language.dart';
import 'package:avetol/features/home/presentation/blocs/home_bloc.dart';
import 'package:avetol/features/home/presentation/blocs/home_event.dart';
import 'package:avetol/features/home/presentation/blocs/home_state.dart';
import 'package:avetol/features/home/presentation/screens/indexScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  final prefs = PrefService();
  var selectedIndex;

  void fetchSelectedIndex() async {
    selectedIndex = await prefs.readSelectedLanguageIndex();
    print(selectedIndex);
  }

  @override
  void initState() {
    super.initState();
    fetchSelectedIndex();
    BlocProvider.of<LanguageBloc>(context).add(GetLanguageEvent());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: IndexScreen(pageIndex: 3),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: whiteColor,
              size: 18,
            )),
        toolbarHeight: height < 850 ? 70 : 90,
        title: Text(
          "Languages",
          style: TextStyle(
              color: whiteColor,
              fontSize: fontSize26,
              fontWeight: FontWeight.w900),
        ),
      ),
      body: BlocConsumer<LanguageBloc, LanguageState>(
        listener: (context, state) {},
        builder: (context, state) {
          print(state);
          if (state is LanguageLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (state is LanguageSuccessfulState) {
            return buildInitialInput(language: state.language);
          } else if (state is LanguageFailureState) {
            return errorFlushbar(context: context, message: state.error);
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildInitialInput({required List<Language> language}) {
    return ListView.builder(
        itemCount: language.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: selectedIndex == index
                ? const Icon(
                    Icons.check_circle_outline,
                    color: primaryColor,
                  )
                : SizedBox.shrink(),
            title: Text(
              language[index].name,
              style: TextStyle(color: whiteColor, fontSize: fontSize16),
            ),
            onTap: () async {
              print(await prefs.readLanguage());
              await prefs.storeLanguage(language[index].name_variable);
              await prefs.storeSelectedLanguageIndex(index);
              print(await prefs.readLanguage());
              setState(() {
                selectedIndex = index;
              });
            },
          );
        });
  }
}
