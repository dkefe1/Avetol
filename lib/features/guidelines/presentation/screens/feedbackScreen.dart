import 'package:avetol/core/constants.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/errorText.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:avetol/features/common/errorFlushbar.dart';
import 'package:avetol/features/guidelines/data/models/feedback.dart';
import 'package:avetol/features/guidelines/data/models/feedbackTypes.dart';
import 'package:avetol/features/guidelines/presentation/blocs/guidelines_bloc.dart';
import 'package:avetol/features/guidelines/presentation/blocs/guidelines_event.dart';
import 'package:avetol/features/guidelines/presentation/blocs/guidelines_state.dart';
import 'package:avetol/features/home/presentation/screens/indexScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({Key? key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String chosenLanguage = "English";
  String dropdownValue = "One";
  TextEditingController feedbackController = TextEditingController();

  final feedbackFormKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool feedbackEmpty = false;
  bool categoryNotSelected = false;

  FeedbackTypes? value;

  String? catId;

  List<FeedbackTypes> categories = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FeedbackBloc>(context).add(GetFeedbackTypeEvent());
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * 0.08,
        leading: IconButton(
            onPressed: () {
              PersistentNavBarNavigator.pushNewScreen(context,
                  screen: IndexScreen(pageIndex: 3),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: whiteColor.withOpacity(0.8),
            )),
      ),
      body: BlocConsumer<FeedbackBloc, FeedbackState>(
        listener: (context, state) {
          print(state);
          if (state is FeedbackTypeLoadingState) {
          } else if (state is FeedbackTypeSuccessfulState) {
            categories = state.feedbackTypes;
          } else if (state is FeedbackTypeFailureState) {
            errorFlushbar(context: context, message: state.error);
          } else if (state is FeedbackLoadingState) {
            isLoading = true;
          } else if (state is FeedbackSuccessfulState) {
            isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Feedback Submitted Successfully!"),
                backgroundColor: Colors.green, // Adjust color as needed
              ),
            );
            feedbackController.text = "";
            // successFlushBar(context: context, message: state.toString());
          } else if (state is FeedbackFailureState) {
            isLoading = false;
            errorFlushbar(context: context, message: state.error);
          }
        },
        builder: (context, state) {
          return buildInitialInput();
        },
      ),
    );
  }

  Widget buildInitialInput() {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 33, vertical: 24),
        child: Form(
          key: feedbackFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Text(
                  "Please give us you feedback. The responsible team will get to you right back.",
                  style: TextStyle(
                      color: appbarBtnColor,
                      fontSize: fontSize12,
                      fontWeight: FontWeight.w500),
                ),
              ),
              categoriesComponent(),
              if (categoryNotSelected)
                errorText(text: "Please select a category before submitting"),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 6),
                child: Text(
                  "Message",
                  style: TextStyle(
                      color: appbarBtnColor,
                      fontSize: fontSize14,
                      fontWeight: FontWeight.w400),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: dividerColor, width: 1),
                    color: otpInputFillColor,
                    borderRadius: BorderRadius.circular(4)),
                child: TextField(
                  controller: feedbackController,
                  style: const TextStyle(color: whiteColor),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                      labelText: "Message",
                      labelStyle: TextStyle(
                          color: hintColor,
                          fontSize: fontSize14,
                          fontWeight: FontWeight.w400)),
                  minLines: 5,
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {
                      feedbackEmpty = false;
                    });
                  },
                ),
              ),
              feedbackEmpty
                  ? errorText(
                      text:
                          "Please Enter your Feedback before you click Submit")
                  : SizedBox(),
              const SizedBox(
                height: 70,
              ),
              submitButton(
                disable: isLoading,
                onInteraction: () {
                  if (feedbackFormKey.currentState!.validate()) {
                    if (catId == null) {
                      return setState(() {
                        categoryNotSelected = value == null;
                      });
                    }
                    if (feedbackController.text.isEmpty) {
                      return setState(() {
                        feedbackEmpty = true;
                      });
                    }
                    print("category ID: ${catId}");
                    print("Content ${value!.title}");
                    BlocProvider.of<FeedbackBloc>(context).add(
                        PostFeedbackEvent(FeedbackModel(
                            feedback_type_id: catId!,
                            body: value!.title[0].value)));
                  }
                },
                text: isLoading ? "Submitting your Feedback..." : "Submit",
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget categoriesComponent() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: otpInputFillColor,
          border: Border.all(color: primaryColor),
          borderRadius: BorderRadius.circular(5)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<FeedbackTypes>(
            value: value,
            isExpanded: true,
            hint: Text(
              'Select Category',
              style: TextStyle(
                  color: whiteColor,
                  fontSize: fontSize14,
                  fontWeight: FontWeight.w500),
            ),
            items: categories.map(buildMenuCategories).toList(),
            icon: Icon(
              Icons.arrow_drop_down,
              color: primaryColor,
              size: 30,
            ),
            dropdownColor: otpInputFillColor,
            onChanged: (value) {
              setState(() {
                this.value = value;
                catId = value!.id.toString();
                categoryNotSelected = false;
              });
            }),
      ),
    );
  }

  DropdownMenuItem<FeedbackTypes> buildMenuCategories(FeedbackTypes category) =>
      DropdownMenuItem(
          value: category,
          child: Text(
            category.title[0].value,
            style: TextStyle(
                color: whiteColor,
                fontSize: fontSize14,
                fontWeight: FontWeight.w500),
          ));
}
