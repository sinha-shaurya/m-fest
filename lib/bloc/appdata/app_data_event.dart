import 'package:equatable/equatable.dart';

abstract class AppDataEvent extends Equatable {
  const AppDataEvent();

  @override
  List<Object> get props => [];
}

class AppDataFetch extends AppDataEvent {
  const AppDataFetch();
}
