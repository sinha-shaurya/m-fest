import 'package:aash_india/bloc/auth/auth_bloc.dart';
import 'package:aash_india/bloc/auth/auth_event.dart';
import 'package:aash_india/bloc/auth/auth_state.dart';
import 'package:aash_india/core/constants/theme.dart';
import 'package:aash_india/presentations/screens/auth/forgot_password.dart';
import 'package:aash_india/presentations/screens/auth/sign_up.dart';
import 'package:aash_india/presentations/screens/home/complete_profile.dart';
import 'package:aash_india/presentations/screens/home/home_page.dart';
import 'package:aash_india/presentations/screens/profile/waiting_approval.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isCustomer = true;
  bool _showPassword = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool remember = true;

  @override
  void dispose() {
    _emailController.dispose();
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
        } else if (state is AuthNetworkError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.errorColor,
          ));
        } else if (state is AuthNotApproved) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => WaitingApproval()),
              (Route<dynamic> route) => false);
        } else if (state is AuthIncomplete) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => CompleteProfile(
                        isCustomer: state.isCustomer,
                        name: state.name,
                      )),
              (Route<dynamic> route) => false);
        } else if (state is AuthSuccess) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFFa7c957),
        body: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(12),
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png'),
                Text(
                  'Welcome back',
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
                Text(
                  'Please enter your credentials to continue',
                  style: TextStyle(color: Colors.white60),
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
                          filled: true,
                          fillColor: Colors.white60,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Color(0xFF386641),
                            ),
                          ),
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                          fillColor: Colors.white60,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF386641))),
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              !_showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ForgotPassword()));
                            },
                            child: const Text(
                              "forgot password ?",
                              style: TextStyle(color: Color(0xFF344e41)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (BlocProvider.of<AuthBloc>(context).state
                                is AuthLoading) {
                              return;
                            } else if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('* All fields are required'),
                                backgroundColor: AppColors.errorColor,
                              ));
                              return;
                            } else {
                              BlocProvider.of<AuthBloc>(context).add(
                                AuthLogin(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF344e41),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              if (state is AuthLoading) {
                                return const CircularProgressIndicator();
                              }
                              return const Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.white60),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: const Text(
                        "Create New",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
