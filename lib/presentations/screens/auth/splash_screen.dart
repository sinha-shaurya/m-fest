import 'package:aash_india/bloc/auth/auth_bloc.dart';
import 'package:aash_india/bloc/auth/auth_event.dart';
import 'package:aash_india/bloc/auth/auth_state.dart';
import 'package:aash_india/core/constants/theme.dart';
import 'package:aash_india/presentations/screens/home/complete_profile.dart';
import 'package:aash_india/presentations/screens/home/home_page.dart';
import 'package:aash_india/presentations/screens/landing/landing_page.dart';
import 'package:aash_india/presentations/screens/profile/waiting_approval.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(AuthCheck());
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
      (Route<dynamic> route) => false,
    );
  }

  void _navigateToLanding(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LandingPage()),
      (Route<dynamic> route) => false,
    );
  }

  void _navigateToWaitingApproval(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WaitingApproval()),
      (Route<dynamic> route) => false,
    );
  }

  void _navigateToCompleteProfile(BuildContext context, AuthIncomplete state) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => CompleteProfile(
          name: state.name,
          isCustomer: state.isCustomer,
        ),
      ),
    );
  }

  void _handleError(BuildContext context, AuthFailed state) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(state.message),
      backgroundColor: AppColors.errorColor,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        _navigateToHome(context);
        return;
        // if (state is AuthSuccess) {
        //   _navigateToHome(context);
        //   return;
        // } else if (state is AuthNotApproved) {
        //   _navigateToWaitingApproval(context);
        //   return;
        // } else if (state is AuthIncomplete) {
        //   _navigateToCompleteProfile(context, state);
        //   return;
        // } else if (state is AuthFailed) {
        //   _handleError(context, state);
        //   return;
        // } else {
        //   _navigateToLanding(context);
        //   return;
        // }
      },
      child: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              CircularProgressIndicator(
                color: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
