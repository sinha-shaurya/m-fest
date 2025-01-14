import 'package:aash_india/bloc/auth/auth_bloc.dart';
import 'package:aash_india/bloc/auth/auth_event.dart';
import 'package:aash_india/bloc/auth/auth_state.dart';
import 'package:aash_india/core/constants/theme.dart';
import 'package:aash_india/presentations/screens/home/complete_profile.dart';
import 'package:aash_india/presentations/screens/home/home_page.dart';
import 'package:aash_india/presentations/screens/profile/waiting_approval.dart';
import 'package:aash_india/services/push_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_update/in_app_update.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool _isUpdateAvailable = false;
  final PushNotification _pushNotification = PushNotification();

  Future<void> checkForUpdate() async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        setState(() {
          _isUpdateAvailable = true;
        });
        await performUpdate();
      } else {
        if (!mounted) return;
        BlocProvider.of<AuthBloc>(context).add(AuthCheck());
      }
    } catch (e) {
      if (!mounted) return;
      BlocProvider.of<AuthBloc>(context).add(AuthCheck());
    }
  }

  Future<void> performUpdate() async {
    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (e) {
      if (!mounted) return;
      BlocProvider.of<AuthBloc>(context).add(AuthCheck());
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeApp();
    checkForUpdate();
  }

  Future<void> _initializeApp() async {
    await _pushNotification.initializeFcm();
    await _handleInitialMessage();
    if (!mounted) return;
  }

  Future<void> _handleInitialMessage() async {
    await FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        // Handle initial message
      }
    });
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
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
        if (state is AuthNotApproved) {
          _navigateToWaitingApproval(context);
          return;
        } else if (state is AuthIncomplete) {
          _navigateToCompleteProfile(context, state);
          return;
        } else if (state is AuthFailed) {
          _handleError(context, state);
          return;
        } else {
          _navigateToHome(context);
          return;
        }
      },
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 140),
              _isUpdateAvailable
                  ? CircularProgressIndicator(
                      color: const Color.fromARGB(255, 80, 156, 95),
                      strokeWidth: 8,
                    )
                  : CircularProgressIndicator(
                      color: const Color(0xFF386641),
                      strokeWidth: 8,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
