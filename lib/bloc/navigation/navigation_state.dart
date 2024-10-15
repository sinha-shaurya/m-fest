import 'package:equatable/equatable.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class NavigationHome extends NavigationState {}

class NavigationCategories extends NavigationState {}

class NavigationCoupon extends NavigationState {}

class NavigationProfile extends NavigationState {}
