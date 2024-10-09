import 'package:equatable/equatable.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class PageTapped extends NavigationEvent {
  final int index;

  const PageTapped(this.index);

  @override
  List<Object> get props => [index];
}
