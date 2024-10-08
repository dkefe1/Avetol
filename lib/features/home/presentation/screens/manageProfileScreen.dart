import 'package:avetol/core/constants.dart';
import 'package:avetol/features/auth/signin/data/models/updateAvatar.dart';
import 'package:avetol/features/auth/signin/data/models/updateProfile.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_bloc.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_event.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_state.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/errorText.dart';
import 'package:avetol/features/auth/signup/presentation/widgets/submitButton.dart';
import 'package:avetol/features/common/errorFlushbar.dart';
import 'package:avetol/features/home/presentation/blocs/home_bloc.dart';
import 'package:avetol/features/home/presentation/blocs/home_state.dart';
import 'package:avetol/features/home/presentation/screens/changePassword.dart';
import 'package:avetol/features/home/presentation/screens/indexScreen.dart';
import 'package:avetol/features/home/presentation/widgets/profileDateFormField.dart';
import 'package:avetol/features/home/presentation/widgets/profilePhoneFormField.dart';
import 'package:avetol/features/home/presentation/widgets/profileTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class ManageProfile extends StatefulWidget {
  final String first_name;
  final String last_name;
  final String email;
  final String dob;
  final String phone;
  final String avatar_id;
  final String avatar_url;

  const ManageProfile(
      {required this.first_name,
      required this.last_name,
      required this.email,
      required this.dob,
      required this.phone,
      required this.avatar_id,
      required this.avatar_url,
      super.key});

  @override
  State<ManageProfile> createState() => _ManageProfileState();
}

class _ManageProfileState extends State<ManageProfile> {
  String? newAvatarId;
  String? selectedAvatar;
  final updateProfileFormKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  DateTime firstDate = DateTime.now().subtract(Duration(days: 130 * 365));
  DateTime initialDate = DateTime.now().subtract(Duration(days: 21 * 365));
  DateTime lastDate = DateTime.now().subtract(Duration(days: 21 * 365));

  bool isLoading = false;
  bool isFirstNameEmpty = false;
  bool isLastNameEmpty = false;
  bool isEmailEmpty = false;
  bool isDobEmpty = false;
  bool isNotChanged = false;

  @override
  void dispose() {
    super.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    dobController.dispose();
    phoneController.dispose();
  }

  @override
  void initState() {
    super.initState();

    selectedAvatar = widget.avatar_id.toString();
    firstNameController.text = widget.first_name;
    lastNameController.text = widget.last_name;
    emailController.text = widget.email;
    dobController.text = widget.dob;
    phoneController.text = widget.phone;

    // initialDate = DateTime.parse(widget.dob);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    phoneController.text = phoneController.text.startsWith("251")
        ? phoneController.text.substring(3).trim()
        : phoneController.text;

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
        // title: Text(
        //   "Edit Profile",
        //   style: TextStyle(
        //       color: whiteColor,
        //       fontSize: fontSize20,
        //       fontWeight: FontWeight.w900),
        // ),
      ),
      body: BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
        listener: (context, state) {
          print(state);
          if (state is UpdateProfileLoadingState) {
            isLoading = true;
          } else if (state is UpdateProfileSuccessfulState) {
            isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Profile Information Updated!"),
                backgroundColor: Colors.green, // Adjust color as needed
              ),
            );
            PersistentNavBarNavigator.pushNewScreen(context,
                screen: IndexScreen(pageIndex: 3),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino);
          } else if (state is UpdateProfileFailureState) {
            isLoading = false;
            errorFlushbar(context: context, message: state.error);
          } else if (state is UpdateAvatarSuccessfulState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Avatar Updated!"),
                backgroundColor: Colors.green, // Adjust color as needed
              ),
            );
            setState(() {
              selectedAvatar = newAvatarId;
            });
          } else if (state is UpdateAvatarFailureState) {
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    ScrollController _scrollController = ScrollController();
    return Form(
      key: updateProfileFormKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocConsumer<ProfileBloc, ProfileState>(
              listener: (context, state) {},
              builder: (context, state) {
                print(state);
                if (state is AvatarSuccessfulState) {
                  int selectedIndex = state.avatar
                      .indexWhere((avatar) => avatar.id == selectedAvatar);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController.animateTo(
                        selectedIndex * (height < 720 ? 115 : 157),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  });
                  return SizedBox(
                    width: width,
                    height: height > 700 ? 165 : 130,
                    child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: state.avatar.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              newAvatarId = state.avatar[index].id;
                              BlocProvider.of<UpdateProfileBloc>(context).add(
                                  PatchUpdateAvatarEvent(UpdateAvatar(
                                      avatar_id: newAvatarId.toString())));
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: height < 720 ? 115 : 157,
                                  width: height < 720 ? 115 : 157,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: height > 700 ? 13 : 8),
                                  decoration: BoxDecoration(
                                      border: selectedAvatar ==
                                              state.avatar[index].id
                                          ? Border.all(
                                              width: 4, color: primaryColor)
                                          : Border.all(width: 0),
                                      color: versionTxtColor.withOpacity(0.6),
                                      shape: BoxShape.circle),
                                ),
                                Container(
                                  height: height < 720 ? 115 : 157,
                                  width: height < 720 ? 115 : 157,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: height > 700 ? 13 : 8),
                                  decoration: BoxDecoration(
                                      border: selectedAvatar ==
                                              state.avatar[index].id
                                          ? Border.all(
                                              width: 4, color: primaryColor)
                                          : Border.all(width: 0),
                                      image: DecorationImage(
                                          image: NetworkImage(state
                                              .avatar[index].attachments.avatar
                                              .toString())),
                                      shape: BoxShape.circle),
                                ),
                              ],
                            ),
                          );
                        }),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
            Container(
              width: width,
              margin: const EdgeInsets.only(top: 23, bottom: 20),
              child: Text(
                'Edit Profile',
                style: TextStyle(
                    color: whiteColor,
                    fontSize: fontSize20,
                    fontWeight: FontWeight.w900),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: height < 720 ? 15 : 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  profileTextFormField(
                      controller: firstNameController,
                      labelText: "First Name",
                      onInteraction: () {
                        setState(() {
                          isFirstNameEmpty = false;
                        });
                      }),
                  isFirstNameEmpty
                      ? errorText(text: "First Name can't be empty")
                      : SizedBox.shrink(),
                  profileTextFormField(
                      controller: lastNameController,
                      labelText: "Last Name",
                      onInteraction: () {
                        setState(() {
                          isLastNameEmpty = false;
                        });
                      }),
                  isLastNameEmpty
                      ? errorText(text: "Last Name can't be empty")
                      : SizedBox.shrink(),
                  profileTextFormField(
                      controller: emailController,
                      labelText: "Email Address",
                      onInteraction: () {
                        setState(() {
                          isEmailEmpty = false;
                        });
                      }),
                  isEmailEmpty
                      ? errorText(text: "Email can't be empty")
                      : SizedBox.shrink(),
                  profileDateFormField(
                      controller: dobController,
                      hintText: "Date of Birth",
                      onPressed: () {
                        print(initialDate.toString());
                        displayDatePicker(context);
                      },
                      onInteraction: () {
                        setState(() {
                          isDobEmpty = false;
                        });
                      }),
                  isDobEmpty
                      ? errorText(text: "Date of Birth can't be empty")
                      : SizedBox.shrink(),
                  const SizedBox(
                    height: 26,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChangePasswordScreen()));
                      },
                      child: Text(
                        "Change password",
                        style: TextStyle(
                            color: primaryColor,
                            fontSize: fontSize20,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                  profilePhoneFormField(
                    controller: phoneController,
                    labelText: "Phone Number",
                  ),
                  submitButton(
                      text: "Edit Account",
                      disable: isLoading,
                      onInteraction: () {
                        if (updateProfileFormKey.currentState!.validate()) {
                          if (firstNameController.text.isEmpty) {
                            return setState(() {
                              isFirstNameEmpty = true;
                            });
                          }
                          if (lastNameController.text.isEmpty) {
                            return setState(() {
                              isLastNameEmpty = true;
                            });
                          }
                          if (emailController.text.isEmpty) {
                            return setState(() {
                              isEmailEmpty = true;
                            });
                          }
                          if (dobController.text.isEmpty) {
                            return setState(() {
                              isDobEmpty = true;
                            });
                          }
                          if (firstNameController.text == widget.first_name &&
                              lastNameController.text == widget.last_name &&
                              emailController.text == widget.email &&
                              dobController.text == widget.dob) {
                            return setState(() {
                              isNotChanged = true;
                              isNotChanged
                                  ? errorFlushbar(
                                      context: context,
                                      message: "You didn't update anything.")
                                  : SizedBox.shrink();
                            });
                          }
                          final updateProfile =
                              BlocProvider.of<UpdateProfileBloc>(context);
                          updateProfile
                              .add(PatchUpdateProfileEvent(UpdateProfile(
                            first_name: firstNameController.text,
                            last_name: lastNameController.text,
                            email: emailController.text,
                            dob: dobController.text,
                          )));
                        }
                      }),
                  const SizedBox(
                    height: 40,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future displayDatePicker(BuildContext context) async {
    var date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: whiteColor,
              onSurface: primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      final pickedDate = date.toLocal().toString().split(" ")[0];
      List<String> splittedDate = pickedDate.split("-");
      String dateFormat =
          "${splittedDate[0]}-${splittedDate[1]}-${splittedDate[2]}";
      setState(() {
        dobController.text = dateFormat;
      });
    }
  }
}
