import 'package:avetol/core/constants.dart';
import 'package:avetol/core/services/sharedPreferences.dart';
import 'package:avetol/features/common/errorFlushbar.dart';
import 'package:avetol/features/common/getLanguageValueByKey.dart';
import 'package:avetol/features/guidelines/presentation/blocs/guidelines_bloc.dart';
import 'package:avetol/features/guidelines/presentation/blocs/guidelines_event.dart';
import 'package:avetol/features/guidelines/presentation/blocs/guidelines_state.dart';
import 'package:avetol/features/home/data/models/localizedText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  final prefs = PrefService();
  var language;
  void fetchLanguage() async {
    language = await prefs.readLanguage();
  }

  @override
  void initState() {
    super.initState();
    fetchLanguage();
    BlocProvider.of<GuidelinesBloc>(context).add(GetGuidelinesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: whiteColor,
            )),
        title: Text(
          'About Us',
          style: TextStyle(
              color: whiteColor,
              fontSize: fontSize20,
              fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocConsumer<GuidelinesBloc, GuidelinesState>(
        listener: (context, state) {},
        builder: (context, state) {
          print(state);
          if (state is GuidelinesLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GuidelinesSuccessfulState) {
            return buildInitialInput(about: state.guidelines.about);
          } else if (state is GuidelinesFailureState) {
            return errorFlushbar(context: context, message: state.error);
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildInitialInput({required List<LocalizedText> about}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
                itemCount: about.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                          color: profileButtonBg,
                          borderRadius: BorderRadius.circular(7)),
                      child: Theme(
                        data: ThemeData()
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          initiallyExpanded: index == 0,
                          iconColor: primaryColor,
                          collapsedIconColor: primaryColor,
                          title: Text(
                            about[index].key,
                            style: TextStyle(
                                fontSize: fontSize14,
                                fontWeight: FontWeight.w600,
                                color: whiteColor),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                          ),
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 28),
                              child: Text(
                                getLanguageValueByKey(about, language),
                                style: TextStyle(
                                    fontSize: fontSize12,
                                    fontWeight: FontWeight.w500,
                                    color: secondaryButtonColor),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            )
                          ],
                        ),
                      ));
                }),
          ),
          const SizedBox(
            height: 80,
          )
        ],
      ),
    );
  }
}
