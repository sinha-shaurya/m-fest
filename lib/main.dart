import 'package:aash_india/bloc/auth/auth_bloc.dart';
import 'package:aash_india/bloc/navigation/navigation_bloc.dart';
import 'package:aash_india/bloc/profile/profile_bloc.dart';
import 'package:aash_india/core/constants/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'presentations/screens/auth/splash_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationBloc>(create: (context) => NavigationBloc()),
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<ProfileBloc>(create: (context) => ProfileBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.backgroundColor,
          progressIndicatorTheme: ProgressIndicatorThemeData(
            color: Colors.white,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
