import 'package:equatable/equatable.dart';

abstract class AppDataState extends Equatable {
  const AppDataState();

  @override
  List<Object> get props => [];
}

class AppDataInitial extends AppDataState {}

class AppDataLoading extends AppDataState {}

class AppDataError extends AppDataState {
  final String error;
  const AppDataError(this.error);

  @override
  List<Object> get props => [error];
}

class AppDataLoaded extends AppDataState {
  final String address;
  const AppDataLoaded(this.address);

  @override
  List<Object> get props => [address];
}
