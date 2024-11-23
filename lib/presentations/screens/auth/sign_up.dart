import 'package:aash_india/bloc/auth/auth_bloc.dart';
import 'package:aash_india/bloc/auth/auth_event.dart';
import 'package:aash_india/bloc/auth/auth_state.dart';
import 'package:aash_india/core/constants/theme.dart';
import 'package:aash_india/presentations/widgets/privacy_policy.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isCustomer = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailed) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.message),
            backgroundColor: AppColors.errorColor,
          ));
        } else if (state is AuthRegistered) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Successfully registered.'),
            backgroundColor: Colors.green,
          ));
          Navigator.of(context).pop(context);
        }
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.png'),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: ToggleButtons(
                      borderRadius: BorderRadius.circular(25.0),
                      fillColor: Color(0xFF386641),
                      selectedColor: Colors.white,
                      color: Colors.black,
                      isSelected: [isCustomer, !isCustomer],
                      children: const [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Customer"),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Partner"),
                        ),
                      ],
                      onPressed: (int index) {
                        if (index == 0) {
                          setState(() {
                            isCustomer = true;
                          });
                        } else {
                          setState(() {
                            isCustomer = false;
                          });
                        }
                      },
                    ),
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
                          controller: _nameController,
                          decoration: InputDecoration(
                            fillColor: Colors.white60,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF386641),
                              ),
                            ),
                            labelText: "Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            fillColor: Colors.white60,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
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
                          obscureText: showPassword,
                          decoration: InputDecoration(
                            fillColor: Colors.white60,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF386641),
                              ),
                            ),
                            labelText: "Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _confirmPassword,
                          obscureText: true,
                          decoration: InputDecoration(
                            fillColor: Colors.white60,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF386641),
                              ),
                            ),
                            labelText: "Confirm Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.lock),
                          ),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'By clicking on register you agree to our ',
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Terms & Policy',
                                style: TextStyle(color: Color(0xFF386641)),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return PrivacyPolicy();
                                      },
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (BlocProvider.of<AuthBloc>(context).state
                                  is AuthLoading) {
                                return;
                              } else if (_nameController.text.isEmpty ||
                                  _emailController.text.isEmpty ||
                                  _passwordController.text.isEmpty ||
                                  _confirmPassword.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('* All fields are required'),
                                    backgroundColor: AppColors.errorColor,
                                  ),
                                );
                              } else if (_passwordController.text !=
                                  _confirmPassword.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('* Passwords do not match'),
                                    backgroundColor: AppColors.errorColor,
                                  ),
                                );
                              } else if (!_emailController.text.contains(RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'))) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('* Invalid email format'),
                                    backgroundColor: AppColors.errorColor,
                                  ),
                                );
                              } else if (_passwordController.text.length < 8 ||
                                  !_passwordController.text
                                      .contains(RegExp(r'[A-Z]')) ||
                                  !_passwordController.text
                                      .contains(RegExp(r'[a-z]')) ||
                                  !_passwordController.text
                                      .contains(RegExp(r'[0-9]'))) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '* Password must be at least 8 characters long and include uppercase, lowercase, and numeric characters'),
                                    backgroundColor: AppColors.errorColor,
                                  ),
                                );
                              } else {
                                BlocProvider.of<AuthBloc>(context).add(
                                  AuthRegister(
                                    name: _nameController.text,
                                    type: isCustomer ? 'customer' : 'partner',
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF386641),
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
                                  "Register",
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
                        "Already have an account?",
                        style: TextStyle(color: Colors.white60),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(context);
                        },
                        child: const Text(
                          "login",
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
      ),
    );
  }
}
