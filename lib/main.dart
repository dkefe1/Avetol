import 'package:avetol/controller/dependencyInjection.dart';
import 'package:avetol/core/constants.dart';
import 'package:avetol/core/services/sharedPreferences.dart';
import 'package:avetol/features/auth/signin/data/dataSources/remoteDatasource/signinDatasource.dart';
import 'package:avetol/features/auth/signin/data/repositories/signinRepository.dart';
import 'package:avetol/features/auth/signin/presentation/blocs/signin_bloc.dart';
import 'package:avetol/features/auth/signup/data/dataSources/remoteDatasource/signupDatasource.dart';
import 'package:avetol/features/auth/signup/data/repositories/signupRepository.dart';
import 'package:avetol/features/auth/signup/presentation/blocs/signup_bloc.dart';
import 'package:avetol/features/guidelines/data/dataSources/guidelinesDataSource.dart';
import 'package:avetol/features/guidelines/data/repositories/guidelinesRepository.dart';
import 'package:avetol/features/guidelines/presentation/blocs/guidelines_bloc.dart';
import 'package:avetol/features/home/data/dataSources/homeDataSource.dart';
import 'package:avetol/features/home/data/repositories/homeRepository.dart';
import 'package:avetol/features/home/presentation/blocs/home_bloc.dart';
import 'package:avetol/features/onboarding/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:avetol/l10n/l10n.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PrefService();
  await prefs.storeLanguage("english");
  await prefs.storeSelectedLanguageIndex(0);
  runApp(MyApp());
  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final signupRepository = SignupRepository(SignupRemoteDatasource());
  final signinRepository = SigninRepository(SigninRemoteDatasource());
  final homeRepository = HomeRepository(HomeRemoteDataSource());
  final guidelinesRepository =
      GuidelinesRepository(GuidelinesRemoteDataSource());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SignupBloc(signupRepository),
        ),
        BlocProvider(
          create: (context) => SigninBloc(signinRepository),
        ),
        BlocProvider(
          create: (context) => CategoryBloc(homeRepository),
        ),
        BlocProvider(
          create: (context) => MoviesBloc(homeRepository),
        ),
        BlocProvider(
          create: (context) => TvShowBloc(homeRepository),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(homeRepository),
        ),
        BlocProvider(
          create: (context) => LanguageBloc(homeRepository),
        ),
        BlocProvider(
          create: (context) => SearchBloc(homeRepository),
        ),
        BlocProvider(
          create: (context) => HomePageBloc(homeRepository),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(signinRepository),
        ),
        BlocProvider(
          create: (context) => GuidelinesBloc(guidelinesRepository),
        ),
        BlocProvider(
          create: (context) => ChangePasswordBloc(signinRepository),
        ),
        BlocProvider(
          create: (context) => UpdateProfileBloc(signinRepository),
        ),
        BlocProvider(
          create: (context) => CastBloc(homeRepository),
        ),
        BlocProvider(
          create: (context) => FavoritesBloc(homeRepository),
        ),
        BlocProvider(
          create: (context) => FeedbackBloc(guidelinesRepository),
        ),
        BlocProvider(
          create: (context) => EpisodesBloc(homeRepository),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Avetol',
        theme: ThemeData(
          scaffoldBackgroundColor: blackColor,
          appBarTheme: const AppBarTheme(color: blackColor),
          fontFamily: 'Roboto',
          useMaterial3: true,
        ),
        supportedLocales: L10n.all,
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        home: SplashScreen(),
      ),
    );
  }
}
