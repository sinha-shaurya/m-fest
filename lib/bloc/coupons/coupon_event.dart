import 'package:equatable/equatable.dart';

abstract class CouponEvent extends Equatable {
  const CouponEvent();

  @override
  List<Object> get props => [];
}

class GetAllCoupons extends CouponEvent {}

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
