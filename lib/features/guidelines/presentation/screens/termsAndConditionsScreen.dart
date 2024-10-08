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

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
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
          'Terms And Conditions',
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
            return buildInitialInput(
                terms: state.guidelines.terms_and_conditions);
          } else if (state is GuidelinesFailureState) {
            return errorFlushbar(context: context, message: state.error);
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildInitialInput({required List<LocalizedText> terms}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
                itemCount: terms.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 28),
                    child: Text(
                      getLanguageValueByKey(terms, language),
                      style: TextStyle(
                          fontSize: fontSize12,
                          fontWeight: FontWeight.w500,
                          color: secondaryButtonColor),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  );
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
