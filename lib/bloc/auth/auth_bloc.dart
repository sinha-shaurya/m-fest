import 'dart:convert';
import 'dart:io';
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
    on<AuthCompleteProfile>(_onProfileComplete);
    on<AuthLogoutEvent>(_onLogout);
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
        final bool isProfileCompleted = responseData['isProfileCompleted'];
        final bool isApproved = responseData['isApproved'];
        final name = responseData['name'];
        final isCustomer = responseData['type'] == 'customer';
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        if (isProfileCompleted) {
          if (!isCustomer && !isApproved) {
            emit(AuthNotApproved());
            return;
          }
          emit(AuthSuccess());
        } else {
          emit(AuthIncomplete(name: name, isCustomer: isCustomer));
        }
      } else {
        emit(AuthFailed('Invalid credentials'));
      }
    } on SocketException {
      emit(AuthNetworkError('Network error'));
    } catch (error) {
      emit(AuthFailed('Unknown error occurred.'));
    }
  }

  Future<void> _onLogout(AuthLogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      emit(AuthLogout());
    } catch (error) {
      emit(AuthFailed('Unknown error occurred.'));
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
        emit(AuthRegistered());
      } else {
        emit(AuthFailed('Something went wrong'));
      }
    } catch (error) {
      emit(AuthFailed('Unknown error occurred.'));
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
      emit(AuthFailed('Unknown error occurred.'));
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
      emit(AuthFailed('Unknown error occurred.'));
    }
  }

  Future<void> _onProfileComplete(
      AuthCompleteProfile event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        emit(AuthFailed('User not authenticated'));
        return;
      }

      final response = await http.put(
        Uri.parse('$baseUrl/api/auth/update-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({...event.data}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['type'] == 'partner' &&
            responseData['isVerified'] == false) {
          emit(AuthNotApproved());
          return;
        }
        emit(AuthSuccess());
      } else {
        emit(AuthFailed('Something went wrong'));
      }
    } catch (error) {
      emit(AuthFailed('Unknown error occurred.'));
    }
  }

  Future<void> _onCheckAuthEvent(
      AuthCheck event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        final response = await http.get(
          Uri.parse('$baseUrl/api/auth/profile-data'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
        );
        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final isProfileCompleted = responseData['isProfileCompleted'];
          if (isProfileCompleted) {
            if (responseData['type'] == 'partner' &&
                responseData['isApproved'] == false) {
              emit(AuthNotApproved());
              return;
            }
            emit(AuthSuccess());
          } else {
            emit(AuthInitial());
          }
        } else {
          emit(AuthInitial());
        }
      } else {
        emit(AuthInitial());
      }
    } catch (error) {
      emit(AuthFailed('Unknown error occurred.'));
    }
  }
}
