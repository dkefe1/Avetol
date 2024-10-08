import 'package:avetol/features/auth/signin/data/models/changeForgotPassword.dart';
import 'package:avetol/features/auth/signin/data/models/changePassword.dart';
import 'package:avetol/features/auth/signin/data/models/forgotPasswordRequest.dart';
import 'package:avetol/features/auth/signin/data/models/otp.dart';
import 'package:avetol/features/auth/signin/data/models/signin.dart';
import 'package:avetol/features/auth/signin/data/models/updateAvatar.dart';
import 'package:avetol/features/auth/signin/data/models/updateProfile.dart';

abstract class SigninEvent {}

class PostSigninEvent extends SigninEvent {
  final Signin signin;

  PostSigninEvent(this.signin);
}

abstract class LogoutEvent {}

class DelLogoutEvent extends LogoutEvent {}

class PostForgotPasswordEvent extends SigninEvent {
  final ForgotPassword forgotPassword;
  PostForgotPasswordEvent(this.forgotPassword);
}

class PostOTPEvent extends SigninEvent {
  final OTP otp;
  PostOTPEvent(this.otp);
}

class PostChangeForgotPasswordEvent extends SigninEvent {
  final ChangeForgotPassword changeForgotPassword;
  PostChangeForgotPasswordEvent(this.changeForgotPassword);
}

abstract class ChangePasswordEvent {}

class PostChangePasswordEvent extends ChangePasswordEvent {
  final ChangePassword changePassword;
  PostChangePasswordEvent(this.changePassword);
}

abstract class UpdateProfileEvent {}

class PatchUpdateProfileEvent extends UpdateProfileEvent {
  final UpdateProfile updateProfile;
  PatchUpdateProfileEvent(this.updateProfile);
}

class PatchUpdateAvatarEvent extends UpdateProfileEvent {
  final UpdateAvatar updateAvatar;
  PatchUpdateAvatarEvent(this.updateAvatar);
}
