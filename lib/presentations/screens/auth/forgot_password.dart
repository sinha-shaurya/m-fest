import 'package:aash_india/bloc/auth/auth_bloc.dart';
import 'package:aash_india/bloc/auth/auth_event.dart';
import 'package:aash_india/bloc/auth/auth_state.dart';
import 'package:aash_india/core/constants/theme.dart';
import 'package:aash_india/presentations/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.errorColor,
          ));
        } else if (state is AuthOTPRequested) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('OTP successfully sent'),
            backgroundColor: Colors.green,
          ));
        } else if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Password changed successfully'),
            backgroundColor: Colors.green,
          ));
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
          } else {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
                (Route<dynamic> route) => false);
          }
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFa7c957),
                    Color(0xFF386641),
                  ],
                ),
              ),
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/logo.png'),
                      const SizedBox(height: 20),
                      Text(
                        "Forgot Password?",
                        style: TextStyle(fontSize: 32, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(36),
                        decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 0.25),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: "Email",
                                filled: true,
                                fillColor: Colors.white60,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Color(0xFF386641),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Color(0xFF386641),
                                  ),
                                ),
                                prefixIcon: const Icon(Icons.email),
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (state is AuthOTPRequested) ...[
                              TextField(
                                controller: _otpController,
                                decoration: InputDecoration(
                                  labelText: "OTP",
                                  filled: true,
                                  fillColor: Colors.white60,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Color(0xFF386641),
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Color(0xFF386641),
                                    ),
                                  ),
                                  prefixIcon: const Icon(Icons.lock),
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: "New Password",
                                  filled: true,
                                  fillColor: Colors.white60,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Color(0xFF386641),
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Color(0xFF386641),
                                    ),
                                  ),
                                  prefixIcon: const Icon(Icons.lock),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                            ElevatedButton(
                              onPressed: () {
                                if (state is AuthOTPRequested) {
                                  if (_passwordController.text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                          '* Password field cannot be blank'),
                                      backgroundColor: AppColors.errorColor,
                                    ));
                                    return;
                                  } else if (_otpController.text.isEmpty) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text('OTP is required'),
                                      backgroundColor: AppColors.errorColor,
                                    ));
                                    return;
                                  }
                                  BlocProvider.of<AuthBloc>(context).add(
                                      AuthResetPassword(
                                          email: _emailController.text,
                                          otp: _otpController.text,
                                          password: _passwordController.text));
                                } else {
                                  BlocProvider.of<AuthBloc>(context).add(
                                      AuthForgotPassword(
                                          _emailController.text));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF386641),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 120),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  if (state is AuthLoading) {
                                    return const CircularProgressIndicator();
                                  }
                                  return Text(
                                    state is AuthOTPRequested
                                        ? "Reset"
                                        : "Get OTP",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_back,
                              color: Colors.white60,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Go back",
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
