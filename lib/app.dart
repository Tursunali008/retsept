import 'package:authentication_repository/authentication_repostory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retsept_cherno/bloc/retsept/retsept_bloc.dart';
import 'package:retsept_cherno/bloc/user/user_bloc.dart';
import 'package:retsept_cherno/services/firestore/retsept_firebase.dart';
import 'package:retsept_cherno/services/firestore/user_firestore.dart';
import 'package:retsept_cherno/tursunali/lib/bloc/authentication/bloc/authentication_bloc.dart';
import 'package:retsept_cherno/tursunali/lib/services/auth_service.dart/authentication_service.dart';
import 'package:retsept_cherno/tursunali/lib/services/user_service/user_service.dart';
import 'package:retsept_cherno/tursunali/lib/ui/login/views/login_page.dart';
import 'package:retsept_cherno/ui/screens/home_Screen.dart';
import 'package:retsept_cherno/ui/screens/splash_screen1.dart';
import 'package:user_repository/user_repostory.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthenticationService _authenticationService;
  late final UserService _userService;
  late final AuthenticationRepository _authenticationRepository;
  late final UserRepository _userRepository;

  @override
  void initState() {
    super.initState();
    _authenticationService = FirebaseAuthenticationService();
    _userService = FirebaseUserService();

    _authenticationRepository = AuthenticationRepository(
      authenticationService: _authenticationService,
    );
    _userRepository = UserRepository(userService: _userService);
  }

  @override
  void dispose() {
    _authenticationRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: _authenticationRepository,
        ),
        RepositoryProvider.value(
          value: _userRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: false,
            create: (_) => AuthenticationBloc(
              authenticationRepository: _authenticationRepository,
              userRepository: _userRepository,
            )..add(AuthenticationSubscriptionRequested()),
          ),
          BlocProvider(
            create: (context) => RetseptBloc(RetseptFirebase()),
          ),
          BlocProvider(
            create: (context) => UserBloc(UserFirestore()),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigatorKey,
      home: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          switch (state.status) {
            case AuthenticationStatus.authenticated:
              _navigatorKey.currentState!.pushReplacement(
                  MaterialPageRoute(builder: (ctx) => const HomeScreen()));
              break;
            case AuthenticationStatus.unauthenticated:
              _navigatorKey.currentState!.pushReplacement(
                  MaterialPageRoute(builder: (ctx) => const LoginPage()));
              break;
            case AuthenticationStatus.initial:
              // Could show a splash screen or similar initial view
              break;
            case AuthenticationStatus.error:
            case AuthenticationStatus.loading:
              // Handle these cases if needed
              break;
          }
        },
        child:
            const Splash1Screen(), // Replace with a splash screen or similar.
      ),
    );
  }
}
