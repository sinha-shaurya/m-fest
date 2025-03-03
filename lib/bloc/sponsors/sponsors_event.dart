import 'package:equatable/equatable.dart';

abstract class SponsorEvent extends Equatable {
  const SponsorEvent();

  @override
  List<Object> get props => [];
}

class GetAllSponsors extends SponsorEvent {
  final String? city;
  final bool isCarousel;
  const GetAllSponsors({this.city, this.isCarousel = false});

  @override
  List<Object> get props => [isCarousel];
}
