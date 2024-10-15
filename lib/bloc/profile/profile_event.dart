import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileFetchInfo extends ProfileEvent {}

class ProfileUpdateInfo extends ProfileEvent {
  final Map<String, dynamic> data;
  const ProfileUpdateInfo(this.data);

  @override
  List<Object> get props => [data];
}
