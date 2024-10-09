import 'dart:convert';

import 'package:aash_india/bloc/auth/auth_event.dart';
import 'package:aash_india/bloc/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLogin>(_onLoginEvent);
    on<AuthCheck>(_onCheckAuthEvent);
    on<AuthRegister>(_onRegisterEvent);
    on<AuthForgotPassword>(_onForgotPasswordEvent);
    on<AuthResetPassword>(_onResetPasswordEvent);
  }
  final String baseUrl =
      dotenv.get('BASE_URL', fallback: 'http://10.0.2.2:5000');

  Future<void> _onLoginEvent(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': event.email, 'password': event.password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String token = responseData['token'];
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        emit(AuthSuccess());
      } else {
        emit(AuthFailed('Invalid credentials'));
      }
    } catch (error) {
      emit(AuthFailed(error.toString()));
    }
  }

  Future<void> _onRegisterEvent(
      AuthRegister event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': event.name,
          'email': event.email,
          'password': event.password,
          'type': event.type
        }),
      );

      if (response.statusCode == 201) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailed('Something went wrong'));
      }
    } catch (error) {
      emit(AuthFailed(error.toString()));
    }
  }

  Future<void> _onForgotPasswordEvent(
      AuthForgotPassword event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': event.email,
        }),
      );
      if (response.statusCode == 200) {
        emit(AuthOTPRequested());
      } else if (response.statusCode == 404) {
        emit(AuthFailed('Account does not exist'));
      } else {
        emit(AuthFailed('Something went wrong'));
      }
    } catch (error) {
      emit(AuthFailed(error.toString()));
    }
  }

  Future<void> _onResetPasswordEvent(
      AuthResetPassword event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': event.email,
          'newPassword': event.password,
          'otp': event.otp,
        }),
      );

      if (response.statusCode == 200) {
        emit(AuthSuccess());
      } else if (response.statusCode == 400) {
        emit(AuthFailed('Invalid OTP'));
        emit(AuthOTPRequested());
      } else {
        emit(AuthFailed('Something went wrong'));
      }
    } catch (error) {
      emit(AuthFailed(error.toString()));
    }
  }

  Future<void> _onCheckAuthEvent(
      AuthCheck event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailed('Not authenticated'));
      }
    } catch (error) {
      emit(AuthFailed(error.toString()));
    }
  }
}
