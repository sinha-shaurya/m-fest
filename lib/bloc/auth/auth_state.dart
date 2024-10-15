import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthLoading extends AuthState {}

class AuthRegistered extends AuthState {}

class AuthLogout extends AuthState {}

class AuthIncomplete extends AuthState {
  final String name;

  final bool isCustomer;
  const AuthIncomplete({required this.name, required this.isCustomer});
  @override
  List<Object> get props => [name, isCustomer];
}

class AuthFailed extends AuthState {
  final String message;
  const AuthFailed(this.message);

  @override
  List<Object> get props => [message];
}

class AuthOTPRequested extends AuthState {}
