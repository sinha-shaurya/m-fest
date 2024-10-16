import 'package:equatable/equatable.dart';

abstract class SingleCouponEvent extends Equatable {
  const SingleCouponEvent();

  @override
  List<Object> get props => [];
}

class GetCouponData extends SingleCouponEvent {
  final String id;
  const GetCouponData(this.id);
  @override
  List<Object> get props => [id];
}
