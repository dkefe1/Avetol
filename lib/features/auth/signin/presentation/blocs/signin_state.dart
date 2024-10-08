abstract class SigninState {}

class SigninInitialState extends SigninState {}

class SigninLoadingState extends SigninState {}

class SigninSuccessfulState extends SigninState {}

class SigninFailureState extends SigninState {
  final String error;
  SigninFailureState(this.error);
}

abstract class LogoutState {}

class LogoutInitialState extends LogoutState {}

class LogoutLoadingState extends LogoutState {}

class LogoutSuccessfulState extends LogoutState {}

class LogoutFailureState extends LogoutState {
  final String error;
  LogoutFailureState(this.error);
}

class ForgotPasswordLoadingState extends SigninState {}

class ForgotPasswordSuccessfulState extends SigninState {}

class ForgotPasswordFailureState extends SigninState {
  final String error;
  ForgotPasswordFailureState(this.error);
}

class OtpLoadingState extends SigninState {}

class OtpSuccessfulState extends SigninState {}

class OtpFailureState extends SigninState {
  final String error;
  OtpFailureState(this.error);
}

class ChangeForgotPasswordLoadingState extends SigninState {}

class ChangeForgotPasswordSuccessfulState extends SigninState {}

class ChangeForgotPasswordFailureState extends SigninState {
  final String error;
  ChangeForgotPasswordFailureState(this.error);
}

abstract class ChangePasswordState {}

class ChangePasswordInitialState extends ChangePasswordState {}

class ChangePasswordLoadingState extends ChangePasswordState {}

class ChangePasswordSuccessfulState extends ChangePasswordState {}

class ChangePasswordFailureState extends ChangePasswordState {
  final String error;
  ChangePasswordFailureState(this.error);
}

abstract class UpdateProfileState {}

class UpdateProfileInitialState extends UpdateProfileState {}

class UpdateProfileLoadingState extends UpdateProfileState {}

class UpdateProfileSuccessfulState extends UpdateProfileState {}

class UpdateProfileFailureState extends UpdateProfileState {
  final String error;
  UpdateProfileFailureState(this.error);
}

class UpdateAvatarLoadingState extends UpdateProfileState {}

class UpdateAvatarSuccessfulState extends UpdateProfileState {}

class UpdateAvatarFailureState extends UpdateProfileState {
  final String error;
  UpdateAvatarFailureState(this.error);
}
