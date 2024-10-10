import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLogin extends AuthEvent {
  final String email;
  final String password;

  const AuthLogin(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class AuthRegister extends AuthEvent {
  final String type;
  final String name;
  final String email;
  final String password;

  const AuthRegister(
      {required this.name,
      required this.type,
      required this.email,
      required this.password});

  @override
  List<Object> get props => [type, name, email, password];
}

class AuthForgotPassword extends AuthEvent {
  final String email;
  const AuthForgotPassword(this.email);

  @override
  List<Object> get props => [email];
}

class AuthResetPassword extends AuthEvent {
  final String email;
  final String password;
  final String otp;

  const AuthResetPassword(
      {required this.email, required this.password, required this.otp});

  @override
  List<Object> get props => [email, password, otp];
}

class AuthCheck extends AuthEvent {}

class AuthCompleteProfile extends AuthEvent {
  final Map<String, dynamic> data;

  const AuthCompleteProfile(this.data);

  @override
  List<Object> get props => [data];
}
