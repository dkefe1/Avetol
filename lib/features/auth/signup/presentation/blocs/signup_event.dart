import 'package:avetol/features/auth/signup/data/models/signup.dart';

abstract class SignupEvent {}

class PostSignupEvent extends SignupEvent {
  final Signup signup;

  PostSignupEvent(this.signup);
}
