import 'dart:convert';

import 'package:aash_india/bloc/singleCoupon/single_coupon_event.dart';
import 'package:aash_india/bloc/singleCoupon/single_coupon_state.dart';
import 'package:aash_india/services/local_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class SingleCouponBloc extends Bloc<SingleCouponEvent, SingleCouponState> {
  SingleCouponBloc() : super(SingleCouponInitial()) {
    on<GetCouponData>(_getSingleCoupon);
    on<CouponScanEvent>(_onCouponScan);
    on<CouponRemoveEvent>(_onCouponRemove);
  }
  final LocalStorageService _localStorageService = LocalStorageService();

  Future<void> _onCouponScan(
      CouponScanEvent event, Emitter<SingleCouponState> emit) async {
    emit(SingleCouponLoading());
    try {
      if (_localStorageService.getToken == null) {
        emit(SingleCouponFailed('User not authenticated'));
        return;
      }
      final couponResponse = await http.put(
        Uri.parse(
            '${_localStorageService.getBaseUrl}/api/coupon/update-state/${event.couponId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_localStorageService.getToken}',
        },
        body: jsonEncode({
          'partnerId': event.ownerId,
          'status': event.end ? 2 : 1,
        }),
      );
      if (couponResponse.statusCode == 200) {
        emit(ScanSuccess(
            event.end ? "Transaction completed" : "Coupon activated"));
      } else {
        emit(SingleCouponFailed('Invalid Partner'));
      }
    } catch (err) {
      emit(SingleCouponFailed('Something went wrong'));
    }
  }

  Future<void> _onCouponRemove(
      CouponRemoveEvent event, Emitter<SingleCouponState> emit) async {
    emit(SingleCouponLoading());
    try {
      if (_localStorageService.getToken == null) {
        emit(SingleCouponFailed('Unable to fetch coupon'));
        return;
      }
      final couponResponse = await http.put(
        Uri.parse(
            '${_localStorageService.getBaseUrl}/api/coupon/update-state/${event.couponId}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_localStorageService.getToken}',
        },
        body: jsonEncode({
          'partnerId': event.ownerId,
          'status': -1,
        }),
      );
      if (couponResponse.statusCode == 200) {
        emit(RemoveSuccess("Coupon removed successfully."));
      } else {
        emit(SingleCouponFailed('Error while removing coupon'));
      }
    } catch (err) {
      emit(SingleCouponFailed('Something went wrong'));
    }
  }

  Future<void> _getSingleCoupon(
      GetCouponData event, Emitter<SingleCouponState> emit) async {
    emit(SingleCouponLoading());
    try {
      if (_localStorageService.getToken == null) {
        emit(SingleCouponFailed('Unable to fetch coupon'));
        return;
      }

      final couponResponse = await http.get(
        Uri.parse(
            '${_localStorageService.getBaseUrl}/api/coupon/get/${event.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_localStorageService.getToken}',
        },
      );

      if (couponResponse.statusCode == 200) {
        final Map<String, dynamic> couponData =
            jsonDecode(couponResponse.body) as Map<String, dynamic>;

        final String ownerId = couponData['ownerId'];

        final ownerResponse = await http.get(
          Uri.parse(
              '${_localStorageService.getBaseUrl}/api/auth/getOwner/$ownerId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${_localStorageService.getToken}',
          },
        );

        if (ownerResponse.statusCode == 200) {
          final Map<String, dynamic> ownerData =
              jsonDecode(ownerResponse.body)['data'] as Map<String, dynamic>;

          final availedResponse = await http.get(
            Uri.parse('${_localStorageService.getBaseUrl}/api/coupon/availed'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${_localStorageService.getToken}',
            },
          );

          bool isRedeemed = false;

          if (availedResponse.statusCode == 200) {
            final List<dynamic> availedCoupons =
                jsonDecode(availedResponse.body);
            isRedeemed =
                availedCoupons.any((coupon) => coupon['couponId'] == event.id);
          }
          couponData['redeemed'] = isRedeemed;

          emit(SingleCouponLoaded(
            couponData: couponData,
            ownerData: ownerData,
          ));
        } else {
          emit(SingleCouponFailed('Failed to fetch owner data'));
        }
      } else {
        emit(SingleCouponFailed('Failed to fetch coupon data'));
      }
    } catch (error) {
      emit(SingleCouponFailed('An unknown error occurred.'));
    }
  }
}
