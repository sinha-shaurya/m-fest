import 'package:equatable/equatable.dart';

abstract class SponsorState extends Equatable {
  const SponsorState();
  @override
  List<Object> get props => [];
}

class SponsorInitial extends SponsorState {}

class SponsorLoading extends SponsorState {}

class SponsorLoaded extends SponsorState {
  final List<Map<String, dynamic>> sponsors;
  const SponsorLoaded(this.sponsors);

  @override
  List<Object> get props => [sponsors];
}

class SponsorFailed extends SponsorState {
  final String error;

  const SponsorFailed(this.error);

  @override
  List<Object> get props => [error];
}
