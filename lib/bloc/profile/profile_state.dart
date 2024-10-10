import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileFetched extends ProfileState {
  final String fname;
  final String lname;
  final String phone;
  final String gender;
  final String city;
  final String state;
  final String pincode;
  const ProfileFetched(
      {required this.fname,
      required this.lname,
      required this.phone,
      required this.gender,
      required this.city,
      required this.state,
      required this.pincode});
  @override
  List<Object> get props => [fname, lname, phone, gender, city, state, pincode];
}

class ProfileLoading extends ProfileState {}

class ProfileFailed extends ProfileState {
  final String message;
  const ProfileFailed(this.message);

  @override
  List<Object> get props => [message];
}
