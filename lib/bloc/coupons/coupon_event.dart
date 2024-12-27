import 'package:equatable/equatable.dart';

abstract class CouponEvent extends Equatable {
  const CouponEvent();

  @override
  List<Object> get props => [];
}

class GetAllCoupons extends CouponEvent {
  final String? city;
  final String? search;
  const GetAllCoupons({this.city = 'all', this.search});
}

class FilterCoupons extends CouponEvent {
  final String category;
  const FilterCoupons(this.category);

  @override
  List<Object> get props => [category];
}

class AvailCouponEvent extends CouponEvent {
  final String id;
  const AvailCouponEvent(this.id);

  @override
  List<Object> get props => [id];
}

class TransferCouponEvent extends CouponEvent {
  final String mobileNumber;
  final int count;

  const TransferCouponEvent({required this.mobileNumber, required this.count});
  @override
  List<Object> get props => [mobileNumber, count];
}

class GetPartnerActiveCoupons extends CouponEvent {}

class UpdateCouponAmount extends CouponEvent {
  final double amount;
  final String consumerId;
  final String couponId;
  const UpdateCouponAmount(
      {required this.amount, required this.consumerId, required this.couponId});

  @override
  List<Object> get props => [amount, consumerId, couponId];
}

class CheckRedeem extends CouponEvent {
  final String id;
  const CheckRedeem(this.id);

  @override
  List<Object> get props => [id];
}

class GetAvailedCoupons extends CouponEvent {
  const GetAvailedCoupons();
}