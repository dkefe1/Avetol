import 'package:avetol/core/constants.dart';
import 'package:avetol/core/services/sharedPreferences.dart';
import 'package:avetol/features/common/errorFlushbar.dart';
import 'package:avetol/features/common/getLanguageValueByKey.dart';
import 'package:avetol/features/home/data/models/category.dart';
import 'package:avetol/features/home/presentation/blocs/home_bloc.dart';
import 'package:avetol/features/home/presentation/blocs/home_event.dart';
import 'package:avetol/features/home/presentation/blocs/home_state.dart';
import 'package:avetol/features/home/presentation/screens/categoryScreen.dart';
import 'package:avetol/features/home/presentation/widgets/buildCategory.dart';
import 'package:avetol/features/home/presentation/widgets/searchField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final prefs = PrefService();
  var language;
  void fetchLanguage() async {
    language = await prefs.readLanguage();
  }

  TextEditingController searchController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchLanguage();
    BlocProvider.of<CategoryBloc>(context).add(GetCategoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {},
        builder: (context, state) {
          print(state);
          if (state is CategoryLoadingState) {
            isLoading = true;
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          } else if (state is CategorySuccessfulState) {
            isLoading = false;
            return buildInitialInput(categoryList: state.category);
          } else if (state is CategoryFailureState) {
            isLoading = false;
            return errorFlushbar(context: context, message: state.error);
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildInitialInput({required List<Category> categoryList}) {
    double height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 31),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 45,
            ),
            Text(
              "Browse",
              style: TextStyle(
                  color: whiteColor,
                  fontSize: height > 850 ? fontSize33 : fontSize28,
                  fontWeight: FontWeight.w900),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 30,
            ),
            searchField(
                context: context,
                controller: searchController,
                hintText: "What are you Looking for?"),
            const SizedBox(
              height: 25,
            ),
            GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 17,
                  mainAxisSpacing: 14,
                  childAspectRatio: 177 / 126,
                ),
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  var category = categoryList[index];
                  return buildCategory(
                      context,
                      177,
                      126,
                      Color(int.parse("0xFF${category.color_formatted}")),
                      Color(int.parse("0xFF${category.color_formatted}"))
                          .withOpacity(0),
                      getLanguageValueByKey(category.name, language), () {
                    BlocProvider.of<CategoryBloc>(context)
                        .add(GetCategoryDetailEvent(category.id));
                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: CategoryScreen(),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino);
                  });
                }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
