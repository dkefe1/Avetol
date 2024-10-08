import 'package:avetol/features/auth/signup/data/repositories/signupRepository.dart';
import 'package:avetol/features/auth/signup/presentation/blocs/signup_event.dart';
import 'package:avetol/features/auth/signup/presentation/blocs/signup_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupRepository signupRepository;
  SignupBloc(this.signupRepository) : super(SignupInitialState()) {
    on<PostSignupEvent>(_onPostSignupEvent);
  }

  void _onPostSignupEvent(PostSignupEvent event, Emitter emit) async {
    emit(SignupLoadingState());
    try {
      await signupRepository.signupUser(event.signup);
      emit(SignupSuccessfulState());
    } catch (e) {
      emit(SignupFailureState(e.toString()));
    }
  }
}
