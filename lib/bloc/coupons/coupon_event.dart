import 'package:equatable/equatable.dart';

abstract class CouponEvent extends Equatable {
  const CouponEvent();

  @override
  List<Object> get props => [];
}

class GetAllCoupons extends CouponEvent {}

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

class CreateCouponEvent extends CouponEvent {
  final String title;
  final String category;
  final int discountPercentage;
  final DateTime validTill;
  final Map<String, dynamic>? style;
  final bool? active;
  const CreateCouponEvent(
      {required this.title,
      required this.category,
      required this.discountPercentage,
      required this.validTill,
      this.style,
      this.active = true});

  @override
  List<Object> get props => [title, category, discountPercentage, validTill];
}
