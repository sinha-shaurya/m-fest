import 'package:equatable/equatable.dart';

abstract class CouponState extends Equatable {
  const CouponState();
  @override
  List<Object> get props => [];
}

class CouponInitial extends CouponState {}

class CouponLoading extends CouponState {}

class CouponLoaded extends CouponState {
  final List<Map<String, dynamic>> coupons;
  const CouponLoaded(this.coupons);

  @override
  List<Object> get props => [coupons];
}

class LandingLoaded extends CouponState {
  final List<Map<String, dynamic>> coupons;
  final List<Map<String, dynamic>> shops;
  const LandingLoaded({required this.coupons, required this.shops});
  @override
  List<Object> get props => [coupons, shops];
}

class ManageCouponLoaded extends CouponState {
  final List<Map<String, dynamic>> coupons;
  const ManageCouponLoaded(this.coupons);

  @override
  List<Object> get props => [coupons];
}

class CouponSuccess extends CouponState {
  final String? message;
  const CouponSuccess(this.message);
}

class CouponRedeemed extends CouponState {}

class CouponFailed extends CouponState {
  final String error;

  const CouponFailed(this.error);

  @override
  List<Object> get props => [error];
}
