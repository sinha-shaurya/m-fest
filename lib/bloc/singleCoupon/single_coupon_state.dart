import 'package:equatable/equatable.dart';

abstract class SingleCouponState extends Equatable {
  const SingleCouponState();
  @override
  List<Object> get props => [];
}

class SingleCouponInitial extends SingleCouponState {}

class SingleCouponLoading extends SingleCouponState {}

class SingleCouponLoaded extends SingleCouponState {
  final Map<String, dynamic> couponData;
  final Map<String, dynamic> ownerData;
  final bool isOwned;
  const SingleCouponLoaded(
      {required this.couponData,
      required this.ownerData,
      this.isOwned = false});

  @override
  List<Object> get props => [couponData, ownerData];
}

class ScanSuccess extends SingleCouponState {
  final String message;

  const ScanSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class RemoveSuccess extends SingleCouponState {
  final String message;

  const RemoveSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class SingleCouponFailed extends SingleCouponState {
  final String error;

  const SingleCouponFailed(this.error);

  @override
  List<Object> get props => [error];
}
