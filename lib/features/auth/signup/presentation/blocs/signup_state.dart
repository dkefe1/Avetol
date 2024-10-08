abstract class SignupState {}

class SignupInitialState extends SignupState {}

class SignupLoadingState extends SignupState {}

class SignupSuccessfulState extends SignupState {}

class SignupFailureState extends SignupState {
  final String error;
  SignupFailureState(this.error);
}
