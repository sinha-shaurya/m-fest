import 'package:equatable/equatable.dart';

abstract class SponsorEvent extends Equatable {
  const SponsorEvent();

  @override
  List<Object> get props => [];
}

class GetAllSponsors extends SponsorEvent {}
