import 'package:avetol/features/auth/signup/data/dataSources/remoteDatasource/signupDatasource.dart';
import 'package:avetol/features/auth/signup/data/models/signup.dart';

class SignupRepository {
  SignupRemoteDatasource signupRemoteDatasource;
  SignupRepository(this.signupRemoteDatasource);

  Future signupUser(Signup signup) async {
    try {
      await signupRemoteDatasource.signupUser(signup);
    } catch (e) {
      throw e;
    }
  }
}
